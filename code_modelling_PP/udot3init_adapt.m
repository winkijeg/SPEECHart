function udot3init_adapt()
% Pre-calculs necessaires a l'execution de udot3

% Variables globales d'entree
global MM NN                     % Taille du modele
global fact                      % Resolution du modele
global Mass                      % Masse des noeuds

% Variables globales de sortie
global NNxMM NNx2 MMx2 NNxMMx2   % Des multiplications...
global f1 f2 f3 f4 f5            % Coefficients p. le calcul des forces
global MU c                      % Idem
global f F                       % Constante et matrice de frottement
global PXY                       % Poids
global nc pc aff_fin             % Indices pour le contact      
global Att_GGP Att_GGA Att_Hyo   % Points d'attache des muscles
global Att_Stylo Att_SL Att_IL   % Idem
global Att_Vert                  % Idem
global Pref DoPress              % La pression de reference

global X0 Y0 X0Y0                % Modified by Yohan & Majid; Nov 30, 99


NNxMM = MM * NN;
NNx2 = NN * 2;
MMx2 = MM * 2;
NNxMMx2 = 2 * NNxMM;

% Valeurs des constantes
% On sait que : F = M.(f1+f2.atan(f3+f4.l'/longrepos)+f5.l'/longrepos)  
% Valeur des f#
f1 = 0.80;
f2 = 0.5;
f3 = 0.43;
f4 = 0.8/1.5;
f5 = 0.023/0.7;
MU = 0.01;   % en s
c = 0.112;   % en mm-1
nc = 0;
pc = 0;
aff_fin = 0;

% Calcul du f de l'equa diff  
f = 0.005/3.5079/2;  % car le nombre de noeuds est multiplie par 3.5
F = f * eye(NNxMMx2);

% On met la pesanteur sur les composantes Y
PXY = zeros(NNxMMx2,1);
for i = 2:NNxMMx2
  PXY(i) = -9.81 * Mass(i,i);
end % boucle sur tous les noeuds   

% --------------------------------------------------------------------
% On calcule les points d'attache des muscles

% GGP
for i = 1:7
  Att_GGP(i,1) = NN*(fact+i-1)+1;
end
Att_GGP(:,2) = Att_GGP(:,1) + NN - fact;
Att_GGP(:,3) = Att_GGP(:,1) * 2;
Att_GGP(:,4) = Att_GGP(:,2) * 2;

% GGA
for i = 1:6
  Att_GGA(i,1) = NN * (4*fact+i)+1;
end
Att_GGA(:,2) = Att_GGA(:,1) + NN - fact;
Att_GGA(:,3) = Att_GGA(:,1) * 2;
Att_GGA(:,4) = Att_GGA(:,2) * 2;

% Stylo
Att_Stylo(1,1) = 3*fact*NN+1+4*fact;
Att_Stylo(2,1) = 7*fact*NN+4*fact;
Att_Stylo(3,1) = 4*fact*NN+1+4*fact;
Att_Stylo(:,2) = Att_Stylo(:,1) * 2;

% Hyo
Att_Hyo(1,1)=(5*fact-1)*NN+1+3*fact;% Modifs YP-PP Dec 99
Att_Hyo(2,1)=6*fact*NN+1+4*fact;% Modifs YP-PP Dec 99
Att_Hyo(3,1)=4*fact*NN+1+4*fact;% Modifs YP-PP Dec 99
Att_Hyo(4,1)=3*fact*NN+1+5*fact;
Att_Hyo(:,2)=Att_Hyo(:,1)*2;

% SL
Att_SL(1,1)=fact*(2*NN+6)+1;       % Modifs YP-PP Dec 99
Att_SL(1,2)=NNxMM;      % Modifs YP-PP Dec 99
Att_SL(2,1)=fact*(2*NN+6);         % Modifs YP-PP Dec 99
Att_SL(2,2)=NNxMM-1;      % Modifs YP-PP Dec 9
Att_SL(:,3)=Att_SL(:,1)*2;      % Modifs YP-PP Dec 99
Att_SL(:,4)=Att_SL(:,2)*2;      % Modifs YP-PP Dec 99

% IL
Att_IL(1,1) = 4*fact*NN+2*fact+1;     % i=31 (109 pour le modele a 221);
Att_IL(2,1) = 7*fact*NN+3*fact+1;     % j=53; (189) pour le modele a 221);
Att_IL(3,1) = 221-4; % CORRECTION APPORTEE PAR PASCAL LE 4 MAI 1999 POUR CORRIGER 
Att_IL(:,2) = Att_IL(:,1) * 2;

% Vert
for i = 1:6
  Att_Vert(i,1) = (i-1)*NN+fact*(5*NN+3)+1;
  Att_Vert(i,2) = (i-1)*NN+fact*(5*NN+6); 
end
Att_Vert(:,3) = Att_Vert(:,1) * 2;
Att_Vert(:,4) = Att_Vert(:,2) * 2;

% Choix de la pression de reference
if (Pref == 0)
  DoPress = 0;
else
  DoPress = 1;
end

% Added by Yohan & Majid; Nov 30, 99
for i = 1:MM
   for j = 1:NN
     v1 = (i-1)*NNx2+2*j;
     X0Y0(v1-1,1) = X0(i,j);
     X0Y0(v1,1) = Y0(i,j);
   end
end

end

