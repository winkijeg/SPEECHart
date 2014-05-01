function Udot = udot3_adapt_jaw(TSObj, t,U)
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
%    - deux fois plus de fibres (si TSObj.fact=2) pour le GGP, le GGA et le
%      Vert
%    - Modification de l'algorithme de collision


% Plus de modifications :
%    - On va travailler avec comlambda.m (plus general) au lieu de COMLAMBDA.m

% Modifications apportees :
%    - ajout de commentaires
%    - Le calcul de l'inverse de la matrice de masse s'effectue dans
%      le fichier SIMULATION2.m : on utilise ici la matrice invMass
%    - Formalisation des indices dans le calcul des forces : on peut
%      ainsi modifier le nombre d'elements en modifiant uniquement TSObj.NN et MM
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


% global A0;
% global X0;
% global Y0;
% global X0Y0;
% global TSObj.NN;
% global MM;
% global TSObj.fact;
% global lambda;
% global mu;
% global X;
% global Y;
% global TSObj.XY;
% global TSObj.FXY;
% global H;
% global G;
% global XS;
% global YS;
% global X1;
% global Y1;
% global X2;
% global Y2;
% global X3;
% global Y3;
% global TSObj.tf;
% global nb_transitions;
% global tfin_closion;
% global contact;               % Variable indiquant si le contact a deja
% % eu lieu (initialisée à 0 dans udot3init.m et utilisée
% % dans press.m uniquement) (PP Mars 2000)


% % Longueurs au repos des muscles
% global longrepos_GGP;
% global longrepos_GGA;
% global longrepos_Hyo;
% global longrepos_Stylo;
% global longrepos_SL;
% global longrepos_IL;
% global longrepos_Vert;

% global longrepos_GGA_max longrepos_GGP_max longrepos_Hyo_max longrepos_IL_max longrepos_SL_max longrepos_Stylo_max longrepos_Vert_max %PP Nov 06

% % Variables de sections des muscles
% global rho_GG;
% global rho_Hyo;
% global rho_Stylo;
% global rho_SL;
% global rho_IL;
% global rho_Vert;

% % Variables concernant le contact
% global Point_dent;
% global slope_D;
% global org_D;
% global TSObj.cont.Point_P;
% global TSObj.cont.slope_P;
% global TSObj.cont.nbpdent;
% global TSObj.cont.nbpalais;
% global TSObj.cont.org_P;
% global slope_L;
% global org_L;
% global angle_reaction;

% % Variables concernant le poids
% global Mass;
% global invMass;


%%L global TSObj.first_contact;				%modified by Yohan & Majid; Nov 30, 99
%%L not used anywhere but here


%%L global kkk t_initial t_transTSObj.cont.ition TSObj.t_final TSObj.theta TSObj.theta_ll TSObj.dist_lip hyoid_movment dist_hyoid Hyoid_corps TSObj.cont.lar_ar tongue_lar TSObj.cont.pharynx
%% global t_initial t_transition t_final 
%% global TSObj.theta TSObj.theta_ll dist_lip hyoid_movment dist_hyoid Hyoid_corps TSObj.cont.lar_ar TSObj.cont.tongue_lar TSObj.cont.pharynx
%% global TSObj.cont.lowerteeth lar_ar TSObj.cont.lowerlip palate pharynx tongue_lar TSObj.cont.upperlip velum hyoid_i_abs

%% global TSObj.t_i ttout TSObj.length_ttout TSObj.X0_seq TSObj.Y0_seq TSObj.X_origin TSObj.Y_origin TSObj.old_t;
% ----------------------------------------------------------------------
% Initialisations cycliques
if TSObj.kkk==0	%modified by Yohan & Majid; Nov 30, 99
    TSObj.first_contact = 0;
    TSObj.t_jaw=0;
    TSObj.UU.lowerlip=[];
    TSObj.UU.upperlip=[];
    TSObj.UU.lar_ar = [];
    TSObj.UU.tongue_lar_mri = [];
    TSObj.UU.pharynx = [];
    TSObj.UU.lowerteeth=[];
    TSObj.length_ttout=0;
    TSObj.X0_seq=[];
    TSObj.Y0_seq=[];
    TSObj.old_t=TSObj.t_initial;
end

TSObj.kkk=TSObj.kkk+1;
TSObj.t_i=round(1000*t)+1;
TSObj.FXY = TSObj.PXY;

% Calculate the rotation and translation of the jaw -- MZ 12/27/99
if t-TSObj.t_jaw>=0.001 && t<=TSObj.t_final && (TSObj.theta~=0 || TSObj.theta_ll~=0 || TSObj.dist_lip~=0 || TSObj.dist_hyoid~=0) % GB MARS 2011
    [new_X0, new_Y0]=TSObj.jaw_trans(t);
    TSObj.t_jaw=t;
    if TSObj.theta~=0
        TSObj.restpos.X0=new_X0;
        TSObj.restpos.Y0=new_Y0;
        for i=1:TSObj.MM
            for j=1:TSObj.NN
                X0Y0((i-1)*TSObj.NNx2+2*j-1,1)=TSObj.restpos.X0(i,j);
                X0Y0((i-1)*TSObj.NNx2+2*j,1)=TSObj.restpos.Y0(i,j);
            end
        end
    end
end
if length(TSObj.ttout)>TSObj.length_ttout
    TSObj.length_ttout=TSObj.length_ttout+1;
    TSObj.UU.X_origin(TSObj.length_ttout)=TSObj.X_origin;
    TSObj.UU.Y_origin(TSObj.length_ttout)=TSObj.Y_origin;
    TSObj.UU.lowerlip(TSObj.length_ttout,:)=[TSObj.cont.lowerlip(1,:) TSObj.cont.lowerlip(2,:)];
    TSObj.UU.upperlip(TSObj.length_ttout,:)=[TSObj.cont.upperlip(1,:) TSObj.cont.upperlip(2,:)];
    TSObj.UU.lowerteeth(TSObj.length_ttout,:)=[TSObj.cont.lowerteeth(1,:) TSObj.cont.lowerteeth(2,:)];
    TSObj.UU.lar_ar(TSObj.length_ttout,:)=[TSObj.cont.lar_ar(1,:) TSObj.cont.lar_ar(2,:)];
    TSObj.UU.tongue_lar_mri(TSObj.length_ttout,:)=[TSObj.cont.tongue_lar_mri(1,:) TSObj.cont.tongue_lar_mri(2,:)];
    TSObj.UU.pharynx(TSObj.length_ttout,:)=[TSObj.cont.pharynx(1,:) TSObj.cont.pharynx(2,:)];
    X0_t = TSObj.restpos.X0'; % PP GB Avril 2011
    Y0_t = TSObj.restpos.Y0'; % PP GB Avril 2011
    TSObj.X0_seq(TSObj.length_ttout,:)=X0_t(:)';  % On renverse la matrice pour obtenir la bonne configuration
    TSObj.Y0_seq(TSObj.length_ttout,:)=Y0_t(:)';
end
% ---------------------------------------------------------------------
% Calcul des nouvelles positions des noeuds :
% XY est calcule a partir des X0 et Y0 initiaux et du deplacement U.

u=U(1:TSObj.NNxMMx2,1);
XY = TSObj.XY;
X0 = TSObj.restpos.X0; Y0 = TSObj.restpos.Y0;
for i=1:TSObj.MM
    for j=1:TSObj.NN
        
        v1=(i-1)*TSObj.NNx2+2*j;
%         X(i,j)=TSObj.restpos.X0(i,j)+u(v1-1);
%         Y(i,j)=TSObj.restpos.Y0(i,j)+u(v1);
%         TSObj.XY(v1-1,1)=X(i,j);
%         TSObj.XY(v1,1)=Y(i,j);
%         X(i,j)=TSObj.restpos.X0(i,j)+u(v1-1);
%         Y(i,j)=TSObj.restpos.Y0(i,j)+u(v1);
        XY(v1-1,1) = X0(i,j)+u(v1-1);
        XY(v1,1) = Y0(i,j)+u(v1);
    end
end
TSObj.v1 = v1;
TSObj.XY = XY;
clear v1 XY X0 Y0;
% keyboard;

% ---------------------------------------------------------------
% Calcul de lambda a l'instant t grace a la fonction COMLAMBDA
LAMBDA = sparse(TSObj.comLambda_adapt_jaw(t));    % Plusieurs transitions (pas d'influence
%            des muscles dont les lambdas ont la valeur de repos)
% Attribution de chaque lambda aux muscles
for i=1:1+3*TSObj.fact
    TSObj.Lambda.GGP(i)=LAMBDA(i);
end
for i=2+3*TSObj.fact:1+6*TSObj.fact % 6 fibres dans le cas a 221 noeuds et 3 a 63 noeuds
    TSObj.Lambda.GGA(i-3*TSObj.fact-1)=LAMBDA(i);
end
i=1+6*TSObj.fact;
TSObj.Lambda.Stylo1=LAMBDA(i+1);
TSObj.Lambda.Stylo2=LAMBDA(i+2);
TSObj.Lambda.Hyo1=LAMBDA(i+3);
TSObj.Lambda.Hyo2=LAMBDA(i+4);
TSObj.Lambda.Hyo3=LAMBDA(i+5);
TSObj.Lambda.SL=LAMBDA(i+6);
TSObj.Lambda.IL=LAMBDA(i+7);
j=i+8;
for i=j:j+3*TSObj.fact-1 % Modifs Dec 99 YP-PP
    TSObj.Lambda.Vert(i-j+1)=LAMBDA(i);
end
clear LAMBDA;
% ---------------------------------------------------------------
% Calculate for every muscle de la force FXY qui s'applique en XY
TSObj.GGP(U);
TSObj.GGA(U);
TSObj.STYLO(U);
TSObj.HYO(U);
TSObj.SL(U);
TSObj.IL(U);
TSObj.VERT(U);

if TSObj.DoPress % doesn't ever seem to be true
    PRESS(t);
end
% Genio-Hyoidien : resistance a la racine de la langue
for i=2:TSObj.NN-1
    TSObj.FXY(2*i-1)=(TSObj.restpos.X0(1,i)-TSObj.XY(2*i-1))*2;
    TSObj.FXY(2*i)=(TSObj.restpos.Y0(1,i)-TSObj.XY(2*i))*2;
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

for i=8*TSObj.fact*TSObj.NN+1+4*TSObj.fact:-1:8*TSObj.fact*TSObj.NN+1+2*TSObj.fact % Modif. Dec 99 pour descendre plus bas sur les contacts des dents
    Vect_tongue=[TSObj.XY(2*i-1)-TSObj.cont.Point_dents(1) TSObj.XY(2*i)-TSObj.cont.Point_dents(2)];
    psi=Vect_tongue(1)*TSObj.cont.Vect_dents(2)-Vect_tongue(2)*TSObj.cont.Vect_dents(1);
    if (psi<0)
        TSObj.FXY(2*i-1)=TSObj.FXY(2*i-1)-psi*0.6;
        TSObj.FXY(2*i)=TSObj.FXY(2*i)-psi*0.3;
    end
end
imin=8*TSObj.fact*TSObj.NN+1+3*TSObj.fact;
imax=8*TSObj.fact*TSObj.NN+1+5*TSObj.fact;


for i=imin:imax
    slope_L(i)=(TSObj.XY(2*i)-TSObj.XY(2*i+2))/(TSObj.XY(2*i-1)-TSObj.XY(2*i+1));
    org_L(i)=TSObj.XY(2*i)-slope_L(i)*TSObj.XY(2*i-1);
    Xcontact(i)=0;
    Ycontact(i)=0;
end
% FIN CONTACT AVEC LES DENTS (FACON 1)

% ----------------------------------------------------------------------------
% Calcul du contact avec le palais
% Les equations des segments du palais sont calculees dans SIMULATION4.m
% On verifie ici que les noeuds superieurs de la langue n'entrent pas
% en contact avec le palais en testant des intersections de segments.
% Si il y a contact, on cree une force s'ajoutant a TSObj.FXY qui s'oppose au
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
%       Xcontact(i) ->/    \<- Xcontact(oldI) oldI=i-NN ou i-2NN ou i-3NN
%          O~~~~~~~~~/~~~O__\_______O
%                   /    |   \
%                  /  TSObj.cont.Point_P \
%                 /            \-------------
%          ------/         XY(2*i-2*NN)
%
%
% Calcul des equations de droite entre chaque noeuds superieurs de la
% langue.
% Ces equations sont de la forme :
% Y = slope_L(i) * X + org_L(i)
imin=3*TSObj.fact*TSObj.NN+1+6*TSObj.fact;
%imax=7*TSObj.fact*TSObj.NN+1+6*TSObj.fact;
imax=208; % PP Avril 04 - Pour prendre en compte aussi les contacts
% au niveau de la pointe de la langue
for i=imin:TSObj.NN:imax
    slope_L(i)=(TSObj.XY(2*i)-TSObj.XY(2*i+2*TSObj.NN))/(TSObj.XY(2*i-1)-TSObj.XY(2*i-1+2*TSObj.NN));
    org_L(i)=TSObj.XY(2*i)-slope_L(i)*TSObj.XY(2*i-1);
    % Xcontact contient les coordonnees du point d'intersection
    Xcontact(i)=0;
    Ycontact(i)=0;
end

neucontact=0;       % tableau des indices des noeuds qui entrent en contact

% Detection de la collision
for j=TSObj.cont.nbpalais-1:-1:1           % boucle sur les segments du palais et du velum
    for i=imin:TSObj.NN:imax            % boucle sur les noeuds de la langue
        if slope_L(i)~=TSObj.cont.slope_P(j)
            X_c=(org_L(i)-TSObj.cont.org_P(j))/(TSObj.cont.slope_P(j)-slope_L(i));
            % Verification que le contact est bien sur les segments
            % Position X correcte ?
            if (X_c<=TSObj.XY(2*i-1))&&(X_c>=TSObj.XY(2*i-1+2*TSObj.NN))&&(X_c<=TSObj.cont.Point_P(2*j+1))&&(X_c>=TSObj.cont.Point_P(2*j-1))
                Y_c=slope_L(i)*X_c+org_L(i);
                % Position Y correcte ?
                if (Y_c<=max(TSObj.cont.Point_P(2*j+2),TSObj.cont.Point_P(2*j)))&&(Y_c>=min(TSObj.cont.Point_P(2*j+2),TSObj.cont.Point_P(2*j)))
                    Xcontact(i)=X_c;
                    Ycontact(i)=Y_c;
                    % Y a-t-il eu contact precedemment ?
                    oldI=i-TSObj.NN;
                    while (Xcontact(oldI)==0)&&(oldI>=imin)
                        oldI=oldI-TSObj.NN;
                    end
                    % Creation de la force de collision
                    if oldI~=imin-TSObj.NN
                        if TSObj.n_contact==0
                            fprintf('First contact with node %d on segments %d at  %d %%\n',2*i-1,j,round(100*t/TSObj.tf));
                            TSObj.nc=2*i;
                            TSObj.pc=j;
                            TSObj.first_contact=1;
                            if TSObj.fact==2
                                TSObj.nc=TSObj.nc+2*TSObj.NN; % car on veut memoriser le noeud precedent
                                TSObj.pc=TSObj.pc-1;
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
                        surface_c=sqrt((Xcontact(i)-Xcontact(oldI))^2+(Ycontact(i)-Ycontact(oldI))^2);
                        pa=(Ycontact(oldI)-Ycontact(i))/(Xcontact(oldI)-Xcontact(i));
                        Xortho=(TSObj.XY(2*i)+TSObj.XY(2*i-1)/pa-Ycontact(oldI)+pa*Xcontact(oldI))/(pa+1/pa);
                        Yortho=pa*(Xortho-Xcontact(oldI))+Ycontact(oldI);
                        distance=sqrt((TSObj.XY(2*i-1)-Xortho)^2+(TSObj.XY(2*i)-Yortho)^2);
                        angle_reaction=atan((Xortho-TSObj.XY(2*i-1))/(TSObj.XY(2*i)-Yortho));
                        if (U(2*TSObj.NNxMM+2*i)/sqrt(U(2*TSObj.NNxMM+2*i)*U(2*TSObj.NNxMM+2*i-1)))>sin(angle_reaction)
                            vitesse_contact=U(2*TSObj.NNxMM+2*i)*cos(angle_reaction)+U(2*TSObj.NNxMM+2*i-1)*abs(sin(angle_reaction));
                        else
                            vitesse_contact=U(2*TSObj.NNxMM+2*i)*cos(angle_reaction)-U(2*TSObj.NNxMM+2*i-1)*abs(sin(angle_reaction));
                        end
                        force_reaction=(60+0.5*vitesse_contact)*(surface_c*distance)^0.8;
                        % Direction de cette force
                        % Elle est dirigee suivant la plus courte distance entre le
                        % noeud qui depasse et le palais : elle est donc
                        % perpendiculaire aux 2 points de contact
                        TSObj.FXY(2*i-1)=TSObj.FXY(2*i-1)+force_reaction*sin(angle_reaction);
                        TSObj.FXY(2*i)=TSObj.FXY(2*i)-force_reaction*cos(angle_reaction);
                        Xcontact(i)=0;
                        Ycontact(i)=0;
                        Xcontact(oldI)=0;
                        Ycontact(oldI)=0;
                        TSObj.n_contact=TSObj.n_contact+1;
                        TSObj.F_enr(TSObj.t_i)=sqrt(TSObj.FXY(2*i-1)^2+TSObj.FXY(2*i)^2);
                        TSObj.S_enr(TSObj.t_i)=surface_c;
                        TSObj.P_enr(TSObj.t_i)=distance;
                        neucontact(size(neucontact,2)+1)=i;
                    end
                end
            elseif (TSObj.aff_fin==0)&&(TSObj.pc==j)&&(TSObj.nc==2*i)&&(TSObj.n_contact~=0)&&(t>=TSObj.tf/2)
                fprintf('End of contact at %d %%\n',round(100*t/TSObj.tf));
                TSObj.aff_fin=1;
            end
        end          % fin du non parallele
    end            % fin du for i
end              % fin du for j
% ------------------------------------------------------------------------
% Affichage du contour de la langue et calcul de certaines donnees

% Affichage du contour de la langue tous les 0.02 s
if t>=TSObj.t_affiche                         %      |
    fprintf('Displaying...\n');            %      |
    TSObj.t_affiche=TSObj.t_affiche+0.005;% <-----------------/
    interval = min(find(TSObj.t_final_cum >= t));
    colIndex = rem(interval, length(TSObj.colors)) + 1;
    
    figure(1);
    % I optimized X and Y away. Let's see what can be done more
    % plot(X(1:TSObj.MM,TSObj.NN),    Y(1:TSObj.MM,TSObj.NN),['-' TSObj.colors(colIndex)]);
    plot(TSObj.XY(TSObj.NN*2-1:TSObj.NN*2:end),...
        TSObj.XY(TSObj.NN*2:TSObj.NN*2:end), ['-' TSObj.colors(colIndex)]);
    %plot(X(TSObj.MM,1:TSObj.NN),    Y(TSObj.MM,1:TSObj.NN),['-' TSObj.colors(colIndex)]);
    plot(TSObj.XY(1+(TSObj.MM-1)*TSObj.NN*2:2:end),...
        TSObj.XY(2+(TSObj.MM-1)*TSObj.NN*2:2:end),['-' TSObj.colors(colIndex)]);
    plot(TSObj.cont.lowerteeth(1,:),TSObj.cont.lowerteeth(2,:),['-' TSObj.colors(colIndex)]);
    plot(TSObj.cont.lowerlip(1,:),TSObj.cont.lowerlip(2,:),['-' TSObj.colors(colIndex)]);
    plot(TSObj.cont.upperlip(1,:),TSObj.cont.upperlip(2,:),['-' TSObj.colors(colIndex)]);
    %plot(X(1:TSObj.MM,TSObj.NN),    Y(1:TSObj.MM,TSObj.NN),'r+');
    plot(TSObj.XY(TSObj.NN*2-1:TSObj.NN*2:end),...
        TSObj.XY(TSObj.NN*2:TSObj.NN*2:end), 'r+');
    % plot(X(TSObj.MM,1:TSObj.NN),    Y(TSObj.MM,1:TSObj.NN),'r+');
    plot(TSObj.XY(1+(TSObj.MM-1)*TSObj.NN*2:2:end),...
        TSObj.XY(2+(TSObj.MM-1)*TSObj.NN*2:2:end),'r+');
    plot(TSObj.cont.lar_ar(1,:),TSObj.cont.lar_ar(2,:),['-' TSObj.colors(colIndex)])
    plot(TSObj.cont.pharynx(1,1:end),TSObj.cont.pharynx(2,1:end),'k-')
    plot([TSObj.cont.pharynx(1,end) TSObj.cont.lar_ar(1,1)], [TSObj.cont.pharynx(2,end) TSObj.cont.lar_ar(2,1)],...
        ['-' TSObj.colors(colIndex)])
    % X(1,TSObj.NN) Y(1,TSObj.NN)
    plot([TSObj.XY(2*TSObj.NN-1) TSObj.cont.tongue_lar_mri(1,1)],...
        [TSObj.XY(2*TSObj.NN) TSObj.cont.tongue_lar_mri(2,1)],'m')
    plot(TSObj.cont.tongue_lar_mri(1,:), TSObj.cont.tongue_lar_mri(2,:),['-' TSObj.colors(colIndex)])
    %plot(TSObj.cont.tongue_lar_mri(1,:), TSObj.cont.tongue_lar_mri(2,:),'m-')
    plot(TSObj.X_origin,TSObj.Y_origin,'r*');
    plot(TSObj.X_origin,TSObj.Y_origin,'ro');
    axis('equal')
    pause(0.001);
end
if t>=TSObj.t_verbose
    TSObj.t_verbose = TSObj.t_verbose+0.005;
    TSObj.t_calcul=round(toc*(TSObj.t_final_cum(length(TSObj.t_final_cum)) / t - 1));
    hour=floor(TSObj.t_calcul/3600);
    minute=floor((TSObj.t_calcul-3600*hour)/60);
    second=TSObj.t_calcul-3600*hour-60*minute;
    fprintf('%d %%\n',round(100*t/TSObj.tf));
    fprintf('Remaining time: %d h %d min %d s\n\n',hour,minute,second);
end


% On calcule ici les coordonnees du premier noeud qui entre en contact pour
% pouvoir l'enregistrer
%if TSObj.n_contact~=0
if TSObj.first_contact==1  %modified by Yophan & Majid  Nov30, 99
    
    TSObj.X_enr(TSObj.t_i)=TSObj.XY(TSObj.nc-1);
    TSObj.n_enr(TSObj.t_i)=TSObj.XY(TSObj.nc);
    TSObj.p_enr(TSObj.t_i)=TSObj.cont.slope_P(TSObj.pc)*TSObj.X_enr(TSObj.t_i)+TSObj.cont.org_P(TSObj.pc);
    if (U(2*TSObj.NNxMM+TSObj.nc)/sqrt(U(2*TSObj.NNxMM+TSObj.nc)*U(2*TSObj.NNxMM+TSObj.nc-1)))>sin(angle_reaction)
        TSObj.V_enr(TSObj.t_i)=U(2*TSObj.NNxMM+TSObj.nc)*cos(angle_reaction)+U(2*TSObj.NNxMM+TSObj.nc-1)*abs(sin(angle_reaction));
    else
        TSObj.V_enr(TSObj.t_i)=U(2*TSObj.NNxMM+TSObj.nc)*cos(angle_reaction)-U(2*TSObj.NNxMM+TSObj.nc-1)*abs(sin(angle_reaction));
    end
    TSObj.first_contact=0;
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

% imin=8*TSObj.fact*TSObj.NN+1+TSObj.fact;
% imax=8*TSObj.fact*TSObj.NN+1+5*TSObj.fact;
% for i=imin:imax
%   if XY(2*i-1)~=XY(2*i+1)  % evite l'affichage de 'division par zero'
%     slope_L(i)=(XY(2*i)-XY(2*i+2))/(XY(2*i-1)-XY(2*i+1));
%   else
%     slope_L(i)=1e9;
%   end
%   org_L(i)=XY(2*i)-slope_L(i)*XY(2*i-1);
%   Xcontactd(i)=0;
%   Ycontactd(i)=0;
% end

% for j=1:TSObj.cont.nbpdent-1
%   for i=imin:imax
%     if slope_L(i)~=slope_D(j)
%       X_c=(org_L(i)-org_D(j))/(slope_D(j)-slope_L(i));
%       if (X_c<=max(XY(2*i+1),XY(2*i-1)))&(X_c>=min(XY(2*i-1),XY(2*i+1)))&(X_c>=Point_dent(1,j+1))&(X_c<=Point_dent(1,j))
% 	Y_c=org_L(i)+slope_L(i)*X_c;
% 	if (Y_c<=Point_dent(2,j+1))&(Y_c>=Point_dent(2,j))&(Y_c<=XY(2*i+2))&(Y_c>=XY(2*i))
% 	  Xcontactd(i)=X_c;
% 	  Ycontactd(i)=Y_c;
%           oldI=i-1;
% 	  while (Xcontactd(oldI)==0)&(oldI>=imin)
% 	    oldI=oldI-1;
% 	  end
% 	  if oldI~=imin-1
% 	    pa=(Ycontactd(oldI)-Ycontactd(i))/(Xcontactd(oldI)-Xcontactd(i));
% 	    surface_c=sqrt((Xcontactd(i)-Xcontactd(oldI))^2+(Ycontactd(i)-Ycontactd(oldI))^2);
% 	    somme_dist=0;
% 	    for nbn=oldI+1:i  % Si plusieurs noeuds depassent
% 	      Xortho=(XY(2*nbn)+XY(2*nbn-1)/pa-Ycontactd(oldI)+pa*Xcontactd(oldI))/(pa+1/pa);
% 	      Yortho=pa*(Xortho-Xcontactd(oldI))+Ycontactd(oldI);
% 	      distance(nbn)=sqrt((XY(2*nbn-1)-Xortho)^2+(XY(2*nbn)-Yortho)^2);
% 	      somme_dist=somme_dist+distance(nbn);
% 	      angle_reaction(nbn)=-atan((Xortho-XY(2*nbn-1))/(XY(2*nbn)-Yortho));
% 	    end
% 	    for nbn=oldI+1:i
% 	      force_reaction=30*surface_c*distance(nbn)*distance(nbn)/somme_dist;
% 	      if force_reaction>40
% 		force_reaction=40;
% 	      end
% 	      TSObj.FXY(2*i-1)=TSObj.FXY(2*i-1)+force_reaction*sin(angle_reaction(nbn));
% 	      TSObj.FXY(2*i)=TSObj.FXY(2*i)+force_reaction*cos(angle_reaction(nbn));
% 	    end
% 	    Xcontactd(i)=0;
% 	    Ycontactd(i)=0;
% 	    Xcontactd(oldI)=0;
% 	    Ycontactd(oldI)=0;
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
%global CALC_ELA;
% fprintf('Facteur CAlC_ELA = %i\n',CALC_ELA)
if TSObj.CALC_ELA
    % disp ('elast')
    TSObj.A0=TSObj.elast2(sum(TSObj.Force.GGA)/(3*TSObj.fact),sum(TSObj.Force.GGP)/(1+3*TSObj.fact),sum(TSObj.Force.Hyo1)/3,(TSObj.Force.Stylo1+TSObj.Force.Stylo2)/2,TSObj.Force.SL,sum(TSObj.Force.Vert)/(3*TSObj.fact),neucontact);
end
% Pour GGA  1+3*TSObj.fact remplace par 3*TSObj.fact (6 fibres) Nov 99
% Pour Vert 4 remplace par 3*TSObj.fact

% -----------------------------------------------------------------------------
% Calcul de UDOT :

U(TSObj.NNx2-1,1)=0;
U(TSObj.NNx2,1)=0;
for j=1:TSObj.NN:1+8*TSObj.fact*TSObj.NN
    U(2*j-1,1)=0;
    U(2*j,1)=0;
end

U(TSObj.NNx2-1+TSObj.NNxMMx2,1)=0;
U(2*(TSObj.NN-1)+2 + 2*TSObj.NNxMM,1)=0;
for j=1:TSObj.NN:1+8*TSObj.fact*TSObj.NN
    U(2*j-1 + 2*TSObj.NNxMM,1)=0;
    U(2*j + 2*TSObj.NNxMM,1)=0;
end

Udot=[U(2*TSObj.NNxMM+1:4*TSObj.NNxMM,1);TSObj.invMass*(TSObj.FXY-TSObj.A0*U(1:2*TSObj.NNxMM,1)-TSObj.F*U(2*TSObj.NNxMM+1:4*TSObj.NNxMM,1))];

for j=1:TSObj.NN:1+8*TSObj.fact*TSObj.NN
    Udot(2*j-1 + 2*TSObj.NNxMM,1)=0;
    Udot(2*j + 2*TSObj.NNxMM,1)=0;
end
Udot(2*(TSObj.NN-1)+1 + 2*TSObj.NNxMM,1)=0;
Udot(2*(TSObj.NN-1)+2 + 2*TSObj.NNxMM,1)=0;

for j=1:TSObj.NN:1+8*TSObj.fact*TSObj.NN
    Udot(2*j-1,1)=0;
    Udot(2*j,1)=0;
end
Udot(2*(TSObj.NN-1)+1,1)=0;
Udot(2*(TSObj.NN-1)+2,1)=0;


% Calcul de la matrice globale pour la trajectoire de la force-temps,
% transforme a Simulation4.m et utilise en force_gr.m

TSObj.TEMPS(TSObj.t_i) = t;
TSObj.FXY_T(TSObj.t_i, :) = TSObj.FXY.';

% Calcul de la matrice global pour la trajectoire de la acceleration-temps,
% transforme a Simulation4.m et utilise en accl_gr.m %
% ACCL_T(:,TSObj.t_i+1) = invMass*(TSObj.FXY-A0*U(1:2*TSObj.NN*MM,1)-F*U(2*TSObj.NN*MMUDOT2.m+1:4*TSObj.NN*MM,1));
TSObj.ACCL_T(TSObj.t_i, :) = Udot(2*TSObj.NNxMM+1:4*TSObj.NNxMM).';

