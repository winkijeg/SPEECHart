% udot3init_adapt.m
% Pre-calculs necessaires a l'execution de udot3

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% --------------------------------------------------------------------
% Variables globales d'entree
global MM NN;                   % Taille du modele
global fact;                    % Resolution du modele
global Mass;                    % Masse des noeuds
% --------------------------------------------------------------------
% Variables globales de sortie
global NNxMM NNx2 MMx2 NNxMMx2; % Des multiplications...
global f1 f2 f3 f4 f5;          % Coefficients p. le calcul des forces
global MU c;                    % Idem
global f F;                     % Constante et matrice de frottement
global PXY;                     % Poids
global nc pc aff_fin;           % Indices pour le contact      
global Att_GGP Att_GGA Att_Hyo; % Points d'attache des muscles
global Att_Stylo Att_SL Att_IL; % Idem
global Att_Vert;                % Idem
global x xx y yy;               % La grille saggitale
global Xe Ye;                   % Le contour exterieur
global Xi Yi;                   % Parties fixes du contour interieur
global Cl Cs;                   % Constantes pour le passage a l'aire
global Pref DoPress;            % La pression de reference
global PRESS_FLAG;              % semaphore pour l'affichage (temp)
global PressDebug;              % Semaphore de debuggage

global contact;               % Variable indiquant si le contact a deja 
                              % eu lieu (pour press.m uniquement) (PP Mars 2000)

global X0 Y0 X0Y0					  % Modified by Yohan & Majid; Nov 30, 99
% --------------------------------------------------------------------
% Initialisations generales
NNxMM = MM*NN;
NNx2=NN*2;
MMx2=MM*2;
NNxMMx2=2*NNxMM;

% --------------------------------------------------------------------
% Valeurs des constantes
% On sait que : F = M.(f1+f2.atan(f3+f4.l'/longrepos)+f5.l'/longrepos)  
% Valeur des f#
f1=0.80;
f2=0.5;
f3=0.43;
f4=0.8/1.5;
f5=0.023/0.7;
MU=0.01;   % en s
c=0.112;   % en mm-1
nc=0;
pc=0;
aff_fin=0;

% Variable de détection de contact pour le programme press.m uniquement
contact=0;



% --------------------------------------------------------------------
% Calcul du f de l'equa diff  
if fact==1
  f=0.005/2;
else
   f=0.005/3.5079/2;  % car le nombre de noeuds est multiplie par 3.5
end % selon fact
F=f*eye(NNxMMx2);

% --------------------------------------------------------------------
% On met la pesanteur sur les composantes Y
PXY=zeros(NNxMMx2,1);
for i=2:NNxMMx2
  PXY(i)=-9.81*Mass(i,i);
end % boucle sur tous les noeuds   

% --------------------------------------------------------------------
% On calcule les points d'attache des muscles

% GGP
for i=1:3*fact+1
  Att_GGP(i,1)=NN*(fact+i-1)+1;
end
Att_GGP(:,2)=Att_GGP(:,1)+NN-fact;
Att_GGP(:,3)=Att_GGP(:,1)*2;
Att_GGP(:,4)=Att_GGP(:,2)*2;

% GGA
for i=1:3*fact % Nov 99
  Att_GGA(i,1)=NN*(4*fact+i)+1;
end
Att_GGA(:,2)=Att_GGA(:,1)+NN-fact;
Att_GGA(:,3)=Att_GGA(:,1)*2;
Att_GGA(:,4)=Att_GGA(:,2)*2;

% Stylo
Att_Stylo(1,1)=3*fact*NN+1+4*fact;
% Att_Stylo(2,1)=(8*fact-1)*NN+4*fact; % Modifs YP-PP Nov 99
Att_Stylo(2,1)=7*fact*NN+4*fact; % Modifs PP 1/03/2000
Att_Stylo(3,1)=4*fact*NN+1+4*fact;
Att_Stylo(:,2)=Att_Stylo(:,1)*2;

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
Att_IL(1,1)=4*fact*NN+2*fact+1;     % i=31 (109 pour le modele a 221);
Att_IL(2,1)=7*fact*NN+3*fact+1;     % j=53; (189) pour le modele a 221);
if fact==1
  Att_IL(3,1)=61;
else
%  Att_IL(3,1)=149; % ERREUR LA FIBRE FAIR UN ALLER RETOUR ET NE VA PAS DANS L'APEX
   Att_IL(3,1)=221-4; % CORRECTION APPORTEE PAR PASCAL LE 4 MAI 1999 POUR CORRIGER 
end
Att_IL(:,2)=Att_IL(:,1)*2;

% Vert
for i=1:3*fact % Modifs Dec 99 YP-PP
  Att_Vert(i,1)=(i-1)*NN+fact*(5*NN+3)+1; % Modif Dec 99 YP-PP
  Att_Vert(i,2)=(i-1)*NN+fact*(5*NN+6); % Modif Dec 99 YP-PP 
end
Att_Vert(:,3)=Att_Vert(:,1)*2;
Att_Vert(:,4)=Att_Vert(:,2)*2;

% % --------------------------------------------------------------------
% % On charge la grille pour le calcul des forces de pression,
% load XY_grille ;
% 
% % --------------------------------------------------------------------
% % On calcule les intersections fixes
% % Contour exterieur
% % Larynx
% for i=3:-1:1
%   [Xe(i),Ye(i)]=intersection(x(i),y(i),xx(i),yy(i),lar_ar(1,9-i),lar_ar(2,9-i),lar_ar(1,10-i),lar_ar(2,10-i));
% end
% % Pharynx
% ind_pha=[6 7 , 11 10 , 12 14 , 15 16 , 18 19 , 19 20 , 22 20 , 22 24 , 26 24 , 24 26 , 25 26];
% for i=14:-1:4
%   [Xe(i),Ye(i)]=intersection(x(i),y(i),xx(i),yy(i),pharynx(1,ind_pha(29-2*i)),pharynx(2,ind_pha(29-2*i)),pharynx(1,ind_pha(30-2*i)),pharynx(2,ind_pha(30-2*i)));
% end
% % Velum
% ind_vel=[2 5 , 5 8 , 10 8 , 12 14 , 17 19 , 21 23];
% for i=20:-1:15
%   [Xe(i),Ye(i)]=intersection(x(i),y(i),xx(i),yy(i),velum(1,ind_vel(41-2*i)),velum(2,ind_vel(41-2*i)),velum(1,ind_vel(42-2*i)),velum(2,ind_vel(42-2*i)));
% end
% % Palate
% ind_pal=[8 7 , 8 7 , 8 9 , 10 9 , 10 11 , 12 11 , 12 13 , 14 15];
% for i=28:-1:21
%   [Xe(i),Ye(i)]=intersection(x(i),y(i),xx(i),yy(i),palate(1,ind_pal(57-2*i)),palate(2,ind_pal(57-2*i)),palate(1,ind_pal(58-2*i)),palate(2,ind_pal(58-2*i)));
% end
% % Dents
% Xe(29)=palate(1,5);
% Ye(29)=palate(2,5);
% % Levres
% Xe(30)=upperlip(1,16);
% Ye(30)=upperlip(2,16);
% 
% % Contour interieur (sous reserve de modif par la langue)
% % Larynx
% Xi(6)=x(6)+(xx(6)-x(6))/550*140;
% Yi(6)=y(6)+(yy(6)-y(6))/550*140;
% Xi(5)=x(5)+(xx(5)-x(5))/550*170;
% Yi(5)=y(5)+(yy(5)-y(5))/550*170;
% Xi(4)=x(4)+(xx(4)-x(4))/550*200; 
% Yi(4)=y(4)+(yy(4)-y(4))/550*200; 
% Xi(3)=x(3)+(xx(3)-x(3))/550*145;
% Yi(3)=y(3)+(yy(3)-y(3))/550*145;
% Xi(2)=x(2)+(xx(2)-x(2))/550*105;
% Yi(2)=y(2)+(yy(2)-y(2))/550*105;
% Xi(1)=x(1)+(xx(1)-x(1))/550*70;
% Yi(1)=y(1)+(yy(1)-y(1))/550*70;
% % Dents
% Xi(29)=dents_inf(1,9);
% Yi(29)=dents_inf(2,9);
% % Levres
% Xi(30)=lowlip(1,12);
% Yi(30)=lowlip(2,12);
% 
% Cs = [1.36 2.57 1.05 1.16 1.45 1.60 1.25];
% Cl = [1.36 2.74 3.04 2.37 2.89 2.91 2.12];
% % Coefficients pour le passage a l'aire
% Cs(1) = 1.36;
% Cs(2) = 2.57;
% Cs(3) = 1.05;
% Cs(4) = 1.16;
% Cs(5) = 1.45;
% Cs(6) = 1.60;
% Cs(7) = 1.25;
% Cl(1) = 1.36;
% Cl(2) = 2.74;
% Cl(3) = 3.04;
% Cl(4) = 2.37;
% Cl(5) = 2.89;
% Cl(6) = 2.91;
% Cl(7) = 2.12;
% 
% Choix de la pression de reference
if (Pref==0)
  DoPress = 0;
else
  DoPress = 1;
end

% Initialisation dusemaphore de 1er passage
PRESS_FLAG = 0;
PressDebug = 0;

% Added by Yohan & Majid; Nov 30, 99
for i=1:MM
   for j=1:NN
     v1=(i-1)*NNx2+2*j;
     X0Y0(v1-1,1)=X0(i,j);
     X0Y0(v1,1)=Y0(i,j);
   end
end
