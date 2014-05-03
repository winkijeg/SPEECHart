function Udot = udot3_adapt_jaw(t,U)
% CV - 03/03/99
% Modifications :
%    - Optimisation des boucles et des calculs
%    - Ajout d'une phase d'initialisation
%    - Cacul prealable des nodes d'attache des muscles
%    - Calcul de l'effet de chaque muscle dans une fonction separee

% Modifications :
%    - Modification de l'algorithme de detection du contact
%      langue/palais : le contact peut maintenant se faire sur 2
%      segments non consecutifs
%    - Nouvel algorithme de detection de collision pour le contact
%    langue/dents inferieures : modifications des variables liees aux
%    dents inferieures
%    - Calcul du temps de calcul restant
%    - Calcul des rho_#muscles# dans Simulation4
%    - Erreur dans la variable 'l' du Vert
%    - Remplacement dans le calcul des forces de 'activ1>=0' par
%      'activ>0'
%    - Changement du calcul des forces du SL
%    - Recalcul a chaque instant de la matrice d'elasticite, en
%      appelant la fonction elast.m
%    - deux fois plus de fibres (si fact=2) pour le GGP, le GGA et le
%      Vert
%    - Modification de l'algorithme de collision


% Plus de modifications :
%    - On va travailler avec comlambda.m (plus general) au lieu de COMLAMBDA.m

% Modifications apportees :
%    - ajout de commentaires
%    - Le calcul de l'inverse de la matrice de masse s'effectue dans
%      le fichier SIMULATION2.m : on utilise ici la matrice invMass
%    - Formalisation des indices dans le calcul des forces : on peut
%      ainsi modifier le nombre d'elements en modifiant uniquement NN et MM
%    - Etude du contact langue / palais pour un seul point de contact
%      On calcule l'intersection des droites, des segments, la surface
%      de contact et la profondeur
%
%    - Le calcul de la force de pesanteur se fait avec les valeurs
%    'exactes' de masse de chaque noeud calculees dans Simulation4.m


% Le temps t intervient pour le calcul des LAMBDA via le programme
% matlab COMLAMBDA.m
% Creation de l'equation differentielle :
% M.U'' + f.U' +K(U,U',lambda).U = F(U,U',lambda) + P
% qui est resolue par la commande ODE45 de MATLAB


global A0;
global X0;
global Y0;
global X0Y0;
global NN;
global MM;
global fact;
global lambda;
global mu;
global X;
global Y;
global XY;
global FXY;
global H;
global G;
global XS;
global YS;
global X1;
global Y1;
global X2;
global Y2;
global X3;
global Y3;
global tf;
global nb_transitions;
global tfin_closion;

% Longueurs au repos des muscles
global longrepos_GGP;
global longrepos_GGA;
global longrepos_Hyo;
global longrepos_Stylo;
global longrepos_SL;
global longrepos_IL;
global longrepos_Vert;

global longrepos_GGA_max longrepos_GGP_max longrepos_Hyo_max longrepos_IL_max longrepos_SL_max longrepos_Stylo_max longrepos_Vert_max %PP Nov 06

% Variables de sections des muscles
global rho_GG;
global rho_Hyo;
global rho_Stylo;
global rho_SL;
global rho_IL;
global rho_Vert;

% Variables concernant le contact
global Point_dent;
global pente_D;
global org_D;
global Point_P;
global pente_P;
global nbpdent;
global nbpalais;
global org_P;
global pente_L;
global org_L;
global angle_reaction;

% Variables concernant le poids
global Mass;
global invMass;

% Variables contenant les lambdas des fibres
global LAMBDA_GGP;
global LAMBDA_GGA;
global LAMBDA_Stylo1;
global LAMBDA_Stylo2;
global LAMBDA_Hyo1;
global LAMBDA_Hyo2;
global LAMBDA_Hyo3;
global LAMBDA_SL;
global LAMBDA_IL;
global LAMBDA_Vert;

% Variables recevant les forces de chaque muscle
global ForceGGA;
global ForceGGP;
global ForceHyo;
global ForceStylo1 ForceStylo2;
global ForceSL;
global ForceIL;
global ForceVert;

% Variables definissant les points d'attache des muscles
global Att_GGP;
global Att_GGA;
global Att_Hyo;
global Att_Stylo;
global Att_SL;
global Att_IL;
global Att_Vert;

% Semaphore pour le calcul de la pression
global DoPress;

% Variables globales temporaires
global aff_fin;
global t_affiche;
global t_verbose;
global nb_contact;
global S_enr;
global X_enr;
global Yn_enr;
global Yp_enr;
global F_enr;
global P_enr;
global V_enr;
global nc;
global pc;
global t_jaw;


% Variables pre-initialisees
global NNxMM NNx2 MMx2 NNxMMx2; % Des multiplications...
global f1 f2 f3 f4 f5;          % Coefficients p. le calcul des forces
global MU c;                    % Idem
global f F;                     % Constante et matrice de frottement
global PXY;                     % Poids
global v1 v2 v3;                % Variables temporaires


global first_contact;				%modified by Yohan & Majid; Nov 30, 99
global kkk t_initial t_transition t_final theta theta_ll dist_lip hyoid_movment dist_hyoid Hyoid_corps lar_ar_mri tongue_lar_mri pharynx_mri
global dents_inf lar_ar lowlip palate pharynx tongue_lar upperlip velum U_dents_inf U_lowlip U_upperlip hyoid_i_abs
global U_lar_ar_mri U_tongue_lar_mri U_pharynx_mri

global t_i ttout length_ttout X0_seq Y0_seq X_origin Y_origin U_X_origin U_Y_origin old_t;
% ----------------------------------------------------------------------
% Initialisations cycliques
if kkk==0	%modified by Yohan & Majid; Nov 30, 99
    first_contact = 0;
    t_jaw=0;
    U_lowlip=[];
    U_upperlip=[];
    U_lar_ar_mri = [];
    U_tongue_lar_mri = [];
    U_pharynx_mri = [];
    U_dents_inf=[];
    length_ttout=0;
    X0_seq=[];
    Y0_seq=[];
    old_t=t_initial;
end

kkk=kkk+1;
t_i=round(1000*t)+1;
FXY = PXY;

% Calculate the rotation and translation of the jaw -- MZ 12/27/99
if t-t_jaw>=0.001 && t<=t_final && (theta~=0 || theta_ll~=0 || dist_lip~=0 || dist_hyoid~=0) % GB MARS 2011
    [new_X0, new_Y0]=jaw_trans(t);
    t_jaw=t;
    if theta~=0
        X0=new_X0;
        Y0=new_Y0;
        for i=1:MM
            for j=1:NN
                X0Y0((i-1)*NNx2+2*j-1,1)=X0(i,j);
                X0Y0((i-1)*NNx2+2*j,1)=Y0(i,j);
            end
        end
    end
end
if length(ttout)>length_ttout
    length_ttout=length_ttout+1;
    U_X_origin(length_ttout)=X_origin;
    U_Y_origin(length_ttout)=Y_origin;
    U_lowlip(length_ttout,:)=[lowlip(1,:) lowlip(2,:)];
    U_upperlip(length_ttout,:)=[upperlip(1,:) upperlip(2,:)];
    U_dents_inf(length_ttout,:)=[dents_inf(1,:) dents_inf(2,:)];
    U_lar_ar_mri(length_ttout,:)=[lar_ar_mri(1,:) lar_ar_mri(2,:)];
    U_tongue_lar_mri(length_ttout,:)=[tongue_lar_mri(1,:) tongue_lar_mri(2,:)];
    U_pharynx_mri(length_ttout,:)=[pharynx_mri(1,:) pharynx_mri(2,:)];
    X0_t = X0'; % PP GB Avril 2011
    Y0_t = Y0'; % PP GB Avril 2011
    X0_seq(length_ttout,:)=X0_t(:)';  % On renverse la matrice pour obtenir la bonne configuration
    Y0_seq(length_ttout,:)=Y0_t(:)';
end
% ---------------------------------------------------------------------
% Calcul des nouvelles positions des noeuds :
% XY est calcule a partir des X0 et Y0 initiaux et du deplacement U.

u=U(1:NNxMMx2,1);
for i=1:MM
    for j=1:NN
        v1=(i-1)*NNx2+2*j;
        X(i,j)=X0(i,j)+u(v1-1);
        Y(i,j)=Y0(i,j)+u(v1);
        XY(v1-1,1)=X(i,j);
        XY(v1,1)=Y(i,j);
    end
end


% ---------------------------------------------------------------
% Calcul de lambda a l'instant t grace a la fonction COMLAMBDA
LAMBDA = sparse(comLambda_adapt_jaw(t));    % Plusieurs transitions (pas d'influence
%            des muscles dont les lambdas ont la valeur de repos)
% Attribution de chaque lambda aux muscles
for i=1:1+3*fact
    LAMBDA_GGP(i)=LAMBDA(i);
end
for i=2+3*fact:1+6*fact % 6 fibres dans le cas a 221 noeuds et 3 a 63 noeuds
    LAMBDA_GGA(i-3*fact-1)=LAMBDA(i);
end
i=1+6*fact;
LAMBDA_Stylo1=LAMBDA(i+1);
LAMBDA_Stylo2=LAMBDA(i+2);
LAMBDA_Hyo1=LAMBDA(i+3);
LAMBDA_Hyo2=LAMBDA(i+4);
LAMBDA_Hyo3=LAMBDA(i+5);
LAMBDA_SL=LAMBDA(i+6);
LAMBDA_IL=LAMBDA(i+7);
j=i+8;
for i=j:j+3*fact-1 % Modifs Dec 99 YP-PP
    LAMBDA_Vert(i-j+1)=LAMBDA(i);
end
clear LAMBDA;
% ---------------------------------------------------------------
% Calcul pour chaque muscle de la force FXY qui s'applique en XY
GGP(U);
GGA(U);
STYLO(U);
HYO(U);
SL(U);
IL(U);
VERT(U);
if DoPress
    PRESS(t);
end
% Genio-Hyoidien : resistance a la racine de la langue
for i=2:NN-1
    FXY(2*i-1)=(X0(1,i)-XY(2*i-1))*2;
    FXY(2*i)=(Y0(1,i)-XY(2*i))*2;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONTACT AVEC LES DENTS (FACON 1)

% ----------------------------------------------------------------------------
% Calcul du contact avec les dents
% L'equation de droite des dents est calculee dans Simulation4.m
% On calcule les segments de droite de la langue qui pourraient
% entrer en collision avec les dents
% Pour l'explication des algorithmes, voir "contact langue palais"
global Point_dents;
global Vect_dents;
for i=8*fact*NN+1+4*fact:-1:8*fact*NN+1+2*fact % Modif. Dec 99 pour descendre plus bas sur les contacts des dents
    Vect_tongue=[XY(2*i-1)-Point_dents(1) XY(2*i)-Point_dents(2)];
    psi=Vect_tongue(1)*Vect_dents(2)-Vect_tongue(2)*Vect_dents(1);
    if (psi<0)
        FXY(2*i-1)=FXY(2*i-1)-psi*0.6;
        FXY(2*i)=FXY(2*i)-psi*0.3;
    end
end
imin=8*fact*NN+1+3*fact;
imax=8*fact*NN+1+5*fact;
for i=imin:imax
    pente_L(i)=(XY(2*i)-XY(2*i+2))/(XY(2*i-1)-XY(2*i+1));
    org_L(i)=XY(2*i)-pente_L(i)*XY(2*i-1);
    Xcontact(i)=0;
    Ycontact(i)=0;
end
% FIN CONTACT AVEC LES DENTS (FACON 1)

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
imin=3*fact*NN+1+6*fact;
%imax=7*fact*NN+1+6*fact;
imax=208; % PP Avril 04 - Pour prendre en compte aussi les contacts
% au niveau de la pointe de la langue
for i=imin:NN:imax
    pente_L(i)=(XY(2*i)-XY(2*i+2*NN))/(XY(2*i-1)-XY(2*i-1+2*NN));
    org_L(i)=XY(2*i)-pente_L(i)*XY(2*i-1);
    % Xcontact contient les coordonnees du point d'intersection
    Xcontact(i)=0;
    Ycontact(i)=0;
end

neucontact=0;       % tableau des indices des noeuds qui entrent en contact

% Detection de la collision
for j=nbpalais-1:-1:1           % boucle sur les segments du palais et du velum
    for i=imin:NN:imax            % boucle sur les noeuds de la langue
        if pente_L(i)~=pente_P(j)
            X_c=(org_L(i)-org_P(j))/(pente_P(j)-pente_L(i));
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
                    if oldi~=imin-NN
                        if nb_contact==0
                            fprintf('Premier contact au noeud %d sur le segment %d a %d %%\n',2*i-1,j,round(100*t/tf));
                            nc=2*i;
                            pc=j;
                            first_contact=1;
                            if fact==2
                                nc=nc+2*NN; % car on veut memoriser le noeud precedent
                                pc=pc-1;
                            end
                        end
                        % Module de cette force
                        % On applique la methode de penalite :
                        %           F = -(lambda*d + mu*d')
                        % avec d : profondeur du contact
                        %      d' : vitesse du noeud par rapport a sa projection
                        %           sur le palais
                        %      lambda : rigidite de la collision
                        %      mu : viscosite de la collision
                        % On peut aussi utiliser la formule :
                        %           F = -(lambda*d^n + mu*d'*d^n)
                        % avec n proche de 1
                        % et   mu=3/2*alpha*lambda
                        % On supprime ainsi la discontinuite de la force de
                        % collision et le coefficient de restitution vaut :
                        %   e = 1 - alpha*x'
                        surface_c=sqrt((Xcontact(i)-Xcontact(oldi))^2+(Ycontact(i)-Ycontact(oldi))^2);
                        pa=(Ycontact(oldi)-Ycontact(i))/(Xcontact(oldi)-Xcontact(i));
                        Xortho=(XY(2*i)+XY(2*i-1)/pa-Ycontact(oldi)+pa*Xcontact(oldi))/(pa+1/pa);
                        Yortho=pa*(Xortho-Xcontact(oldi))+Ycontact(oldi);
                        distance=sqrt((XY(2*i-1)-Xortho)^2+(XY(2*i)-Yortho)^2);
                        angle_reaction=atan((Xortho-XY(2*i-1))/(XY(2*i)-Yortho));
                        if (U(2*NNxMM+2*i)/sqrt(U(2*NNxMM+2*i)*U(2*NNxMM+2*i-1)))>sin(angle_reaction)
                            vitesse_contact=U(2*NNxMM+2*i)*cos(angle_reaction)+U(2*NNxMM+2*i-1)*abs(sin(angle_reaction));
                        else
                            vitesse_contact=U(2*NNxMM+2*i)*cos(angle_reaction)-U(2*NNxMM+2*i-1)*abs(sin(angle_reaction));
                        end
                        force_reaction=(60+0.5*vitesse_contact)*(surface_c*distance)^0.8;
                        % Direction de cette force
                        % Elle est dirigee suivant la plus courte distance entre le
                        % noeud qui depasse et le palais : elle est donc
                        % perpendiculaire aux 2 points de contact
                        FXY(2*i-1)=FXY(2*i-1)+force_reaction*sin(angle_reaction);
                        FXY(2*i)=FXY(2*i)-force_reaction*cos(angle_reaction);
                        Xcontact(i)=0;
                        Ycontact(i)=0;
                        Xcontact(oldi)=0;
                        Ycontact(oldi)=0;
                        nb_contact=nb_contact+1;
                        F_enr(t_i)=sqrt(FXY(2*i-1)^2+FXY(2*i)^2);
                        S_enr(t_i)=surface_c;
                        P_enr(t_i)=distance;
                        neucontact(size(neucontact,2)+1)=i;
                    end
                end
            elseif (aff_fin==0)&&(pc==j)&&(nc==2*i)&&(nb_contact~=0)&&(t>=tf/2)
                fprintf('Fin du contact a %d %%\n',round(100*t/tf));
                aff_fin=1;
            end
        end          % fin du non parallele
    end            % fin du for i
end              % fin du for j
% ------------------------------------------------------------------------
% Affichage du contour de la langue et calcul de certaines donnees

% Affichage du contour de la langue tous les 0.02 s
global TEMPS_FINAL_CUM;                 %      |
global couleurs;                        %      |
if t>=t_affiche                         %      |
    fprintf('Affichage...\n');            %      |
    t_affiche=t_affiche+0.005;% <-----------------/
    interval = min(find(TEMPS_FINAL_CUM >= t));
    index_coul = rem(interval, length(couleurs)) + 1;
    
    figure(1);
    plot(X(1:MM,NN),Y(1:MM,NN),['-' couleurs(index_coul)]);
    plot(X(MM,1:NN),Y(MM,1:NN),['-' couleurs(index_coul)]);
    plot(dents_inf(1,:),dents_inf(2,:),['-' couleurs(index_coul)]);
    plot(lowlip(1,:),lowlip(2,:),['-' couleurs(index_coul)]);
    plot(upperlip(1,:),upperlip(2,:),['-' couleurs(index_coul)]);
    plot(X(1:MM,NN),Y(1:MM,NN),'r+');
    plot(X(MM,1:NN),Y(MM,1:NN),'r+');
    plot(lar_ar_mri(1,:),lar_ar_mri(2,:),['-' couleurs(index_coul)])
    plot(pharynx_mri(1,1:end),pharynx_mri(2,1:end),'k-')
    plot([pharynx_mri(1,end) lar_ar_mri(1,1)], [pharynx_mri(2,end) lar_ar_mri(2,1)],...
        ['-' couleurs(index_coul)])
    plot([X(1,NN) tongue_lar_mri(1,1)],[Y(1,NN) tongue_lar_mri(2,1)],'r')
    plot(tongue_lar_mri(1,:),tongue_lar_mri(2,:),['-' couleurs(index_coul)])
    plot(X_origin,Y_origin,'r*');
    plot(X_origin,Y_origin,'ro');
    axis('equal')
    pause(0.001);
end
if t>=t_verbose
    t_verbose = t_verbose+0.005;
    t_calcul=round(toc*(TEMPS_FINAL_CUM(length(TEMPS_FINAL_CUM)) / t - 1));
    heure=floor(t_calcul/3600);
    minute=floor((t_calcul-3600*heure)/60);
    seconde=t_calcul-3600*heure-60*minute;
    fprintf('%d %%\n',round(100*t/tf));
    fprintf('Temps restant : %d h %d min %d s\n\n',heure,minute,seconde);
end


% On calcule ici les coordonnees du premier noeud qui entre en contact pour
% pouvoir l'enregistrer
%if nb_contact~=0
if first_contact==1  %modified by Yophan & Majid  Nov30, 99
    
    X_enr(t_i)=XY(nc-1);
    Yn_enr(t_i)=XY(nc);
    Yp_enr(t_i)=pente_P(pc)*X_enr(t_i)+org_P(pc);
    if (U(2*NNxMM+nc)/sqrt(U(2*NNxMM+nc)*U(2*NNxMM+nc-1)))>sin(angle_reaction)
        V_enr(t_i)=U(2*NNxMM+nc)*cos(angle_reaction)+U(2*NNxMM+nc-1)*abs(sin(angle_reaction));
    else
        V_enr(t_i)=U(2*NNxMM+nc)*cos(angle_reaction)-U(2*NNxMM+nc-1)*abs(sin(angle_reaction));
    end
    first_contact=0;
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONTACT AVEC LES DENTS (FACON 2)


% ----------------------------------------------------------------------------
% Calcul du contact avec les dents
% L'equation de droite des dents est calculee dans Simulation4.m
% On calcule les segments de droite de la langue qui pourraient
% entrer en collision avec les dents
% Pour l'explication des algorithmes, voir "contact langue palais"

% imin=8*fact*NN+1+fact;
% imax=8*fact*NN+1+5*fact;
% for i=imin:imax
%   if XY(2*i-1)~=XY(2*i+1)  % evite l'affichage de 'division par zero'
%     pente_L(i)=(XY(2*i)-XY(2*i+2))/(XY(2*i-1)-XY(2*i+1));
%   else
%     pente_L(i)=1e9;
%   end
%   org_L(i)=XY(2*i)-pente_L(i)*XY(2*i-1);
%   Xcontactd(i)=0;
%   Ycontactd(i)=0;
% end

% for j=1:nbpdent-1
%   for i=imin:imax
%     if pente_L(i)~=pente_D(j)
%       X_c=(org_L(i)-org_D(j))/(pente_D(j)-pente_L(i));
%       if (X_c<=max(XY(2*i+1),XY(2*i-1)))&(X_c>=min(XY(2*i-1),XY(2*i+1)))&(X_c>=Point_dent(1,j+1))&(X_c<=Point_dent(1,j))
% 	Y_c=org_L(i)+pente_L(i)*X_c;
% 	if (Y_c<=Point_dent(2,j+1))&(Y_c>=Point_dent(2,j))&(Y_c<=XY(2*i+2))&(Y_c>=XY(2*i))
% 	  Xcontactd(i)=X_c;
% 	  Ycontactd(i)=Y_c;
%           oldi=i-1;
% 	  while (Xcontactd(oldi)==0)&(oldi>=imin)
% 	    oldi=oldi-1;
% 	  end
% 	  if oldi~=imin-1
% 	    pa=(Ycontactd(oldi)-Ycontactd(i))/(Xcontactd(oldi)-Xcontactd(i));
% 	    surface_c=sqrt((Xcontactd(i)-Xcontactd(oldi))^2+(Ycontactd(i)-Ycontactd(oldi))^2);
% 	    somme_dist=0;
% 	    for nbn=oldi+1:i  % Si plusieurs noeuds depassent
% 	      Xortho=(XY(2*nbn)+XY(2*nbn-1)/pa-Ycontactd(oldi)+pa*Xcontactd(oldi))/(pa+1/pa);
% 	      Yortho=pa*(Xortho-Xcontactd(oldi))+Ycontactd(oldi);
% 	      distance(nbn)=sqrt((XY(2*nbn-1)-Xortho)^2+(XY(2*nbn)-Yortho)^2);
% 	      somme_dist=somme_dist+distance(nbn);
% 	      angle_reaction(nbn)=-atan((Xortho-XY(2*nbn-1))/(XY(2*nbn)-Yortho));
% 	    end
% 	    for nbn=oldi+1:i
% 	      force_reaction=30*surface_c*distance(nbn)*distance(nbn)/somme_dist;
% 	      if force_reaction>40
% 		force_reaction=40;
% 	      end
% 	      FXY(2*i-1)=FXY(2*i-1)+force_reaction*sin(angle_reaction(nbn));
% 	      FXY(2*i)=FXY(2*i)+force_reaction*cos(angle_reaction(nbn));
% 	    end
% 	    Xcontactd(i)=0;
% 	    Ycontactd(i)=0;
% 	    Xcontactd(oldi)=0;
% 	    Ycontactd(oldi)=0;
% 	  end
% 	end
%       end
%     end
%   end
% end

% FINAL CONTACT AVEC LES DENTS (FACON 2)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -----------------------------------------------------------------------
% Calcule la nouvelle matrice d'elasticite en fonction des muscles qui
% se contractent
global CALC_ELA;
% fprintf('Facteur CAlC_ELA = %i\n',CALC_ELA)
if CALC_ELA
    % disp ('elast')
    A0=elast2(sum(ForceGGA)/(3*fact),sum(ForceGGP)/(1+3*fact),sum(ForceHyo)/3,(ForceStylo1+ForceStylo2)/2,ForceSL,sum(ForceVert)/(3*fact),neucontact);
end
% Pour GGA  1+3*fact remplace par 3*fact (6 fibres) Nov 99
% Pour Vert 4 remplace par 3*fact

% -----------------------------------------------------------------------------
% Calcul de UDOT :

U(NNx2-1,1)=0;
U(NNx2,1)=0;
for j=1:NN:1+8*fact*NN
    U(2*j-1,1)=0;
    U(2*j,1)=0;
end

U(NNx2-1+NNxMMx2,1)=0;
U(2*(NN-1)+2 + 2*NNxMM,1)=0;
for j=1:NN:1+8*fact*NN
    U(2*j-1 + 2*NNxMM,1)=0;
    U(2*j + 2*NNxMM,1)=0;
end

Udot=[U(2*NNxMM+1:4*NNxMM,1);invMass*(FXY-A0*U(1:2*NNxMM,1)-F*U(2*NNxMM+1:4*NNxMM,1))];

for j=1:NN:1+8*fact*NN
    Udot(2*j-1 + 2*NNxMM,1)=0;
    Udot(2*j + 2*NNxMM,1)=0;
end
Udot(2*(NN-1)+1 + 2*NNxMM,1)=0;
Udot(2*(NN-1)+2 + 2*NNxMM,1)=0;

for j=1:NN:1+8*fact*NN
    Udot(2*j-1,1)=0;
    Udot(2*j,1)=0;
end
Udot(2*(NN-1)+1,1)=0;
Udot(2*(NN-1)+2,1)=0;

global TEMPS;
global FXY_T;
global ACCL_T;


% Calcul de la matrice globale pour la trajectoire de la force-temps,
% transforme a Simulation4.m et utilise en force_gr.m

TEMPS(t_i) = t;
FXY_T(t_i, :) = FXY.';

% Calcul de la matrice global pour la trajectoire de la acceleration-temps,
% transforme a Simulation4.m et utilise en accl_gr.m %
% ACCL_T(:,t_i+1) = invMass*(FXY-A0*U(1:2*NN*MM,1)-F*U(2*NN*MMUDOT2.m+1:4*NN*MM,1));
ACCL_T(t_i, :) = Udot(2*NNxMM+1:4*NNxMM).';

