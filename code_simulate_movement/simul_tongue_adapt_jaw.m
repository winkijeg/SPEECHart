function [matUtt_obsolete, matUtt] = simul_tongue_adapt_jaw(speakerModel, ...
    seq, deltaLamb_GGP, deltaLamb_GGA, deltaLamb_HYO, ...
    deltaLamb_STY, deltaLamb_VER, deltaLamb_SL, deltaLamb_IL, t_trans, ...
    t_hold, jaw_rot, lip_prot, ll_rot, hyoid_mov, myPlotFlag)
% Payan & Perrier /Zandipour Tongue jaw model

    % only a few landmarks from the SpeakerModel are used do far
    landmarks.xyStyloidProcess = speakerModel.landmarks.xyStyloidProcess;
    landmarks.xyCondyle = speakerModel.landmarks.xyCondyle;
%   landmarks.xyANS = speakerModel.landmarks.xyANS;
%   landmarks.xyPNS = speakerModel.landmarks.xyPNS;
%   landmarks.xyOrigin = speakerModel.landmarks.xyOrigin;
%   landmarks.xyTongInsL = speakerModel.landmarks.xyTongInsL;
%   landmarks.xyTongInsH = speakerModel.landmarks.xyTongInsH;
    landmarks.xyHyoA = speakerModel.landmarks.xyHyoA;
    landmarks.xyHyoB = speakerModel.landmarks.xyHyoB;
    landmarks.xyHyoC = speakerModel.landmarks.xyHyoC;
    
    structures = speakerModel.structures;

    tongMesh = speakerModel.tongue; % Class PositionFrame
    positionValuesTmp = getPositionOfNodeNumbers(tongMesh, 1:221);
    tongueRest.X0 = reshape(positionValuesTmp(1, :), 13, 17)';
    tongueRest.Y0 = reshape(positionValuesTmp(2, :), 13, 17)';
    
    myMuscleCol = speakerModel.muscles;
    
    if ~exist('myPlotFlag', 'var') || isempty(myPlotFlag)
        myPlotFlag = false;
    end
    
    
    
    
% global temporary variables
global aff_fin 
aff_fin = 0;

tic
nNodes = 221;

global NN MM
MM = 17;
NN = 13;

global kkk
kkk = 0;


% muscle attachment points/used in UDOT for calculating muscle length
global XS YS X1 Y1 X2 Y2 X3 Y3

XS = landmarks.xyStyloidProcess(1);
YS = landmarks.xyStyloidProcess(2);
X1 = landmarks.xyHyoA(1);
Y1 = landmarks.xyHyoA(2);
X2 = landmarks.xyHyoB(1);
Y2 = landmarks.xyHyoB(2);
X3 = landmarks.xyHyoC(1);
Y3 = landmarks.xyHyoC(2);

global dents_inf lar_ar_mri tongue_lar_mri lowlip palate pharynx_mri tongue_lar upperlip velum

lar_ar_mri = structures.larynxArytenoid;
pharynx_mri = structures.backPharyngealWall;
upperlip = structures.upperLip;
palate = structures.upperIncisorPalate;
velum = structures.velum;
tongue_lar = structures.tongueLarynx;
dents_inf = structures.lowerIncisor;
lowlip = structures.lowerLip;


global jaw_rotation ll_rotation lip_protrusion hyoid_movment
jaw_rotation = (pi/180).*jaw_rot;
ll_rotation = (pi/180).*ll_rot;
lip_protrusion = lip_prot;
hyoid_movment = hyoid_mov;


% -- the tongue ------------------------------------------------------
global X0 Y0

X0 = tongueRest.X0;
Y0 = tongueRest.Y0;

global TEMPS_ACTIVATION TEMPS_HOLD TEMPS_FINAL TEMPS_FINAL_CUM

TEMPS_ACTIVATION = t_trans;
TEMPS_HOLD = t_hold;

% combine t_trans and t_hold to t_final
TEMPS_FINAL = TEMPS_ACTIVATION + TEMPS_HOLD;

% vector with each transitions final time
TEMPS_FINAL_CUM = cumsum(TEMPS_FINAL);


% PP juli 2011 - Detection tongue root node on the tongue_lar contour
for itongue_lar = length(tongue_lar)-1:-1:1
    if tongue_lar(2,itongue_lar) >= Y0(1, NN)-1 
        ideptongue_lar = itongue_lar + 1;
        break;
    end
end
tongue_lar_mri = tongue_lar(:, ideptongue_lar:end); % PP Juli 2011

% --------------------------------------------------------
% re-format tongue rest position to fit the variable XY
% XY(i) i odd  : x coordinate
% XY(i) i veven: y coordinate

global XY

XY(1:2:2*nNodes-1, 1) = reshape(X0', nNodes, 1);
XY(2:2:2*nNodes, 1) = reshape(Y0', nNodes, 1);

% -----------------------------------------------------------
% muscle length at tongue rest position
global longrepos_GGP longrepos_GGA longrepos_Hyo longrepos_Stylo
global longrepos_SL longrepos_IL longrepos_Vert

% Expected amplitude variation of lambdas
global delta_lambda_tot_GGP delta_lambda_tot_GGA delta_lambda_tot_Hyo
global delta_lambda_tot_Stylo delta_lambda_tot_SL delta_lambda_tot_IL
global delta_lambda_tot_Vert

global longrepos_GGA_max longrepos_GGP_max longrepos_Hyo_max 
global longrepos_IL_max longrepos_SL_max longrepos_Stylo_max longrepos_Vert_max %PP Nov 06

% minimum length of each muscle fiber
global longmin_GGP longmin_GGA longmin_Hyo longmin_Stylo longmin_SL
global longmin_IL longmin_Vert

% It is assumed that each muscle fiber provides the same force.
% The CSAs (cross section area) are the cross-sections of these fibers.
% The value of rho is proportional to the CSAs.
global rho_GG rho_Hyo rho_Stylo rho_SL rho_IL rho_Vert

% proportionality factor between the muscle fibers --------------------
global fac_GGP fac_GGA fac_Hyo fac_Stylo fac_SL fac_IL fac_Vert

idxMuscle = strcmp(myMuscleCol.names, 'GGP');
longrepos_GGP = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_GGP = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation;
longrepos_GGP_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_GGP = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
rho_GG = myMuscleCol.muscleArray(idxMuscle).rho;
fac_GGP = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;

idxMuscle = strcmp(myMuscleCol.names, 'GGA');
longrepos_GGA = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_GGA = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation;
longrepos_GGA_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_GGA = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
% rho_GG = myMuscleCol.muscleArray(idxMuscle).rho;  GGP and GGA shares on
% Variable
fac_GGA = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;

idxMuscle = strcmp(myMuscleCol.names, 'HYO');
longrepos_Hyo = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_Hyo = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation;
longrepos_Hyo_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_Hyo = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
rho_Hyo = myMuscleCol.muscleArray(idxMuscle).rho;
fac_Hyo = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;

idxMuscle = strcmp(myMuscleCol.names, 'STY');
longrepos_Stylo = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_Stylo = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation;
longrepos_Stylo_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_Stylo = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
rho_Stylo = myMuscleCol.muscleArray(idxMuscle).rho;
fac_Stylo = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;

idxMuscle = strcmp(myMuscleCol.names, 'SL');
longrepos_SL = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_SL = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation;
longrepos_SL_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_SL = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
rho_SL = myMuscleCol.muscleArray(idxMuscle).rho;
fac_SL = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;

idxMuscle = strcmp(myMuscleCol.names, 'IL');
longrepos_IL = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_IL = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation; 
longrepos_IL_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_IL = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
rho_IL = myMuscleCol.muscleArray(idxMuscle).rho;
fac_IL = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;

idxMuscle = strcmp(myMuscleCol.names, 'VER');
longrepos_Vert = myMuscleCol.muscleArray(idxMuscle).fiberLengthsAtRest;
delta_lambda_tot_Vert = myMuscleCol.muscleArray(idxMuscle).expectedLambdaVariation;
longrepos_Vert_max = myMuscleCol.muscleArray(idxMuscle).fiberMaxLengthAtRest;
longmin_Vert = myMuscleCol.muscleArray(idxMuscle).fiberMinLength;
rho_Vert = myMuscleCol.muscleArray(idxMuscle).rho;
fac_Vert = myMuscleCol.muscleArray(idxMuscle).fiberLengthsRatio;


maxFiberLengths = [...
    longrepos_GGP_max; ...
    longrepos_GGA_max; ...
    longrepos_Hyo_max; ...
    longrepos_Stylo_max; ...
    longrepos_Vert_max; ...
    longrepos_SL_max; ...
    longrepos_IL_max];

delta_lambda = [...
    deltaLamb_GGP; ...
    deltaLamb_GGA; ... 
    deltaLamb_HYO; ...
    deltaLamb_STY; ...
    deltaLamb_VER; ...
    deltaLamb_SL; ...
    deltaLamb_IL];

global MATRICE_LAMBDA

MATRICE_LAMBDA(:,1) = maxFiberLengths(1:7, 1);

n_phon = length(TEMPS_HOLD);
for nbPhone = 1:n_phon
    MATRICE_LAMBDA(:, 1+nbPhone) = delta_lambda(:, nbPhone) + maxFiberLengths(1:7);
end


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

% Gaussian variables used for squaring A0 so that integral is replaced by a sum: SUM(Hi*f(Gi))
global ordre H G

ordre = speakerModel.ordre;
H = speakerModel.H;
G = speakerModel.G;

% Creation of the force vector FXY which is applied to the nodes.
global FXY

FXY = sparse(2*nNodes, 1);

% Creation of U and Ufin, displacement vectors
global Ufin tfin LOOP U t

Ufin = zeros(1, 4*nNodes);
tfin = 0;
LOOP = 0;
U = zeros(1,4*nNodes);
t = 0;

% constant values for the tongue ---------------------------------
nu = speakerModel.nu; % Poisson's ratio
E = speakerModel.E; % Young's modulus: stiffness; E = 0.7 in Yohan's theses

global lambda mu

lambda = (nu*E)/((1+nu)*(1-2*nu)); % elastic modulus
mu = E/(2*(1+nu)); % shear (elasticity constant)

% --------------------------------------------------------
% calculate mass matrix (2*nNodes by 2*nNodes): the mass associated
% to each node is proportional to the area of the elements sorrounding the
% node.

% Compute each element's area
aire_element = zeros(MM-1, NN-1);
for i=1:MM-1,
    for j=1:NN-1,
        aire_element(i,j) = abs(( (Y0(i+1,j)+Y0(i,j))*(X0(i+1,j)-X0(i,j)) + (Y0(i+1,j+1)+Y0(i+1,j))*(X0(i+1,j+1)-X0(i+1,j)) + (Y0(i,j+1)+Y0(i+1,j+1))*(X0(i,j+1)-X0(i+1,j+1)) + (Y0(i,j)+Y0(i,j+1))*(X0(i,j)-X0(i,j+1))) / 2.0);
    end
end
aire_totale = sum(aire_element(:)); % sum of all areas


global Mass invMass

% compute the mass matrix
Mass = eye(2*nNodes);

masse_totale = speakerModel.masse_totale;

for i = 1:MM
    for j = 1:NN
        k = (i-1)*2*NN+2*j;
        % lower left corner
        if (k==2)
            aire = aire_element(1,1)/4;
        % upper left corner
        elseif (k==2*(MM*NN-NN+1))
            aire = aire_element(MM-1,1)/4;
        % lower right corner
        elseif (k==2*NN)
            aire = aire_element(1,NN-1)/4;
        % upper right corner
        elseif (k==2*NN*MM)
            aire = aire_element(MM-1,NN-1)/4;
        
        % lower edge
        elseif (i==1)
            aire = aire_element(1,j-1)/4+aire_element(1,j)/4;
        % left edge
        elseif (j==1)
            aire = aire_element(i-1,1)/4+aire_element(i,1)/4;
        % upper edge
        elseif (i == MM)
            aire = aire_element(MM-1,j-1)/4+aire_element(MM-1,j)/4;
        % right edge
        elseif (j==NN)
            aire = aire_element(i,NN-1)/4+aire_element(i-1,NN-1)/4;
        
        
        % all the oether nodes
        else
            aire = aire_element(i-1,j-1)/4+aire_element(i,j-1)/4 + ...
                aire_element(i-1,j)/4 + aire_element(i,j)/4;
        end
        Mass(k, k) = Mass(k, k) * masse_totale / aire_totale * aire;
        Mass(k-1, k-1) = Mass(k, k);
    end
end

% To accelerate computation, get the inverse of this matrix
invMass = inv(Mass);

% Compute the elasticity matrix
global A0
A0 = elast_init(XY, lambda, mu, ordre, H, G);

% teeth contact variables -----------------------------------------------
% the vectors Vect_dents and Point_dents are passed to UDOT.m
global Vect_dents Point_dents pente_D org_D nbpalais Point_P pente_P org_P

Vect_dents = [dents_inf(1,11)-dents_inf(1,13)-1 dents_inf(2,11)-dents_inf(2,13)];
Point_dents = [dents_inf(1,13)+1 dents_inf(2,13)];
pente_D = (dents_inf(2,11)-dents_inf(2,13))/(dents_inf(1,11)-dents_inf(1,13));
org_D = dents_inf(2,11)-pente_D*dents_inf(1,11);

% Position of palate and velum
% The contact for the production of consonantes will be between the
% different 'superior' nodes of the tongue and the following points
% As always : odd indices ->  X coordinante
%             even indices -> Y coordinate

% palate
P_palais = (8:length(palate(1,:)));
% all points from MRI palate are taken, points 1 to 7 cooresponds to
% the standard teeth added anywhere)
for i = 1:size(P_palais,2)
    Point_P(2*i-1) = palate(1, P_palais(i));
    Point_P(2*i) = palate(2, P_palais(i));
end

% velum
P_velum = (2:(length(velum(1,:))-5));
% all points of the soft palate are included except the first which 
% corresponds to the last point of the hard palate

for j = i+1:i+size(P_velum,2)
    Point_P(2*j-1) = velum(1,P_velum(j-i));
    Point_P(2*j) = velum(2,P_velum(j-i));
end
nbpalais = size(P_palais,2) + size(P_velum,2);


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

% rotation center of the jaw 
global X_origin_initial Y_origin_initial

X_origin_initial = landmarks.xyCondyle(1);
Y_origin_initial = landmarks.xyCondyle(2);

% ??????????????????????????????????????????????????
U0 = [U(size(t)*[0;1], 1:2*nNodes)]';
U0(2*nNodes+1:4*nNodes, 1) = zeros(2*nNodes, 1);

global nb_contact
nb_contact = 0;

global t_affiche
t_affiche = 0.001;

global t_verbose
t_verbose = 0.001;

nb_transitions = size(MATRICE_LAMBDA,2)-1;


global TEMPS FXY_T ACCL_T ACTIV_T LAMBDA_T

TEMPS = 0;
FXY_T = zeros(1, 2*nNodes);
ACCL_T = zeros(1, 2*nNodes);
ACTIV_T = 0;
LAMBDA_T = 0;

% 
global tf 
t2_targets = TEMPS_FINAL_CUM;
t1_targets = [0 TEMPS_FINAL_CUM(1:length(TEMPS_FINAL_CUM)-1)];
tf = t2_targets(end);

% movement variables: jaw rotation and its effect on the tongue and the lower lip
global U_lowlip U_upperlip U_dents_inf U_pharynx_mri U_lar_ar_mri 
global U_tongue_lar_mri X0_seq Y0_seq ttout

U_lowlip = zeros(round(200*tf), 12); % 30
U_upperlip = zeros(round(200*tf), 12); % 46
U_dents_inf = zeros(round(200*tf), 10); % 34
U_pharynx_mri = zeros(round(200*tf), 13);
U_lar_ar_mri = zeros(round(200*tf), 12);
U_tongue_lar_mri = zeros(round(200*tf), 17);
X0_seq = zeros(round(200*tf), 221);
Y0_seq = zeros(round(200*tf), 221);
ttout = 0;


global X_origin Y_origin

X_origin = X_origin_initial;
Y_origin = Y_origin_initial;

global lar_ar_mri_initial tongue_lar_mri_initial pharynx_mri_initial

lar_ar_mri_initial = lar_ar_mri;
tongue_lar_mri_initial = tongue_lar_mri;
pharynx_mri_initial = pharynx_mri;


udot3init_adapt;

% the simulation starts here ...........................................

global theta_start hyoid_start
global X_origin_ll Y_origin_ll U_X_origin U_Y_origin

global t_initial t_transition t_final theta X0_rest_pos Y0_rest_pos
global theta_ll dist_lip dist_hyoid
global alpha_rest_pos dist_rest_pos

global alpha_rest_pos_dents_inf dist_rest_pos_dents_inf alpha_rest_pos_lowlip dist_rest_pos_lowlip


% open the figure to plot in
global plotFlag h_axes h_tongue h_stylo h_upperLip h_lowerLip h_lowerInc
global h_lar_ar

if (myPlotFlag)
    
    plotFlag = true;
    h_axes = speakerModel.initPlotFigure(false);
    h_tongue = [];
    h_stylo = [];
    h_upperLip = [];
    h_lowerLip = [];
    h_lowerInc = [];
    h_lar_ar = [];
    
    
else
    
    plotFlag = false;
    
end


nTarget = length(t2_targets);
for nbTarget = 1:nTarget
    
    if (nbTarget == 1)
        tfin = [];
        Ufin = [];
        theta_start = 0;
        hyoid_start = 0;
        
        % hier fehlt irgendetwas ???? RW
        
    else
        theta_start = sum(jaw_rotation(1:nbTarget-1));
        hyoid_start = sum(hyoid_movment(1:nbTarget-1));
    end
    
    % intitial tongue position
    X0_rest_pos = X0;
    Y0_rest_pos = Y0;
    
    % the initial angle alpha for each node of the tongue
    alpha_rest_pos = atan2((X_origin-X0_rest_pos), (Y_origin-Y0_rest_pos));
    % the distance of each node of the tongue to the center of rotation
    dist_rest_pos = sqrt( (Y0_rest_pos-Y_origin).^2 + (X0_rest_pos-X_origin).^2 );
    
    %the initial angle alpha of the lower incisor
    alpha_rest_pos_dents_inf = atan2((X_origin-dents_inf(1,:)), ...
        (Y_origin-dents_inf(2,:)));
    
    % the initial distance of the lower incisor to the center of rotation
    dist_rest_pos_dents_inf = sqrt((dents_inf(2,:)-Y_origin).^2 + (dents_inf(1,:)-X_origin).^2);

    X_origin_ll = X_origin;
    Y_origin_ll = Y_origin;
    
    % DO NOT CHANGE THE ORDER HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    global lowlip_initial
    lowlip_initial = lowlip;
    
    
    % the initial angle alpha of the lower lip
    alpha_rest_pos_lowlip = atan2((X_origin_ll-lowlip(1,:)), (Y_origin_ll-lowlip(2,:)));
    %the initial distance of the lower lip to the center of rotation
    dist_rest_pos_lowlip = sqrt((lowlip(2,:)-Y_origin_ll).^2+(lowlip(1,:)-X_origin_ll).^2);
    
    t_initial = t1_targets(nbTarget);
    t_transition = t1_targets(nbTarget) + TEMPS_ACTIVATION(nbTarget);
    t_final = t2_targets(nbTarget);
    theta = jaw_rotation(nbTarget);
    theta_ll = ll_rotation(nbTarget);
    dist_lip = lip_protrusion(nbTarget);
    dist_hyoid = hyoid_movment(nbTarget);

    if (plotFlag)
        
        %plot(h_axes, upperlip(1,:),upperlip(2,:), 'c-' );
        %plot(h_axes, lowlip(1,:),lowlip(2,:), 'c-' );
        plot(h_axes, palate(1,1:end), palate(2,1:end),'k-', 'LineWidth', 2)
        plot(h_axes, velum(1,1:end), velum(2,1:end),'k-', 'LineWidth', 2)
        plot(h_axes, pharynx_mri(1,1:end), pharynx_mri(2,1:end),'k-', 'LineWidth', 2)
        %plot(h_axes, lar_ar_mri(1,:), lar_ar_mri(2,:),'k-')
        %plot(h_axes, tongue_lar_mri(1,:), tongue_lar_mri(2,:),'k-')

        % plot tongue and lower jaw contours in rest position
        %plot(h_axes, dents_inf(1,:),dents_inf(2,:), 'k--');
        %plot(h_axes, X_origin, Y_origin, 'ko');
        drawnow
        
        %pause
        
    end
    
    fprintf('Integrating from %1.4f to %1.4f seconds\n', t1_targets(nbTarget), t2_targets(nbTarget));
    
    [ts, Us] = ode45plus('udot3_adapt_jaw', t1_targets(nbTarget), t2_targets(nbTarget), ...
        U0, 1e-3, (((3*2)-2)/500));
    
    U0 = Us(length(ts), :);
    tfin = [tfin; ts];
    Ufin = [Ufin; Us];
end














% here the simulation seems to be already finnished . (post-processing) ..
global length_ttout % this var gets its value in udot3_adapt_jaw.m

if ( length_ttout < (200 * tf) )
    U_X_origin = U_X_origin(1:length_ttout);
    U_Y_origin = U_Y_origin(1:length_ttout);
    U_lowlip = U_lowlip(1:length_ttout,1:end);
    U_upperlip = U_upperlip(1:length_ttout,1:end);
    U_dents_inf = U_dents_inf(1:length_ttout,1:end);
    U_pharynx_mri = U_pharynx_mri(1:length_ttout,1:end);
    U_lar_ar_mri = U_lar_ar_mri(1:length_ttout,1:end);
    U_tongue_lar_mri = U_tongue_lar_mri(1:length_ttout,1:end);
    X0_seq = X0_seq(1:length_ttout, 1:nNodes);
    Y0_seq = Y0_seq(1:length_ttout, 1:nNodes);
end

t = tfin';
U = Ufin;

[t_ord, ind_ord] = sort(TEMPS);

% remove the repeated elements of t_ord
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

% ACTIV_TRAJ: matrix with the activation function of time for each muscle fiber 
% ACTIV_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]

LAMBDA_ord = LAMBDA_T(ind_ord, :);
LAMBDA_bon = LAMBDA_ord(ind_bon, :);

LAMBDA_TRAJ = interp1(t_bon, LAMBDA_bon, t);

clear global TEMPS FXY_T ACCL_T ACTIV_T LAMBDA_T

% save tongue movement and force tracks

% convert from radiant to degree ---
jaw_rotation_degree = jaw_rotation*180/pi;
ll_rotation_degree = ll_rotation*180/pi;


% collect the simulation data in the obsolete file format ---------
matUtt_obsolete.modelName = speakerModel.modelName;
matUtt_obsolete.modelUUID = speakerModel.modelUUID;
matUtt_obsolete.U = U;
matUtt_obsolete.t = t;
matUtt_obsolete.ttout = ttout;
matUtt_obsolete.MM = MM; 
matUtt_obsolete.NN = NN;
matUtt_obsolete.seq = seq;
matUtt_obsolete.TEMPS_FINAL = TEMPS_FINAL;
matUtt_obsolete.TEMPS_HOLD = TEMPS_HOLD;
matUtt_obsolete.TEMPS_FINAL_CUM = TEMPS_FINAL_CUM;
matUtt_obsolete.TEMPS_ACTIVATION = TEMPS_ACTIVATION;
matUtt_obsolete.MATRICE_LAMBDA = MATRICE_LAMBDA;
matUtt_obsolete.nb_transitions = nb_transitions;
matUtt_obsolete.jaw_rotation = jaw_rotation_degree;
matUtt_obsolete.lip_protrusion = lip_protrusion;
matUtt_obsolete.ll_rotation = ll_rotation_degree;
matUtt_obsolete.hyoid_movment = hyoid_movment;
matUtt_obsolete.FXY_TRAJ = FXY_TRAJ;
matUtt_obsolete.ACCL_TRAJ = ACCL_TRAJ;
matUtt_obsolete.ACTIV_TRAJ = ACTIV_TRAJ;
matUtt_obsolete.LAMBDA_TRAJ = LAMBDA_TRAJ;
matUtt_obsolete.X0 = X0;
matUtt_obsolete.Y0 = Y0;
matUtt_obsolete.U_dents_inf = U_dents_inf;
matUtt_obsolete.U_lowlip = U_lowlip;
matUtt_obsolete.U_upperlip = U_upperlip;
matUtt_obsolete.U_pharynx_mri = U_pharynx_mri;
matUtt_obsolete.U_lar_ar_mri = U_lar_ar_mri;
matUtt_obsolete.U_tongue_lar_mri = U_tongue_lar_mri;
matUtt_obsolete.X0_seq = X0_seq;
matUtt_obsolete.Y0_seq = Y0_seq;
matUtt_obsolete.U_X_origin = U_X_origin;
matUtt_obsolete.U_Y_origin = U_Y_origin;

disp(['number of contacts: ' num2str(nb_contact)]);
disp(['number of function calls (UDOT): ' num2str(kkk)]);

toc
% convert obsolete file format into new mat-file
matUtt = convert_matSim_to_matUtterance(matUtt_obsolete);

end
