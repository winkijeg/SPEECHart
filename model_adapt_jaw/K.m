function K=K(r,s,XY,lambda2,mu2,pfix)

% Modifications apportees :
%   - Passage par parametre de lambda2 et mu2 valeur de lambda et de
%     mu pour l'element comnsidere
%   - Passage de pfix qui indique quels noeuds sont fixes :
%                   3             4
%                    _____________
%                   /            /
%                  /     jj     /
%                 /            /
%                 -------------
%                1            2
% sachant que si 1 est fixe alors 3 est fixe aussi

global IX;
global IY;
x=XY(IX);
y=XY(IY);
global IA;
global IB;
global IC;
global ID;
global IE;

dpsidr=0.25*[s-1,1-s,-1-s,1+s];
dpsids=0.25*[r-1,-1-r,1-r,1+r];
detJ=(dpsidr*x)*(dpsids*y)-(dpsids*x)*(dpsidr*y);
dpsidx=(dpsids*y)*dpsidr-(dpsidr*y)*dpsids;
dpsidy=(dpsidr*x)*dpsids-(dpsids*x)*dpsidr;
dpsi=[dpsidx,dpsidy,0];

if pfix==0
  IAfix=IA;
  IDfix=ID;
elseif pfix==1
  IAfix=[9*ones(1,16),IA(17:32),9*ones(1,16),IA(49:64)];
  IDfix=[9*ones(1,16),ID(17:32),9*ones(1,16),ID(49:64)];
elseif pfix==2
  IAfix=[IA(1:16),9*ones(1,16),IA(33:64)];
  IDfix=[ID(1:16),9*ones(1,16),ID(33:64)];
elseif pfix==3
  IAfix=[IA(1:32),9*ones(1,16),IA(48:64)];
  IDfix=[ID(1:32),9*ones(1,16),ID(48:64)];
elseif pfix==4
  IAfix=[IA(1:48),9*ones(1,16)];
  IDfix=[ID(1:48),9*ones(1,16)];
end

A=dpsi(IAfix);
B=dpsi(IB);
C=dpsi(IC);
D=dpsi(IDfix);
E=dpsi(IE);

K=(1/abs(detJ))*(A.*(lambda2*B+2*mu2*C)+mu2*D.*E);
