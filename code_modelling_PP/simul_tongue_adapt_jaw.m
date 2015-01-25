function simul_tongue_adapt_jaw(path_model, spkStr, seq, out_file, ...
    deltaLamb_GGP, deltaLamb_GGA, deltaLamb_HYO, deltaLamb_STY, ...
    deltaLamb_VER, deltaLamb_SL, deltaLamb_IL, t_trans, t_hold, ...
    jaw_rot, lip_prot, ll_rot, hyoid_mov)
% Payan & Perrier /Zandipour Tongue jaw model
% For the jaw, the lips and the larynx the time variations are made
% according to an undamped second order model (Bell-shaped velocity profile)

% input parameters:
%
%   seq:            sequence of phonemes (always starting with 'r')
%   out_file:       Name of the output file
%   deltaLamb_GGP:  GGP commands in mm for all phonemes of the sequence 
%                   except the initial rest position - These values are 
%                   referenced to the value at rest (negatif=activation)
%
%   delta_lambda_gga:   GGA commands (see details for GGP)
%   delta_lambda_hyo:   HYO commands (see details for GGP)
%   delta_lambda_sty:   STY commands (see details for GGP)
%   delta_lambda_ver:   VERT commands (see details for GGP)
%   delta_lambda_sl:    SL commands (see details for GGP)
%   delta_lambda_il:    IL commands (see details for GGP)
%
%   t_trans:    Transition duration in (s) between phonemes including the 
%               initial rest position
%   t_hold:     Hold duration (in s) for all phonemes except the initial 
%               rest position
%   jaw_rot:    Successive rotation angles of the jaw in degrees. Positiv
%               = aperture. These commands are not made in reference to 
%               the position at rest but to the position for the 
%               preceding phoneme
%   lip_prot:   Successive horizontal displacement of lips in mm. Positiv = 
%               protrusion. These commands are not made in reference to 
%               the position at rest but to the position for the 
%               preceding phoneme.
%   ll_rot:     Successive rotation angles of the lips in degrees. Positiv 
%               = aperture. These commands are not made in reference to 
%               the position at rest but to the position for the preceding 
%               phoneme
%   hyoid_mov:  Successive vertical displacement of the epipharynx in mm. 
%               positiv = lowering. These commands are not made in 
%               reference to the position at rest but to the position for 
%               the preceding phoneme
% Example: 
%
%   simul_tongue_adapt_jaw('av', 'ria', 'ria_trial', [-10 +10], ...
%       [0 -10], [+10 -10], [-10 +10], [0 -3], [200 200], [-1 -3], ...
%       [0.05 0.05], [0.150 0.150], [-3 +4], [-2 -2], [0 0], [0 0])

global dents_inf lar_ar_mri tongue_lar_mri lowlip palate pharynx_mri
global tongue_lar upperlip velum

global CALC_ELA

global sujet rest_file contour_file result_stocke_file MATRICE_LAMBDA

global X_origin_initial Y_origin_initial X_repos Y_repos
global longrepos_GGA_max longrepos_GGP_max longrepos_Hyo_max longrepos_IL_max longrepos_SL_max longrepos_Stylo_max longrepos_Vert_max %PP Nov 06

global file_mat
global jaw_rotation t_initial t_transition t_final theta X0_rest_pos Y0_rest_pos alpha_rest_pos dist_rest_pos
global alpha_rest_pos_dents_inf dist_rest_pos_dents_inf alpha_rest_pos_lowlip dist_rest_pos_lowlip
global X_origin Y_origin theta_start X_origin_ll Y_origin_ll U_X_origin U_Y_origin
global ll_rotation lip_protrusion theta_ll dist_lip lowlip_initial dist_hyoid hyoid_movment hyoid_start
global lar_ar_mri_initial tongue_lar_mri_initial pharynx_mri_initial

global A0 NN MM fact lambda mu XY FXY l X0 Y0 H G

% muscle attachment points
global XS % loaded from 'path_model/contour' file
global YS % loaded from 'path_model/contour' file
global X1 % loaded from 'path_model/contour' file
global Y1 % loaded from 'path_model/contour' file
global X2 % loaded from 'path_model/contour' file
global Y2 % loaded from 'path_model/contour' file
global X3 % loaded from 'path_model/contour' file
global Y3 % loaded from 'path_model/contour' file

% Longueurs au repos des muscles
% muscle length at tongue rest position
global longrepos_GGP % loaded from 'path_model/repos' file
global longrepos_GGA % loaded from 'path_model/repos' file
global longrepos_Hyo % loaded from 'path_model/repos' file
global longrepos_Stylo % loaded from 'path_model/repos' file
global longrepos_SL % loaded from 'path_model/repos' file
global longrepos_IL % loaded from 'path_model/repos' file
global longrepos_Vert % loaded from 'path_model/repos' file

% Amplitude des variations min max prévues pour les lambdas % PP - 9 May 2011
% Amplitude of the anticipated min max variations for the lambdas
global delta_lambda_tot_GGP
global delta_lambda_tot_GGA
global delta_lambda_tot_Hyo
global delta_lambda_tot_Stylo
global delta_lambda_tot_SL
global delta_lambda_tot_IL
global delta_lambda_tot_Vert

% proportionality factor between the lambdas of the fibres within a muscle
% loaded from 'path_model/repos' file
global fac_GGP fac_GGA fac_Hyo fac_Stylo fac_SL fac_IL fac_Vert

global Ufin tfin LOOP U t

global TEMPS_ACTIVATION; % later assigned from input arg t_trans
global TEMPS_HOLD; % later assigned from input arg t_hold
global TEMPS_FINAL TEMPS_FINAL_CUM tf

% variables of muscle sections
global rho_GG rho_Hyo rho_Stylo rho_SL rho_IL rho_Vert

% movement variables
global U_dents_inf U_lowlip U_upperlip U_pharynx_mri U_lar_ar_mri U_tongue_lar_mri

global X0_seq Y0_seq length_ttout ttout

% cantact variables
global pente_D org_D nbpalais Point_P pente_P org_P

global Mass invMass

% global temporary variables
global aff_fin 
aff_fin = 0;

global S_enr  X_enr  Yn_enr  Yp_enr  F_enr  P_enr  V_enr  t_calcul  VOY_DEF

% A matrix with as many rows as phonemes (including rest) and
% ten columns of not entirely clear meaning
global SEQUENCE
SEQUENCE = '';

dim = size(seq);

for i = 1:dim(2)
    SEQUENCE(i,1) = seq(i);
    SEQUENCE(i,2)=' ';
    SEQUENCE(i,3)=' ';
    SEQUENCE(i,4)=' ';
    SEQUENCE(i,5)=' ';
    SEQUENCE(i,6)=' ';
    SEQUENCE(i,7)=' ';
    SEQUENCE(i,8)=' ';
    SEQUENCE(i,9)=' ';
    SEQUENCE(i,10)=' ';
end

for i = 1:dim(2)
    if (SEQUENCE(i,1) == 'r')
        
        SEQUENCE(i,2) = 'e';
        SEQUENCE(i,3) = 'p';
        SEQUENCE(i,4) = 'o';
        SEQUENCE(i,5) = 's';
        SEQUENCE(i,6) = ' ';
        SEQUENCE(i,7) = ' ';
        SEQUENCE(i,8) = ' ';
        SEQUENCE(i,9) = ' ';
        SEQUENCE(i,10) = ' ';
    end
end

tic
sujet = spkStr;
rest_file = ['XY_repos_' spkStr]; %PP Nov 06
contour_file = ['data_palais_repos_' spkStr]; %PP Nov 06
result_stocke_file = ['result_stocke_' spkStr]; % stocke means something like storage
fact = 2;

%
%close all;
load([path_model rest_file]);
load([path_model contour_file]);
load([path_model result_stocke_file]);
%
lar_ar_mri = lar_ar; % PP Juli 2011 % variable in contour file has no _mri suffix
pharynx_mri = pharynx; % PP Juli 2011 % variable in contour file has no _mri suffix
X_condyle = XS;
Y_condyle = YS+8; %center of the jaw movement -- condyle point

%
TEMPS_ACTIVATION = t_trans;
TEMPS_HOLD = t_hold;
jaw_rotation = jaw_rot;
ll_rotation = ll_rot;
lip_protrusion = lip_prot;
hyoid_movment = hyoid_mov;

% combine t_trans (!) and t_hold to t_final
TEMPS_FINAL = TEMPS_ACTIVATION + TEMPS_HOLD;

% vector with each transitions final time
TEMPS_FINAL_CUM = cumsum(TEMPS_FINAL);

n_phon = length(TEMPS_HOLD);
delta_lambda = [deltaLamb_GGP' deltaLamb_GGA' deltaLamb_HYO' deltaLamb_STY' deltaLamb_VER' deltaLamb_SL' deltaLamb_IL']';
MATRICE_LAMBDA(:,1) = CONFIGS(1,1:2:14)';

for np = 1:n_phon
    MATRICE_LAMBDA(:,1+np) = delta_lambda(:,np) + CONFIGS(1,1:2:14)';
end

global kkk
kkk = 0;

% --------------------------------------------------------
NN = 7;	   % NN : number columns
MM = 9;	   % MM : number of rows
% With fact = 2, 192 elements and 221 nodes are obtained

% ---------------------------------------------------------------------
% Calcul pour chaque muscle de rho
% tel que la force musculaire active M soit :
% Calculate rho for every muscle
% such that the active mucle force M be:
%     M = rho(exp(c.A)-1)
% ou A est l'activation musculaire :
% where A is the muscle activation :
%     A = [l-lambda+MU.l']+

% Chaque muscle est divise en plusieurs fibres.
% On suppose que chacune de ces branches fournit la meme force.
% Les CSA (cross section area) sont les sections de ces fibres.
% La valeur de rho est proportionnelle aux CSA.
% Every muscle is divided into several fibers.
% It is assumed that each of these branches provides the same force.
% The CSAs (cross section area) are the sections of these fibers.
% The value of rho is proportional to the CSAs.
% Rho is the Force!
K_m = 0.22;    % in N/mm2, value obtained from Van Lunteren & al. 1990 

CSA_GG = 308/(6*fact+1);
rho_GG = CSA_GG * K_m;

CSA_Hyo = 296/3;
rho_Hyo = CSA_Hyo*K_m;

% CSA_Stylo=110/2;
CSA_Stylo = 40/2; % Modifs Pascal Mars 2000 a la suite du scratch de aka
rho_Stylo = CSA_Stylo * K_m;

CSA_SL = 65;
rho_SL = CSA_SL * K_m;

CSA_IL = 88;
rho_IL = CSA_IL * K_m;

CSA_Vert = 66/(3*fact);
rho_Vert = CSA_Vert * K_m;

% --------------------------------------------------------
% Charge depuis le disque les variables suivantes :
% X0 = X_repos (dim 9x7) : coordonnees X au repos
% Y0 = Y_repos (dim 9x7) : coordonnees Y au repos
% com (dim 1x47)       : texte

disp('calculate tongue rest position ...');
% preallocate for (a marginal gain of) speed
X0 = zeros(fact*(MM-1)+1,fact*(NN-1)+1);
Y0 = zeros(fact*(MM-1)+1,fact*(NN-1)+1);

% Calcul par interpolation la position de repos en fonction du
% nombre de noeuds
% Intrepolate the rest positions as a function of the number of nodes
% !!!!!!       MATLAB 4 <=> MATLAB 5         !!!!!!!
% !!!!!! changer les transposees des interp1 !!!!!!!
for j = 1:MM
    X0(fact*(j-1)+1, 1:fact*(NN-1)+1) = interp1(1:NN, X_repos(j,1:NN), 1:1/fact:NN,'spline');
end

for j=1:NN
    Y0(1:fact*(MM-1)+1,fact*(j-1)+1)=interp1(1:MM,Y_repos(1:MM,j),1:1/fact:MM,'spline')';
end

for j=1:fact*(NN-1)+1 % = 1:size(X0,2)
    X0(:,j)=interp1(find(X0(:,j)),nonzeros(X0(:,j)),1:fact*(MM-1)+1,'spline')';
end

for j=1:fact*(MM-1)+1% = 1:size(X0,1)
    Y0(j,:)=interp1(find(Y0(j,:)),nonzeros(Y0(j,:)),1:fact*(NN-1)+1,'spline');
end

NN = fact*(NN-1)+1; % = size(X0,2)
MM = fact*(MM-1)+1; % = size(X0,1)

% PP juli 2011 - Detection tongue root node on the tongue_lar contour
for itongue_lar = length(tongue_lar)-1:-1:1
    if tongue_lar(2,itongue_lar) >= Y0(1,NN)-1 
        ideptongue_lar = itongue_lar + 1;
        break;
    end
end
tongue_lar_mri = tongue_lar(:, ideptongue_lar:end); % PP Juli 2011

% --------------------------------------------------------
% Calcul de la position au repos des noeuds sous la forme XY.
% Les coordonnees des noeuds sont ranges a la suite, ligne
% par ligne :
% XY(i)  i pair   : coordonnee X
% XY(i)  i impair : coordonnee Y
% Calculate the rest position of the nodes in the form of XY.
% The coordinates of the nodes are arranged succesively, row
% by row:
% XY(i) i even  : x coordinate
% XY(i) i odd: y coordinate
%%% LB: I think it's X on odd and y on even indeces...

XY=zeros((MM-1)*2*NN+2*NN,1);
for i = 1:MM
    for j = 1:NN
        XY((i-1)*2*NN+2*j-1,1) = X0(i,j);
        XY((i-1)*2*NN+2*j,1) = Y0(i,j);
    end
end

% --------------------------------------------------------
% Points d'attache des muscles
% (utilises dans UDOT pour le caclcul des longueurs des muscles)
% 3 points d'attache pour le Hyoglosse :

% coordonnées X1,Y1, X2, Y2, X3, Y3 lues dans le fichier contour PP Nov06

% 1 point d'attache pour le Styloglosse :
% % coodonnées XS YS lues dans le fichier contour PP Nov06

% Les autres muscles ne sont pas attaches : leur position depend
% seulement de la position des noeuds.

% ----------------------------------------------------------
% Muscle attachment points
% (used in UDOT for calculating the muscles' lengths)
% 3 attachment points for the Hyoglosse :

% Coordinates X1,Y1, X2, Y2, X3, Y3 read in the contour file

% 1 attachment point for the styloglossus
% % coordinates Xs, Ys read in the contour file

% remaining muscles are not attached: their position depends solely on the
% position of the nodes.

% --------------------------------------------------------
% Calcul de la longueur des fibres au repos
% Definition des facteurs de distribution sur les fibres d'un muscle
% et calcul par interpolation si fact>1

% -----------------------------------------------------------
% Calculation of fibre length in rest position
% Definition of the factors of the distribution on the fibres of a muscle
% and calculation by interpolation if fact>1

% GGP
longrepos_GGP = zeros(1+3*fact,1);
for k=1:1+3*fact            % boucle sur le nombre de fibres/loop over number of fibers
    longrepos_GGP(k)=0;
    o=NN*fact+1+(k-1)*NN;     % indice du plus petit noeud concerne/index of the smaller relevant node
    i=o+NN-fact;              % indice du plus grand noeud concerne/index of the karger relevant node
    for j=i:-1:o+1
        longrepos_GGP(k)=longrepos_GGP(k)+sqrt((XY(2*j-1)-XY(2*j-3))^2+(XY(2*j)-XY(2*j-2))^2);
    end
end
longrepos_GGP=longrepos_GGP';
% fac_GGP est lu dans rest_file PP: 16 juillet 2006
% fac_GGP is read in rest_file

% GGA
longrepos_GGA = zeros(1+3*fact,1);
for k=1:3*fact  % 6 fibres (apres les comm. de Reiner - Nov 99
    longrepos_GGA(k)=0;
    o=4*NN*fact+1+k*NN;
    i=o+NN-fact;   % on demarre de la surface avec 63 noeuds et de la
    % ligne en dessous de la surface avec 221 noeuds
    for j=i:-1:o+1
        longrepos_GGA(k)=longrepos_GGA(k)+sqrt((XY(2*j-1)-XY(2*j-3))^2+(XY(2*j)-XY(2*j-2))^2);
    end
end
longrepos_GGA=longrepos_GGA';
% fac_GGA est lu dans rest_file PP: 16 juillet 2006
% fac_GGA is read in rest_file

% Hyo
% this is really obscure
% GET BACK TO THIS
i=(5*fact-1)*NN+1+3*fact; % Modifs YP-PP Dec 99
j=6*fact*NN+1+4*fact; % Modifs YP-PP Dec 99
long1=sqrt((XY(2*i-1)-X1)^2+(XY(2*i)-Y1)^2);
long2=sqrt((XY(2*j-1)-XY(2*i-1))^2+(XY(2*j)-XY(2*i))^2);
i=4*fact*NN+1+4*fact;  % Modifs YP-PP Dec 99
long_Hyo2=sqrt((XY(2*i-1)-X2)^2+(XY(2*i)-Y2)^2);
i=3*fact*NN+1+5*fact;    % i=27
long_Hyo3=sqrt((XY(2*i-1)-X3)^2+(XY(2*i)-Y3)^2);
longrepos_Hyo=[long1+long2;long_Hyo2;long_Hyo3];
% fac_Hyo est lu dans rest_file PP: 16 juillet 2006

% Stylo
j = 3*fact*NN + 1 + 4*fact;
longStylo1 = sqrt((XY(2*j-1)-XS)^2+(XY(2*j)-YS)^2);
i = (7*fact)*NN+4*fact;
j = 4*fact*NN+1+4*fact;
long1 = sqrt((XY(2*i-1)-XY(2*j-1))^2+(XY(2*i)-XY(2*j))^2);
long2 = sqrt((XY(2*j-1)-XS)^2+(XY(2*j)-YS)^2);
longrepos_Stylo = [longStylo1;long1+long2];

% SL
% first fiber
long_SL(1) = 0;
k = fact*(2*NN+6)+1;
i = NN*MM;
long1 = 0;
for j = k+NN:NN:i
    long1(j) = sqrt((XY(2*j-1)-XY(2*(j-NN)-1))^2+(XY(2*j)-XY(2*(j-NN)))^2);
    long_SL(1) = long_SL(1)+long1(j);
end

% second fiber
long_SL(2) = 0;
k = fact*(2*NN+6);
i = NN*MM-1;
long2 = 0;
for j = k+NN:NN:i
    long2(j) = sqrt((XY(2*j-1)-XY(2*(j-NN)-1))^2+(XY(2*j)-XY(2*(j-NN)))^2);
    long_SL(2) = long_SL(2)+long2(j);
end
longrepos_SL = [long_SL(1);long_SL(2)];

% IL
i = 4*fact*NN+2*fact+1;
j = 7*fact*NN+3*fact+1;
k = 221-4;

long1 = sqrt((XY(2*i-1)-X2)^2+(XY(2*i)-Y2)^2);
long2 = sqrt((XY(2*j-1)-XY(2*i-1))^2+(XY(2*j)-XY(2*i))^2);
long3 = sqrt((XY(2*k-1)-XY(2*j-1))^2+(XY(2*k)-XY(2*j))^2);
longrepos_IL = long1+long2+long3;

% Vert
longrepos_Vert = 0;
for k=1:3*fact %Modifs Dec 99 YP-PP
    longrepos_Vert(k) = 0;
    l = (k-1)*NN+fact*(5*NN+3)+1; %Modifs Dec 99 YP-PP
    i = (k-1)*NN+fact*(5*NN+6); %Modifs Dec 99 YP-PP
    for j = i:-1:l+1
        longrepos_Vert(k) = longrepos_Vert(k)+sqrt((XY(2*j-1)-XY(2*j-3))^2+(XY(2*j)-XY(2*j-2))^2);
    end
end
longrepos_Vert = longrepos_Vert';

% --------------------------------------------------------
% Indexing variables used for the calculation of the elasticity matrix A0

global IA IB IC ID IE IX IY

IX = [1,3,5,7];
IY = [2,4,6,8];
iaa = [1,5,2,6,3,7,4,8];
IA = [iaa,iaa,iaa,iaa,iaa,iaa,iaa,iaa];
IB = [ones(1,8),5*ones(1,8),2*ones(1,8),6*ones(1,8),3*ones(1,8),7*ones(1,8),4*ones(1,8),8*ones(1,8)];
icx = [0,9,0,9,0,9,0,9];
iccx = [1,0,1,0,1,0,1,0];
icy = [9,0,9,0,9,0,9,0];
iccy = [0,1,0,1,0,1,0,1];
IC = [icx+iccx,icy+5*iccy,icx+2*iccx,icy+6*iccy,icx+3*iccx,icy+7*iccy,icx+4*iccx,icy+8*iccy];
idd = [5,1,6,2,7,3,8,4];
ID = [idd,idd,idd,idd,idd,idd,idd,idd];
IE = [5*ones(1,8),1*ones(1,8),6*ones(1,8),2*ones(1,8),7*ones(1,8),3*ones(1,8),8*ones(1,8),4*ones(1,8)];

% --------------------------------------------------------
% Gaussian variables used for squaring A0
% In this way, calculating the integral is replaced by a sum: SUM(Hi*f(Gi))

global ordre

ordre = 2;
H(1,1) = 2.;
H(2,1) = 1.;
H(2,2) = 1.;
H(3,1) = 0.555556;
H(3,2) = 0.888889;
H(3,3) = 0.555556;

G(1,1) = 0.;
G(2,1) = -0.577350;
G(2,2) = 0.577350;
G(3,1) = -0.774597;
G(3,2) = 0.;
G(3,3) = 0.774597;


% --------------------------------------------------------
% Creation of the force vector FXY which is applied to the nodes.
% its dimensions are 2*NN*MM
FXY = sparse(2*NN*MM,1);

% Creation of U and Ufin, displacement vectors of dimension 4*NN*MM
Ufin = zeros(1,4*NN*MM);
tfin = 0;
LOOP = 0;
U = zeros(1,4*NN*MM);
t = 0;

% constant values for the tongue ---------------------------------
nu = 0.49; % Poisson's ratio
E = 0.35; % Young's modulus: stiffness; E = 0.7 in Yohan's theses
lambda = (nu*E)/((1+nu)*(1-2*nu)); % elastic modulus
mu = E/(2*(1+nu)); % shear (elasticity constant)

% --------------------------------------------------------
% Calcul de la matrice de Masse (dim 2*NN*MM par 2*NN*MM) : la masse
% associee a chaque noeud est proportionnelle a l'aire des elements qui
% entourent ce noeud.
% Compute the matrix of mass (dim 2*NN*MM by 2*NN*MM) : the mass associated
% to each node is proportional to the area of the elements sorrounding the
% node.
disp('calculate the mass matrix ...');
% Calcul de l'aire de chaque element
% Compute each element's area
aire_element = zeros(MM-1, NN-1);
for i=1:MM-1,
    for j=1:NN-1,
        aire_element(i,j)=abs(( (Y0(i+1,j)+Y0(i,j))*(X0(i+1,j)-X0(i,j)) + (Y0(i+1,j+1)+Y0(i+1,j))*(X0(i+1,j+1)-X0(i+1,j)) + (Y0(i,j+1)+Y0(i+1,j+1))*(X0(i,j+1)-X0(i+1,j+1)) + (Y0(i,j)+Y0(i,j+1))*(X0(i,j)-X0(i,j+1))) / 2.0);
    end
end
aire_totale = sum(aire_element(:)); % sum of all areas

% Calcul de la masse / compute the mass
Mass=eye(2*NN*MM);
masse_totale=0.15/35;      % <=> 150 grammes sur 40 mm de large
                           % <=> 150 grams per 40 mm width
                           % possibly 35 mm??
for i=1:MM
    for j=1:NN
        k=(i-1)*2*NN+2*j;
        if (k==2)                  % coin bas gauche / lower left corner
            aire=aire_element(1,1)/4;
        elseif (k==2*(MM*NN-NN+1)) % coin haut gauche / upper left corner
            aire=aire_element(MM-1,1)/4;
        elseif (k==2*NN)           % coin bas droit / lower right cor
            aire=aire_element(1,NN-1)/4;
        elseif (k==2*NN*MM)        % coin haut droit / upper right corner
            aire=aire_element(MM-1,NN-1)/4;
        elseif (i==1)              % bords bas / lower edge
            aire=aire_element(1,j-1)/4+aire_element(1,j)/4;
        elseif (j==1)              % bord gauche / left edge
            aire=aire_element(i-1,1)/4+aire_element(i,1)/4;
        elseif (i==MM)             % bord haut / upper edge
            aire=aire_element(MM-1,j-1)/4+aire_element(MM-1,j)/4;
        elseif (j==NN)             % bord droit / right edge
            aire=aire_element(i,NN-1)/4+aire_element(i-1,NN-1)/4;
        else                       % tous les autres noeuds / all the oether nodes
            aire=aire_element(i-1,j-1)/4+aire_element(i,j-1)/4+aire_element(i-1,j)/4+aire_element(i,j)/4;
        end
        Mass(k,k)=Mass(k,k)*masse_totale/aire_totale*aire;
        Mass(k-1,k-1)=Mass(k,k);
    end
end

% Pour accelerer les calculs, on prend tout de suite l'inverse de
% cette matrice :
% To accelerate computation, get the inverse of this matrix :
invMass = inv(Mass);

% Compute the elasticity matrix
A0 = elast_init(XY, lambda, mu, ordre, H, G);

% initialisation de la position de repos apres le premiere voyelle
% dans le sequence
% initialisation of the rest positions after the first vowel in the
% sequence

% --------------------------------------------------------
% Calcul et dessin des parties fixes : dents, palais, ...
% Calculation and design of fixed parts: teeth, palate, ...

% Position des dents inferieures
% En effet, il faut limiter le mouvement de la langue au niveau
% des dents inferieures.
% On lit sur le disque le fichier data_palais_repos.mat qui
% contient entre autre les dents inferieures.
% les vecteurs Vect_dents et Point_dents sont passes a UDOT.m
% Position of the lower teeth
% Indeed, tongue movements must be limited on the level of the lower teeth.
% The file data_palais_repos.mat is read from disk which contains among
% others the lower teeth.
% The vectors Vect_dents et Point_dents are passed to UDOT.m

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONTACT AVEC LES DENTS (FACON 1)
% CONTACT WITH THE TEETH (1. FORM)

global Vect_dents;
global Point_dents;

Vect_dents=[dents_inf(1,11)-dents_inf(1,13)-1 dents_inf(2,11)-dents_inf(2,13)];
Point_dents=[dents_inf(1,13)+1 dents_inf(2,13)];
pente_D=(dents_inf(2,11)-dents_inf(2,13))/(dents_inf(1,11)-dents_inf(1,13));
org_D=dents_inf(2,11)-pente_D*dents_inf(1,11);

% FIN CONTACT AVEC LES DENTS (FACON 1)
% END OF CONTACT WITH THE TEETH (!. FORM)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONTACT AVEC LES DENTS (FACON 2)
% Interpolation des points des dents inferieurs sinon l'algorithme de
% collision converge mal
% vectdent=[10:0.5:14];
% dentx=interp1([10:14],dents_inf(1,[10:14]),vectdent);
% denty=interp1([10:14],dents_inf(2,[10:14]),vectdent);
% nbpdent=size(vectdent,2);
% for i=1:nbpdent
%   Point_dent(1,i)=dentx(nbpdent-i+1);
%   Point_dent(2,i)=denty(nbpdent-i+1);
% end

% for i=1:nbpdent-1
%   pente_D(i)=(Point_dent(2,i+1)-Point_dent(2,i))/(Point_dent(1,i+1)-Point_dent(1,i));
%   org_D(i)=Point_dent(2,i+1)-pente_D(i)*Point_dent(1,i+1);
% end

% FIN CONTACT AVEC LES DENTS (FACON 2)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Position du palais et du velum
% Le contact pour la creation de consonnes se fera entre les
% differents noeuds 'superieurs' de la langue et les points suivants
% Avec comme toujours : indice impair -> composante X
%                               pair  -> composante Y
% Position of palate and velum
% The contact for the production of consonantes will be between the
% different 'superior' nodes of the tongue and the following points
% As akways : odd indices -> X coordinante
%            even indices -> Y coordinate
% Points du palais :
% Points of the palate :
P_palais=(8:length(palate(1,:))); % On prend tous les points du palais MRI
%(points 1 à 7 = dents standard ajoutée par transform_data_mri (PP Nov06)
% All points from the MRI palate are taken, (points 1 to 7 = standard teeth
% added by transform_data_mri)
for i=1:size(P_palais,2)
    Point_P(2*i-1)=palate(1,P_palais(i));
    Point_P(2*i)=palate(2,P_palais(i));
end
% Points du velum :
% Points of the velum :
P_velum=(2:(length(velum(1,:))-5)); % On prend tous les points du palais mou mesurés MRI sauf le premier
% qui correspond au dernier du palais dur (PP Nov06)
% All points of the soft palate are taken exept the first which corresponds
% to the last of the hard palate

for j=i+1:i+size(P_velum,2)
    Point_P(2*j-1)=velum(1,P_velum(j-i));
    Point_P(2*j)=velum(2,P_velum(j-i));
end
nbpalais=size(P_palais,2)+size(P_velum,2);

% Calcul des equations de chaque segment du palais
% Calculate the equations of every segment of the palate
pente_P = zeros(nbpalais-1,1);
org_P = zeros(nbpalais-1,1);
for i=1:nbpalais-1
    pente_P(i)=(Point_P(2*i)-Point_P(2*i+2))/(Point_P(2*i-1)-Point_P(2*i+1));
    org_P(i)=Point_P(2*i)-pente_P(i)*Point_P(2*i-1);
end

%PP Juli 2011
for i = 2:nbpalais-1
    for j=i-1:-1:1
        if pente_P(i)<=pente_P(j)+0.001 && pente_P(i)>=pente_P(j)-0.001
            fprintf('Slight displacement (1/4mm) of palate point %i for better contact detection\n',i)
            Point_P(2*i)=Point_P(2*i)+0.25;
            pente_P(i)=(Point_P(2*i)-Point_P(2*i+2))/(Point_P(2*i-1)-Point_P(2*i+1));
            org_P(i)=Point_P(2*i)-pente_P(i)*Point_P(2*i-1);
            i_P_prec=i-1;
            pente_P(i_P_prec)=(Point_P(2*i_P_prec)-Point_P(2*i_P_prec+2))/(Point_P(2*i_P_prec-1)-Point_P(2*i_P_prec+1));
            org_P(i_P_prec)=Point_P(2*i_P_prec)-pente_P(i_P_prec)*Point_P(2*i_P_prec-1);
        end
    end
end

% Trace du palais et du velum
% figure('Units','normal','Position',[0.4 0.41 0.5 0.5]);
% Pour eviter un core dump on met un point en 0,0
% plot(0,0);
% whitebg([0.8 0.8 1]);
% title(['Jaw-Tongue Model - Speaker ' spkStr]);
% hold on;
% axis([-20 150 20 140])
% axis equal;
% set(gca,'Visible','off');
% zoom on
% for i=1:nbpalais
%     plot(Point_P(2*i-1),Point_P(2*i),'k*');
% end

% plot(dents_inf(1,:),dents_inf(2,:),'k-');
% plot(palate(1,:),palate(2,:),'k-');
% plot(velum(1,:),velum(2,:),'k-');
X_origin_initial = X_condyle; % PP Juli 2011
Y_origin_initial = Y_condyle; % PP Juli 2011
% plot(X_origin_initial,Y_origin_initial,'ro'); % GB Mars 2011
% plot(lar_ar_mri(1,:),lar_ar_mri(2,:),'k-'); % GB Mars 2011
% plot(pharynx_mri(1,:),pharynx_mri(2,:),'k-'); % GB Mars 2011
% plot(tongue_lar_mri(1,:), tongue_lar_mri(2,:),'r')

% --------------------------------------------------------
% Resolution de l'equa diff par Runge Kutta  (fonction ODE45 de Matlab)
% Resolution de l'equa diff qui donne les tableaux tfin et Ufin
% ODE45 calcule lui-meme les differents t de t0 a tf*nb_voyelles


disp('calculate differential equation ...')
U0 = [U(size(t)*[0;1],1:2*NN*MM)]';
U0(2*NN*MM+1:4*NN*MM,1) = zeros(2*NN*MM,1);

global nb_contact
nb_contact = 0;

global t_affiche
t_affiche = 0.001;

global t_verbose
t_verbose = 0.001;

nb_transitions = size(MATRICE_LAMBDA,2)-1;

% Variables utilisees par comlambda.m
% Longueur minimale pour chaque fibre de chaque muscle
global longmin_GGP;
global longmin_GGA;
global longmin_Hyo;
global longmin_Stylo;
global longmin_SL;
global longmin_IL;
global longmin_Vert;

delta_lambda_tot_GGP = 20*2; % PP - 9 May 2011/Juli2011
delta_lambda_tot_GGA = 20*2; % PP - 9 May 2011/Juli2011
delta_lambda_tot_Hyo = 20*2; % PP - 9 May 2011/Juli2011
delta_lambda_tot_Stylo = 20*2; % PP - 9 May 2011/Juli2011
delta_lambda_tot_SL = 20*2; % PP - 9 May 2011/Juli2011
delta_lambda_tot_IL = 20*2; % PP - 9 May 2011/Juli2011
delta_lambda_tot_Vert = 10*2; % PP - 9 May 2011/Juli2011

longmin_GGP = (longrepos_GGP_max-delta_lambda_tot_GGP/2) * fac_GGP; % PP - 9 May 2011
longmin_GGA = (longrepos_GGA_max-delta_lambda_tot_GGA/2) * fac_GGA; % PP - 9 May 2011
longmin_Hyo = (longrepos_Hyo_max-delta_lambda_tot_Hyo/2) * fac_Hyo; % PP - 9 May 2011
longmin_Stylo = (longrepos_Stylo_max-delta_lambda_tot_Stylo/2) * fac_Stylo; % PP - 9 May 2011
longmin_SL = (longrepos_SL_max-delta_lambda_tot_SL/2) * fac_SL; % PP - 9 May 2011
longmin_IL = (longrepos_IL_max-delta_lambda_tot_IL/2) * fac_IL; % PP - 9 May 2011
longmin_Vert = (longrepos_Vert_max-delta_lambda_tot_Vert/2) * fac_Vert; % PP - 9 May 2011

global TEMPS;
TEMPS = 0;
global FXY_T;
FXY_T = zeros(1, 2*MM*NN);
global ACCL_T;
ACCL_T = zeros(1, 2*MM*NN);
global ACTIV_T;
ACTIV_T = 0;
global LAMBDA_T;
LAMBDA_T = 0;

% LAMBDA_T va etre une matrice avec la valeur de lambda en fonction du temps
% pour une fibre de chaque muscle
% LAMBDA_T(KKK, :) = [GGP(kkk), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]

% !!!!!! MATLAB 4 <=> MATLAB 5 !!!!!!!!!
% MATLAB 5 :

% CV - 03/03/99
% Utilisation de la version udot3.m, ce qui necessite l'appel
% de udot3init.m

%tf=TEMPS_FINAL_CUM(length(TEMPS_FINAL_CUM));

tf_seq = TEMPS_FINAL_CUM;
t0_seq = [0 TEMPS_FINAL_CUM(1:length(TEMPS_FINAL_CUM)-1)];
tf = tf_seq(length(tf_seq));

%Jaw rotation and its effect on the tongue and the lower lip -- mz 12/27/99
U_lowlip = zeros(round(200*tf), 12); % 30
U_upperlip = zeros(round(200*tf), 12); % 46
U_dents_inf = zeros(round(200*tf), 10); % 34     %% GB Mars 2011
U_pharynx_mri = zeros(round(200*tf), 13);
U_lar_ar_mri = zeros(round(200*tf), 12);
U_tongue_lar_mri = zeros(round(200*tf), 17);
% U_mandibule=zeros(round(200*tf),20);
X0_seq = zeros(round(200*tf), 221);
Y0_seq = zeros(round(200*tf), 221);
ttout = 0;

%
jaw_rotation = (pi/180).*jaw_rotation;
ll_rotation = (pi/180).*ll_rotation;

X_origin = X_origin_initial;
Y_origin = Y_origin_initial;
lar_ar_mri_initial = lar_ar_mri;
tongue_lar_mri_initial = tongue_lar_mri;
pharynx_mri_initial = pharynx_mri;


udot3init_adapt;

% the simulation starts here ...........................................
for i = 1:length(tf_seq)
    if i==1
        tfin = [];
        Ufin = [];
        theta_start = 0;
        hyoid_start = 0;
    else
        theta_start = sum(jaw_rotation(1:i-1));
        hyoid_start = sum(hyoid_movment(1:i-1));
    end
    
    % intitial tongue position
    X0_rest_pos = X0;
    Y0_rest_pos = Y0;
    
    % the initial angle alpha for each node of the tongue
    alpha_rest_pos = atan2((X_origin-X0_rest_pos), (Y_origin-Y0_rest_pos));
    % the distance of each node of the tongue to the center of rotation
    dist_rest_pos = sqrt( (Y0_rest_pos-Y_origin).^2 + ...
                          (X0_rest_pos-X_origin).^2 );
    
    %the initial angle alpha of the lower incisor
    alpha_rest_pos_dents_inf = atan2((X_origin-dents_inf(1,:)), ...
        (Y_origin-dents_inf(2,:)));
    %the initial distance of the lower incisor to the center of rotation
    dist_rest_pos_dents_inf = sqrt((dents_inf(2,:)-Y_origin).^2 + (dents_inf(1,:)-X_origin).^2);
    
    X_origin_ll = X_origin;
    Y_origin_ll = Y_origin;
    lowlip_initial = lowlip;
    alpha_rest_pos_lowlip = atan2((X_origin_ll-lowlip(1,:)), (Y_origin_ll-lowlip(2,:)));%the initial angle alpha of the lower lip
    dist_rest_pos_lowlip = sqrt((lowlip(2,:)-Y_origin_ll).^2+(lowlip(1,:)-X_origin_ll).^2);%the initial distance of the lower lip to the center of rotation
    t_initial = t0_seq(i);
    t_transition = t0_seq(i)+TEMPS_ACTIVATION(i);
    t_final = tf_seq(i);
    theta = jaw_rotation(i);
    theta_ll = ll_rotation(i);
    dist_lip = lip_protrusion(i);
    dist_hyoid = hyoid_movment(i); % GB MARS 2011

    figure(1);
    hold on
    axis('equal')
    
    plot(upperlip(1,:),upperlip(2,:), 'k-' );
    plot(palate(1,1:end), palate(2,1:end),'k-')
    plot(velum(1,1:end), velum(2,1:end),'k-')
    plot(pharynx_mri(1,1:end), pharynx_mri(2,1:end),'k-')
    plot(lar_ar_mri(1,:), lar_ar_mri(2,:),'k-')
    plot(tongue_lar_mri(1,:), tongue_lar_mri(2,:),'k-')

    
    % plot tongue and lower jaw contours in rest position
    plot(lowlip(1,:),lowlip(2,:), 'k--');
    plot(dents_inf(1,:),dents_inf(2,:), 'k--');
    plot(X_origin, Y_origin, 'ko');
    drawnow
    
    fprintf('Integrating from %1.4f to %1.4f seconds\n',t0_seq(i), tf_seq(i));
    
    [ts, Us] = ode45plus('udot3_adapt_jaw', t0_seq(i), tf_seq(i), ...
        U0, 0.001, 0.008);
    
    U0 = Us(length(ts), :);
    tfin = [tfin; ts];
    Ufin = [Ufin; Us];
end



% here the simulation seems to be already finnished ............
if ( length_ttout < (200 * tf) )
    U_X_origin = U_X_origin(1:length_ttout);
    U_Y_origin = U_Y_origin(1:length_ttout);
    U_lowlip = U_lowlip(1:length_ttout,1:end);
    U_upperlip = U_upperlip(1:length_ttout,1:end);
    U_dents_inf = U_dents_inf(1:length_ttout,1:end);
    U_pharynx_mri = U_pharynx_mri(1:length_ttout,1:end);
    U_lar_ar_mri = U_lar_ar_mri(1:length_ttout,1:end);
    U_tongue_lar_mri = U_tongue_lar_mri(1:length_ttout,1:end);
    X0_seq = X0_seq(1:length_ttout, 1:221);
    Y0_seq = Y0_seq(1:length_ttout, 1:221);
end

t = tfin';
U = Ufin;

[t_ord, ind_ord] = sort(TEMPS);

% On va enlever les elements repetes de t_ord
t_ord_aux = [t_ord(2:length(t_ord)), 0];
ind_bon = find((t_ord_aux - t_ord) ~= 0);
t_bon = t_ord(ind_bon);

FXY_ord = FXY_T(ind_ord, :);
FXY_bon = FXY_ord(ind_bon, :);

FXY_TRAJ = interp1(t_bon, FXY_bon, t);

ACCL_ord = ACCL_T(ind_ord, :);
ACCL_bon = ACCL_ord(ind_bon, :);

ACCL_TRAJ = interp1(t_bon, ACCL_bon, t);

ACTIV_ord = ACTIV_T(ind_ord, :);
ACTIV_bon = ACTIV_ord(ind_bon, :);

ACTIV_TRAJ = interp1(t_bon, ACTIV_bon, t);

% remove negative values
index = find( ACTIV_TRAJ < 0 );
ACTIV_TRAJ( index ) = zeros( size(index) );

% ACTIV_TRAJ will be a matrix with the activation function of time 
% for a fiber from each muscle 
% ACTIV_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]

LAMBDA_ord = LAMBDA_T(ind_ord, :);
LAMBDA_bon = LAMBDA_ord(ind_bon, :);

LAMBDA_TRAJ = interp1(t_bon, LAMBDA_bon, t);

clear global TEMPS FXY_T ACCL_T ACTIV_T LAMBDA_T

% save tongue movement and force tracks
file_mat = [spkStr, '_', out_file];

jaw_rotation = jaw_rotation*180/pi;
ll_rotation = ll_rotation*180/pi;

list_data_sauv = ' sujet U t ttout CALC_ELA fact MM NN SEQUENCE TEMPS_FINAL TEMPS_HOLD TEMPS_FINAL_CUM TEMPS_ACTIVATION MATRICE_LAMBDA nb_transitions';
list_data_sauv = [list_data_sauv ' jaw_rotation lip_protrusion ll_rotation hyoid_movment FXY_TRAJ ACCL_TRAJ ACTIV_TRAJ LAMBDA_TRAJ X0 Y0'];
list_data_sauv = [list_data_sauv ' U_dents_inf U_lowlip U_upperlip U_pharynx_mri U_lar_ar_mri U_tongue_lar_mri X0_seq Y0_seq U_X_origin U_Y_origin'];
command = ['save ' file_mat list_data_sauv];
eval(command)

disp(['number of contacts: ' num2str(nb_contact)]);
disp(['number of function calls (UDOT): ' num2str(kkk)]);

% store movements of nodes that had contacts
eval(['save mvt',' X_enr',' S_enr',' F_enr',' Yn_enr',' Yp_enr',' P_enr',' V_enr']);

toc
disp('End of simul_tongue_adapt_jaw')

end
