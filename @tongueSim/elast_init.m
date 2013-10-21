function A0=elast_init(TSObj, activeGGA, activeGGP, activeHyo, activeStylo,...
    activeSL, activeVert, ncontact);
% ELAST_INIT Compute the elasticity matrix
%   A0 = ELAST_INIT(ACTIVEGGA, ACTIVEGGP, ACTIVEHYO, ACTIVESTYLO, ACTIVESL, 
%        ACTIVEVERT, NCONTACT)
%   Compute the elasticity matrix A0 as a function of the different muscles'
%   activities : E's value is 15kPa for an element at rest and 250 kPa for
%   an element at maximum contraction.
%   This corresponds to multiplying lambda and mu to upto 16 times their
%   initial value.
%   Input arguments are 
%   - the muscle activations
%   - ncontact which is a vector containing 0 and the indices of the nodes
%    having contact with the palate : les coefficients de la
%    matrice d'elasticite dependent en effet des points fixes de
%    l'element considere.

AA=zeros(1,(2*TSObj.NN*TSObj.MM)^2);
jump=-2;
xy = zeros(8, (TSObj.NN-1)*(TSObj.MM-1));
% xy is filled column by column in the for loop, but then xy is never used...

for jj=1:(TSObj.NN-1)*(TSObj.MM-1)    % Loop over elements
  if rem(jj-1,TSObj.NN-1)==0  % jump is incremented at every row change
    jump=jump+2;
  end  
  
  % The column jj of xy contains the coordinates of the four nodes of the
  % element jj in the order : x1 y1 x2 y2 x3 y3 x4 y4
  % 
  %                   3             4
  %                    _____________
  %                   /            /
  %                  /     jj     /
  %                 /            /
  %                 -------------
  %                1            2
  % 
  xy(:,jj)=[TSObj.XY(2*jj-1+jump:2*jj+2+jump);...
      TSObj.XY(2*jj-1+2*TSObj.NN+jump:2*jj+2+2*TSObj.NN+jump)];
  
  % The components of the elasticity matrix corresponding to each element
  % are added to KK which is a piece of a row of A0.
  % The calcluations use the K*.m matlab programms depending on whether the
  % considered element possesses fixed nodes or not.
  % Gaussian quadrature is used.
  KK=sparse(1,64);
  
  % The elements are separated according to their position: fixed, attached
  % to one of the sides and according to the muscles which transverse them.
  
  % Modifications of lambda and mu as a function of muscle activity
  % WEIRDNESS: why use lambda2 and mu2?
  lambda2=TSObj.lambda;
  mu2=TSObj.mu;

  
  % Compute according to the elements position
  if jj==TSObj.NN-1                    % element at the fixed node at the bottom right
    pfix=2;
  elseif rem(jj,TSObj.NN-1)==1         % element at fixed nodes at top or bottom on the left
    pfix=1;
% Modif Novembre 99 YP - PP
%  elseif sum(jj==6*ncontact/7-6) % element dont le noeud haut gauche entre en contact
%    pfix=3;
%  elseif sum(jj==6*ncontact/7)   % element dont le noeud haut droit entre en contact
%    pfix=4;
  else                           % element libre
    pfix=0;
  end
  for i=1:TSObj.order
    for j=1:TSObj.order
      KK=KK+TSObj.H(TSObj.order,i)*TSObj.H(TSObj.order,j)*...
          TSObj.K(TSObj.G(TSObj.order,i),TSObj.G(TSObj.order,j),xy(:,jj),lambda2,mu2,pfix);
    end
  end
  
  debut=(2*TSObj.NN*TSObj.MM)*(2*jj-2+jump)+2*jj-1+jump;
  colonne=[debut*ones(1,4)+[0,1,2,3],(debut+2*TSObj.NN)*ones(1,4)+[0,1,2,3]];
  step=(2*TSObj.NN*TSObj.MM)*ones(1,8);
  II=[colonne,colonne+step,colonne+2*step,colonne+3*step];
  I=[II,II+2*TSObj.NN*(2*TSObj.NN*TSObj.MM)*ones(1,32)];
  AA(I)=AA(I)+KK;
end    % of element loop

A0=reshape(AA,2*TSObj.NN*TSObj.MM,2*TSObj.NN*TSObj.MM);


