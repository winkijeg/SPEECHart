function elast2 = elast2(TSObj, activGGA, activGGP, activHyo, activStylo, ...
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

    % global TSObj.X0Y0
    % global TSObj.NN
    % global TSObj.MM
    % global TSObj.fact
    % global TSObj.lambda
    % global TSObj.mu
    % global TSObj.order
    % global TSObj.IA
    % global TSObj.IB
    % global TSObj.IC
    % global TSObj.ID
    % global TSObj.IE

    AA = zeros(1,(2*TSObj.NN*TSObj.MM)^2);

    activtot = [activGGA, activGGP, activHyo, activStylo, activSL, activVert];
    AA = elast_c(TSObj.NN, TSObj.MM, TSObj.fact, TSObj.order, TSObj.lambda, TSObj.mu, TSObj.IA, TSObj.IB, TSObj.IC, TSObj.ID, TSObj.IE, ...
        activtot, TSObj.X0Y0, ncontact);
    
    elast2 = reshape(AA, 2*TSObj.NN*TSObj.MM, 2*TSObj.NN*TSObj.MM);
    
end
