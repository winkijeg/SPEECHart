function elast2 = elast2(activGGA, activGGP, activHyo, activStylo, ...
    activSL, activVert, ncontact)
% Calcule la matrice d'elasticite A0 en fonction des activites des
% differents muscles : E vaut 15 kPa pour un element au repos et 250
% kPa pour un element contracte au maximum.
% Ceci correspond a multiplier lambda et mu jusqu'a 16 fois leurs
% valeurs initiales.

% Parametres d'entree :
% -  Les activation des muscles
% -  ncontact qui est un vecteur contenant 0 et les indices des noeuds qui
%    entrent en contact avec le palais : les coefficients de la
%    matrice d'elasticite dependent en effet des points fixes de
%    l'element considere.

global X0Y0
global NN
global MM
global lambda
global mu
global ordre
global IA
global IB
global IC
global ID
global IE

fact = 2; % to be removed after compilation of elast_c.c without fact

%AA = zeros(1,(2*NN*MM)^2);

activtot = [activGGA, activGGP, activHyo, activStylo, activSL, activVert];
AA = elast_c(NN, MM, fact, ordre, lambda, mu, IA, IB, IC, ID, IE, ...
    activtot, X0Y0, ncontact);

elast2 = reshape(AA, 2*NN*MM, 2*NN*MM);

end
