function Udot = udot3_adapt_jaw(t,U)
% to be explained ...

global A0 X0 Y0 X0Y0

NN = 13;
MM = 17;

global X Y XY FXY tf

% Variables concernant le contact
global Point_P pente_P nbpalais org_P  pente_L org_L angle_reaction

% Variables concernant le poids
global invMass

% Variables contenant les lambdas des fibres
global LAMBDA_GGP LAMBDA_GGA LAMBDA_Stylo1 LAMBDA_Stylo2 LAMBDA_Hyo1
global LAMBDA_Hyo2 LAMBDA_Hyo3 LAMBDA_SL LAMBDA_IL LAMBDA_Vert

% Variables recevant les forces de chaque muscle
global ForceGGA ForceGGP ForceHyo ForceStylo1 ForceStylo2 ForceSL
global ForceVert;

% Variables globales temporaires
global aff_fin t_affiche t_verbose nb_contact
global S_enr X_enr Yn_enr Yp_enr F_enr P_enr V_enr
global nc pc t_jaw

% Variables pre-initialisees
global NNxMM NNx2 NNxMMx2   % Des multiplications...
global F                    % Constante et matrice de frottement
global PXY                  % Poids
global v1                   % Variable temporaires

global first_contact
global kkk t_initial t_final theta theta_ll dist_lip 
global dist_hyoid lar_ar_mri tongue_lar_mri pharynx_mri
global dents_inf lowlip upperlip U_dents_inf U_lowlip U_upperlip
global U_lar_ar_mri U_tongue_lar_mri U_pharynx_mri

global t_i ttout length_ttout X0_seq Y0_seq X_origin Y_origin U_X_origin 
global U_Y_origin old_t

% Initialisation
if (kkk == 0)
    first_contact = 0;
    t_jaw = 0;
    U_lowlip = [];
    U_upperlip = [];
    U_lar_ar_mri = [];
    U_tongue_lar_mri = [];
    U_pharynx_mri = [];
    U_dents_inf = [];
    length_ttout = 0;
    X0_seq = [];
    Y0_seq = [];
    old_t = t_initial;
end

kkk = kkk + 1;
t_i = round(1000*t)+1;
FXY = PXY;

% Calculate the rotation and translation of the jaw
if ((t-t_jaw >= 0.001) && (t <=t_final) && ...
        (theta~=0 || theta_ll~=0 || dist_lip~=0 || dist_hyoid~=0))
    
    [new_X0, new_Y0] = jaw_trans(t);
    
    t_jaw = t;
    
    if theta ~= 0
        X0 = new_X0;
        Y0 = new_Y0;
        for i = 1:MM
            for j = 1:NN
                X0Y0((i-1)*NNx2+2*j-1,1) = X0(i,j);
                X0Y0((i-1)*NNx2+2*j,1) = Y0(i,j);
            end
        end
    end
end

if (length(ttout) > length_ttout)
    
    length_ttout = length_ttout + 1;
    U_X_origin(length_ttout) = X_origin;
    U_Y_origin(length_ttout) = Y_origin;
    U_lowlip(length_ttout,:) = [lowlip(1,:) lowlip(2,:)];
    U_upperlip(length_ttout,:) = [upperlip(1,:) upperlip(2,:)];
    U_dents_inf(length_ttout,:) = [dents_inf(1,:) dents_inf(2,:)];
    U_lar_ar_mri(length_ttout,:) = [lar_ar_mri(1,:) lar_ar_mri(2,:)];
    U_tongue_lar_mri(length_ttout,:) = [tongue_lar_mri(1,:) tongue_lar_mri(2,:)];
    U_pharynx_mri(length_ttout,:) = [pharynx_mri(1,:) pharynx_mri(2,:)];
    X0_t = X0';
    Y0_t = Y0';
    X0_seq(length_ttout, :) = X0_t(:)';
    Y0_seq(length_ttout, :) = Y0_t(:)';
end

% Calculating new positions of the nodes; XY is calculated from the 
% initial X0 and Y0 and displacement U.
u = U(1:NNxMMx2, 1);

for i = 1:MM
    for j = 1:NN
        
        v1 = (i-1)*NNx2+2*j;
        X(i,j) = X0(i,j)+u(v1-1);
        Y(i,j) = Y0(i,j)+u(v1);
        XY(v1-1,1) = X(i,j);
        XY(v1,1) = Y(i,j);
        
    end
end

% not affect muscles which have the value of lambda rest position
lambda_tmp = sparse(comLambda_adapt_jaw(t));    

% Assigning each muscle a lambda value
for i = 1:7
    LAMBDA_GGP(i) = lambda_tmp(i);
end

for i = 8:13
    LAMBDA_GGA(i-7) = lambda_tmp(i);
end

LAMBDA_Stylo1 = lambda_tmp(14);
LAMBDA_Stylo2 = lambda_tmp(15);
LAMBDA_Hyo1 = lambda_tmp(16);
LAMBDA_Hyo2 = lambda_tmp(17);
LAMBDA_Hyo3 = lambda_tmp(18);
LAMBDA_SL = lambda_tmp(19);
LAMBDA_IL = lambda_tmp(20);

for i = 21:26
    LAMBDA_Vert(i-21+1) = lambda_tmp(i);
end
clear lambda_tmp

% calculate force FXY of each muscle aplied on XY
GGP(U);
GGA(U);
STYLO(U);
HYO(U);
SL(U);
IL(U);
VERT(U);

% genio-hyoid: resistance to the tongue root
for i = 2:NN-1
    FXY(2*i-1) = (X0(1,i) - XY(2*i - 1)) * 2;
    FXY(2*i) = (Y0(1,i) - XY(2*i)) * 2;
end

% compute contact with teeth -------------------------------------
global Point_dents
global Vect_dents

for i = 217:-1:213
    vect_tongue = [XY(2*i-1)-Point_dents(1) XY(2*i)-Point_dents(2)];
    psi = vect_tongue(1)*Vect_dents(2) - vect_tongue(2)*Vect_dents(1);
    
    if (psi < 0)
        FXY(2*i-1) = FXY(2*i-1) - (psi * 0.6);
        FXY(2*i) = FXY(2*i) - (psi * 0.3);
    end
end

imin = 215;
imax = 219;
for i = imin:imax
    pente_L(i) = (XY(2*i)-XY(2*i+2))/(XY(2*i-1)-XY(2*i+1));
    org_L(i) = XY(2*i)-pente_L(i)*XY(2*i-1);
    Xcontact(i) = 0;
    Ycontact(i) = 0;
end


% ----------------------------------------------------------------------------
% Calcul du contact avec le palais
% Les equations des segments du palais sont calculees dans SIMULATION4.m
% On verifie ici que les noeuds superieurs de la langue n'entrent pas
% en contact avec le palais en testant des intersections de segments.
% Si il y a contact, on cree une force s'ajoutant a FXY qui s'oppose au
% mouvement (reaction du palais)
% Il y a 2 cas possibles :
% 1er cas :
% il y a 2 contacts sur le meme segment du palais
%
%                   XY(2*i)
%                      /\
%       Xcontact(i) ->/  \<- Xcontact(i-NN)
%           O~~~~~~~~/~~~~\~~~~~~~O
%                   /      \
%                  /        \
%         --------/          \--------
%                        XY(2*i-2*NN)
%
% 2e cas :
% il y a contact sur un segment de palais precedent et sur celui-ci
%
%                   XY(2*i)
%                       /\
%                      /  \
%       Xcontact(i) ->/    \<- Xcontact(oldi) oldi=i-NN ou i-2NN ou i-3NN
%          O~~~~~~~~~/~~~O__\_______O
%                   /    |   \
%                  /  Point_P \
%                 /            \-------------
%          ------/         XY(2*i-2*NN)
%
%
% Calcul des equations de droite entre chaque noeuds superieurs de la
% langue.
% Ces equations sont de la forme :
% Y = pente_L(i) * X + org_L(i)

imin = 91;
imax = 208;
for i = imin:NN:imax
    pente_L(i) = (XY(2*i)-XY(2*i+2*NN)) / (XY(2*i-1)-XY(2*i-1+2*NN));
    org_L(i) = XY(2*i) - pente_L(i)*XY(2*i-1);
    % Xcontact contains the coordinates of the point of intersection
    Xcontact(i) = 0;
    Ycontact(i) = 0;
end

% table of index of the nodes that come into contact
neucontact = 0;

% Detection of contacts

% loop for nodes of palate and velum
for j = nbpalais-1:-1:1
    % loop for tongue nodes
    for i = imin:NN:imax
        
        if pente_L(i) ~= pente_P(j)
            
            X_c = (org_L(i)-org_P(j)) / (pente_P(j)-pente_L(i));
            % Verification que le contact est bien sur les segments
            % Position X correcte ?
            if (X_c<=XY(2*i-1))&&(X_c>=XY(2*i-1+2*NN))&&(X_c<=Point_P(2*j+1))&&(X_c>=Point_P(2*j-1))
                Y_c=pente_L(i)*X_c+org_L(i);
                % Position Y correcte ?
                if (Y_c<=max(Point_P(2*j+2),Point_P(2*j)))&&(Y_c>=min(Point_P(2*j+2),Point_P(2*j)))
                    Xcontact(i)=X_c;
                    Ycontact(i)=Y_c;
                    % Y a-t-il eu contact precedemment ?
                    oldi=i-NN;
                    while (Xcontact(oldi)==0)&&(oldi>=imin)
                        oldi=oldi-NN;
                    end
                    % Creation de la force de collision
                    if oldi ~= imin-NN
                        
                        if nb_contact == 0
                            fprintf('Premier contact au noeud %d sur le segment %d a %d %%\n',2*i-1,j,round(100*t/tf));
                            nc = 2*i;
                            pc = j;
                            first_contact = 1;
                            
                            % because we want to memorize the previous node
                            nc = nc + 2*NN;
                            pc = pc - 1;
                            
                        end
                        
                        surface_c = sqrt((Xcontact(i)-Xcontact(oldi))^2+(Ycontact(i)-Ycontact(oldi))^2);
                        pa = (Ycontact(oldi)-Ycontact(i))/(Xcontact(oldi)-Xcontact(i));
                        Xortho = (XY(2*i)+XY(2*i-1)/pa-Ycontact(oldi)+pa*Xcontact(oldi))/(pa+1/pa);
                        Yortho = pa*(Xortho-Xcontact(oldi))+Ycontact(oldi);
                        distance = sqrt((XY(2*i-1)-Xortho)^2+(XY(2*i)-Yortho)^2);
                        angle_reaction = atan((Xortho-XY(2*i-1))/(XY(2*i)-Yortho));
                        
                        if (U(2*NNxMM+2*i)/sqrt(U(2*NNxMM+2*i)*U(2*NNxMM+2*i-1)))>sin(angle_reaction)
                            vitesse_contact=U(2*NNxMM+2*i)*cos(angle_reaction)+U(2*NNxMM+2*i-1)*abs(sin(angle_reaction));
                        else
                            vitesse_contact=U(2*NNxMM+2*i)*cos(angle_reaction)-U(2*NNxMM+2*i-1)*abs(sin(angle_reaction));
                        end
                        
                        force_reaction = (60+0.5*vitesse_contact)*(surface_c*distance)^0.8;
                        % Direction de cette force
                        % Elle est dirigee suivant la plus courte distance entre le
                        % noeud qui depasse et le palais : elle est donc
                        % perpendiculaire aux 2 points de contact
                        FXY(2*i-1) = FXY(2*i-1)+force_reaction*sin(angle_reaction);
                        FXY(2*i) = FXY(2*i)-force_reaction*cos(angle_reaction);
                        Xcontact(i) = 0;
                        Ycontact(i) = 0;
                        Xcontact(oldi) = 0;
                        Ycontact(oldi) = 0;
                        nb_contact = nb_contact+1;
                        F_enr(t_i) = sqrt(FXY(2*i-1)^2+FXY(2*i)^2);
                        S_enr(t_i) = surface_c;
                        P_enr(t_i) = distance;
                        neucontact(size(neucontact,2)+1) = i;
                    end
                end
                
            elseif (aff_fin==0)&&(pc==j)&&(nc==2*i)&&(nb_contact~=0)&&(t>=tf/2)
                fprintf('Fin du contact a %d %%\n',round(100*t/tf));
                aff_fin=1;
            end
            
        end % fin du non parallele
    end
end

% ------------------------------------------------------------------------

% display tongue contour every 0.02 s
global TEMPS_FINAL_CUM

if t >= t_affiche

    t_affiche = t_affiche + 0.002;

    % the red line between tongue and larynx
    plot([X(1,13) tongue_lar_mri(1,1)], [Y(1,13) tongue_lar_mri(2,1)],'r-')

    % plot tongue
    plot(X(1:MM,NN),Y(1:MM,NN), 'k-');
    plot(X(MM,1:NN),Y(MM,1:NN), 'k-');
    plot(lowlip(1,:),lowlip(2,:), 'k-');
    plot(dents_inf(1,:),dents_inf(2,:), 'k-');
    plot(X_origin, Y_origin, 'ko');

    plot([pharynx_mri(1,end) lar_ar_mri(1,1)], [pharynx_mri(2,end) lar_ar_mri(2,1)], 'c-')

    drawnow
end

if t >= t_verbose
    t_verbose = t_verbose+0.005;
    t_calcul = round(toc*(TEMPS_FINAL_CUM(length(TEMPS_FINAL_CUM)) / t - 1));
    hour = floor(t_calcul/3600);
    minute = floor((t_calcul-3600*hour)/60);
    second = t_calcul - 3600*hour - 60*minute;
    fprintf('%d %% - time left: %d h %d min %d s\n',round(100*t/tf), hour, minute, second);
end


% Here we calculate the coordinates of the first node that have contact
if first_contact == 1
    
    X_enr(t_i) = XY(nc-1);
    Yn_enr(t_i) = XY(nc);
    Yp_enr(t_i) = pente_P(pc)*X_enr(t_i) + org_P(pc);
    
    if (U(2*NNxMM+nc)/sqrt(U(2*NNxMM+nc)*U(2*NNxMM+nc-1)))>sin(angle_reaction)
        V_enr(t_i)=U(2*NNxMM+nc)*cos(angle_reaction)+U(2*NNxMM+nc-1)*abs(sin(angle_reaction));
    else
        V_enr(t_i)=U(2*NNxMM+nc)*cos(angle_reaction)-U(2*NNxMM+nc-1)*abs(sin(angle_reaction));
    end
    first_contact = 0;
end

% calculate new elasticity matrix as a function of muscle contraction
global CALC_ELA

if CALC_ELA
    A0 = elast2(sum(ForceGGA)/6, sum(ForceGGP)/7, sum(ForceHyo)/3, ...
        (ForceStylo1+ForceStylo2)/2, ForceSL , sum(ForceVert)/6, ...
        neucontact);
end

% Calcul de UDOT -------------------------------------------------------
U(NNx2-1,1) = 0;
U(NNx2,1) = 0;
for j = 1:13:209
    U(2*j-1,1) = 0;
    U(2*j,1) = 0;
end

U(NNx2-1+NNxMMx2,1) = 0;
U(2*(NN-1)+2 + 2*NNxMM,1) = 0;
for j = 1:NN:209
    U(2*j-1 + 2*NNxMM,1) = 0;
    U(2*j + 2*NNxMM,1) = 0;
end

Udot = [U(2*NNxMM+1:4*NNxMM,1); ...
    invMass*(FXY-A0*U(1:2*NNxMM,1)-F*U(2*NNxMM+1:4*NNxMM,1))];

for j=1:NN:209
    Udot(2*j-1 + 2*NNxMM,1)=0;
    Udot(2*j + 2*NNxMM,1)=0;
end
Udot(2*(NN-1)+1 + 2*NNxMM,1)=0;
Udot(2*(NN-1)+2 + 2*NNxMM,1)=0;

for j=1:NN:209
    Udot(2*j-1,1) = 0;
    Udot(2*j,1) = 0;
end
Udot(2*(NN-1)+1,1) = 0;
Udot(2*(NN-1)+2,1) = 0;


% calculate matrix of forces at any timepoint
global TEMPS
global FXY_T
global ACCL_T

TEMPS(t_i) = t;
FXY_T(t_i, :) = FXY.';

% calculate matrix for accelaration at any timepoint
ACCL_T(t_i, :) = Udot(2*NNxMM+1:4*NNxMM).';

end
