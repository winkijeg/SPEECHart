function K=K(TSObj, r, s, XY, lambda2, mu2, pfix)
% K A function that does stuff
% Modifications:
%   - Passage par parametre de lambda2 et mu2 valeur de lambda et de
%     mu pour l'element considere
%   - Passage de pfix qui indique quels noeuds sont fixes :
%                   3             4
%                    _____________
%                   /            /
%                  /     jj     /
%                 /            /
%                 -------------
%                1            2
% sachant que si 1 est fixe alors 3 est fixe aussi


x=XY(TSObj.IX);
y=XY(TSObj.IY);


dpsidr=0.25*[s-1,1-s,-1-s,1+s];
dpsids=0.25*[r-1,-1-r,1-r,1+r];
detJ=(dpsidr*x)*(dpsids*y)-(dpsids*x)*(dpsidr*y);
dpsidx=(dpsids*y)*dpsidr-(dpsidr*y)*dpsids;
dpsidy=(dpsidr*x)*dpsids-(dpsids*x)*dpsidr;
dpsi=[dpsidx,dpsidy,0];

if pfix==0
  IAfix=TSObj.IA;
  IDfix=TSObj.ID;
elseif pfix==1
  IAfix=[9*ones(1,16),TSObj.IA(17:32),9*ones(1,16),TSObj.IA(49:64)];
  IDfix=[9*ones(1,16),TSObj.ID(17:32),9*ones(1,16),TSObj.ID(49:64)];
elseif pfix==2
  IAfix=[IA(1:16),9*ones(1,16),TSObj.IA(33:64)];
  IDfix=[ID(1:16),9*ones(1,16),TSObj.ID(33:64)];
elseif pfix==3
  IAfix=[TSObj.IA(1:32),9*ones(1,16),TSObj.IA(48:64)];
  IDfix=[TSObj.ID(1:32),9*ones(1,16),TSObj.ID(48:64)];
elseif pfix==4
  IAfix=[TSObj.IA(1:48),9*ones(1,16)];
  IDfix=[TSObj.ID(1:48),9*ones(1,16)];
end

A=dpsi(IAfix);
B=dpsi(TSObj.IB);
C=dpsi(TSObj.IC);
D=dpsi(IDfix);
E=dpsi(TSObj.IE);

K=(1/abs(detJ))*(A.*(lambda2*B+2*mu2*C)+mu2*D.*E);
