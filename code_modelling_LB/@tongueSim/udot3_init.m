function udot3_init (TSObj)
% UDOT3_INIT Necessary precalculations for the execution of udot3

% --------------------------------------------------------------------
% General initialisations
TSObj.NNxMM = TSObj.MM*TSObj.NN;
TSObj.NNx2=TSObj.NN*2;
TSObj.MMx2=TSObj.MM*2;
TSObj.NNxMMx2=2*TSObj.NNxMM;

% --------------------------------------------------------------------
% Valeurs des constantes
% On sait que : F = M.(f1+f2.atan(f3+f4.l'/longrepos)+f5.l'/longrepos)  
% Valeur des f#
TSObj.f1=0.80;
TSObj.f2=0.5;
TSObj.f3=0.43;
TSObj.f4=0.8/1.5;
TSObj.f5=0.023/0.7;
TSObj.MU=0.01;   % en s
TSObj.c=0.112;   % en mm-1
TSObj.nc=0;
TSObj.pc=0;
TSObj.aff_fin=0;

% Variable for the detection of contact for the program press.m only
TSObj.contact=0;



% --------------------------------------------------------------------
% Compute f by the diff equation (???)  
if TSObj.fact==1
  TSObj.f=0.005/2;
else
   TSObj.f=0.005/3.5079/2;  % because the number of nodes is multiplied by 3.5 
end % selon fact (in fact?)
TSObj.F=TSObj.f*eye(TSObj.NNxMMx2);

% --------------------------------------------------------------------
% Put the weights on the componenents of Y
TSObj.PXY=zeros(TSObj.NNxMMx2,1);
for i=2:TSObj.NNxMMx2 % loop over all the nodes
  TSObj.PXY(i)=-9.81*TSObj.Mass(i,i);
end %    

% --------------------------------------------------------------------
%  Calculate the muscle attachment points

% GGP genioglossus posterior
for i=1:3*TSObj.fact+1
  TSObj.Att.GGP(i,1)=TSObj.NN*(TSObj.fact+i-1)+1;
end
TSObj.Att.GGP(:,2)=TSObj.Att.GGP(:,1)+TSObj.NN-TSObj.fact;
TSObj.Att.GGP(:,3)=TSObj.Att.GGP(:,1)*2;
TSObj.Att.GGP(:,4)=TSObj.Att.GGP(:,2)*2;

% GGA genio glossus anterior 
for i=1:3*TSObj.fact % Nov 99
  TSObj.Att.GGA(i,1)=TSObj.NN*(4*TSObj.fact+i)+1;
end
TSObj.Att.GGA(:,2)=TSObj.Att.GGA(:,1)+TSObj.NN-TSObj.fact;
TSObj.Att.GGA(:,3)=TSObj.Att.GGA(:,1)*2;
TSObj.Att.GGA(:,4)=TSObj.Att.GGA(:,2)*2;

% Stylo styloglossus
TSObj.Att.Stylo1(1,1)=3*TSObj.fact*TSObj.NN+1+4*TSObj.fact;
% Att.Stylo1(2,1)=(8*fact-1)*NN+4*fact; % Modifs YP-PP Nov 99
TSObj.Att.Stylo1(2,1)=7*TSObj.fact*TSObj.NN+4*TSObj.fact; % Modifs PP 1/03/2000
TSObj.Att.Stylo1(3,1)=4*TSObj.fact*TSObj.NN+1+4*TSObj.fact;
TSObj.Att.Stylo1(:,2)=TSObj.Att.Stylo1(:,1)*2;

% Hyo Hyoglossus
TSObj.Att.Hyo1(1,1)=(5*TSObj.fact-1)*TSObj.NN+1+3*TSObj.fact;% Modifs YP-PP Dec 99
TSObj.Att.Hyo1(2,1)=6*TSObj.fact*TSObj.NN+1+4*TSObj.fact;% Modifs YP-PP Dec 99
TSObj.Att.Hyo1(3,1)=4*TSObj.fact*TSObj.NN+1+4*TSObj.fact;% Modifs YP-PP Dec 99
TSObj.Att.Hyo1(4,1)=3*TSObj.fact*TSObj.NN+1+5*TSObj.fact;
TSObj.Att.Hyo1(:,2)=TSObj.Att.Hyo1(:,1)*2;

% SL Longitudinalis superior
TSObj.Att.SL(1,1)=TSObj.fact*(2*TSObj.NN+6)+1;       % Modifs YP-PP Dec 99
TSObj.Att.SL(1,2)=TSObj.NNxMM;      % Modifs YP-PP Dec 99
TSObj.Att.SL(2,1)=TSObj.fact*(2*TSObj.NN+6);         % Modifs YP-PP Dec 99
TSObj.Att.SL(2,2)=TSObj.NNxMM-1;      % Modifs YP-PP Dec 9
TSObj.Att.SL(:,3)=TSObj.Att.SL(:,1)*2;      % Modifs YP-PP Dec 99
TSObj.Att.SL(:,4)=TSObj.Att.SL(:,2)*2;      % Modifs YP-PP Dec 99

% IL Longitudinalis inferior
TSObj.Att.IL(1,1)=4*TSObj.fact*TSObj.NN+2*TSObj.fact+1;     % i=31 (109 pour le modele a 221);
TSObj.Att.IL(2,1)=7*TSObj.fact*TSObj.NN+3*TSObj.fact+1;     % j=53; (189) pour le modele a 221);
if TSObj.fact==1
  TSObj.Att.IL(3,1)=61;
else
%  Att.IL(3,1)=149; % ERREUR LA FIBRE FAIR UN ALLER RETOUR ET NE VA PAS DANS L'APEX
   TSObj.Att.IL(3,1)=221-4; % corrected by Pascal on May 4 1999, to be corrected 
end
TSObj.Att.IL(:,2)=TSObj.Att.IL(:,1)*2;

% Vert vertical genioglossus fibre
for i=1:3*TSObj.fact % Modifs Dec 99 YP-PP
  TSObj.Att.Vert(i,1)=(i-1)*TSObj.NN+TSObj.fact*(5*TSObj.NN+3)+1; % Modif Dec 99 YP-PP
  TSObj.Att.Vert(i,2)=(i-1)*TSObj.NN+TSObj.fact*(5*TSObj.NN+6); % Modif Dec 99 YP-PP 
end
TSObj.Att.Vert(:,3)=TSObj.Att.Vert(:,1)*2;
TSObj.Att.Vert(:,4)=TSObj.Att.Vert(:,2)*2;

% Choix de la pression de reference
if (TSObj.Pref==0)
  TSObj.DoPress = 0;
else
  TSObj.DoPress = 1;
end

% Initialisation of the semaphore for the 1st passage
TSObj.PRESS_FLAG = 0;
TSObj.PressDebug = 0;

% Added by Yohan & Majid; Nov 30, 99
for i=1:TSObj.MM
   for j=1:TSObj.NN
     TSObj.v1=(i-1)*TSObj.NNx2+2*j;
     TSObj.X0Y0(TSObj.v1-1,1)=TSObj.restpos.X0(i,j);
     TSObj.X0Y0(TSObj.v1,1)=TSObj.restpos.Y0(i,j);
   end
end
