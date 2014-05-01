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

disp('Initializing elasticity matrix.')

nNodes = TSObj.NN * TSObj.MM;

nColsShort = TSObj.NN-1;
nRowsShort = TSObj.MM-1;

nSteps = nColsShort*nRowsShort;


AA=zeros(1,(2*nNodes)^2);
jump=-2;
% xy = zeros(8, (TSObj.NN-1)*(TSObj.MM-1));
% xy is filled column by column in the for loop, but then xy is never used...

for nbStep = 1:nSteps    % Loop over elements

  isFirstNodeOnShortRow = rem(nbStep-1, nColsShort) == 0;
        
    if isFirstNodeOnShortRow
      jump = jump + 2; % jump is incremented at every change of row.
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
  xy = [TSObj.restpos.XY(2*nbStep-1+jump:2*nbStep+2+jump);...
      TSObj.restpos.XY(2*nbStep-1+2*TSObj.NN+jump:2*nbStep+2+2*TSObj.NN+jump)];
  
  
  % The elements are separated according to their position: fixed, attached
  % to one of the sides and according to the muscles which transverse them.
  

  % Compute according to the elements position
  if nbStep == nColsShort                    % element at the fixed node at the bottom right
    pfix=2;
  elseif rem(nbStep, nColsShort) == 1         % element at fixed nodes at top or bottom on the left
    pfix=1;
  else                           % element not fixed
    pfix=0;
  end

  KK = sparse(1, 64);
  for i=1:TSObj.order
    for j=1:TSObj.order
      KK=KK+TSObj.H(TSObj.order,i)*TSObj.H(TSObj.order,j)*...
          TSObj.calculate_K(TSObj.G(TSObj.order,i),TSObj.G(TSObj.order,j),xy,TSObj.lambda,TSObj.mu,pfix);
    end
  end
  
  begin=(2*nNodes)*(2*nbStep-2+jump)+2*nbStep-1+jump;

  column=[begin*ones(1,4)+[0,1,2,3],(begin+2*TSObj.NN)*ones(1,4)+[0,1,2,3]];

  step=(2*nNodes)*ones(1,8);
  II=[column,column+step,column+2*step,column+3*step];
  I=[II,II+2*TSObj.NN*(2*nNodes)*ones(1,32)];
  AA(I)=AA(I)+KK;
end    % of element loop

A0=reshape(AA,2*nNodes,2*nNodes);


