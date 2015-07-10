function elast2 = elast2(activGGA, activGGP, activHyo, activStylo, ...
    activSL, activVert, ncontact)
% calculate elasticity matrix A0 after each muscle activity.
%   E is 15 kPa for an element in rest position and 250 kPa for an 
%   element with maximal contraction. This corresponds to a
%   multiplication of lambda and mu up to 16 times their initial values.
%
% Input parameters:
% -  muscle activations
% -  ncontact is a vector containing the indices 0 and nodes that come 
%    into contact with the palate: the coefficients of the elasticity 
%    matrix depend indeed on the fixed point of the element considered.

global X0Y0
global lambda
global mu
global ordre
global IA
global IB
global IC
global ID
global IE

nNodes = 221;

activtot = [activGGA, activGGP, activHyo, activStylo, activSL, activVert];
AA = elast_c(ordre, lambda, mu, IA, IB, IC, ID, IE, activtot, X0Y0, ncontact);

elast2 = reshape(AA, 2*nNodes, 2*nNodes);

end
