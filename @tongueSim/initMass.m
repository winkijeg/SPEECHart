function  initMass( TSObj )
%INITMASS Summary of this function goes here
% Calcul de la matrice de Masse (dim 2*NN*MM par 2*NN*MM) : la masse
% associee a chaque noeud est proportionnelle a l'aire des elements qui
% entourent ce noeud.
% Compute the matrix of mass (dim 2*NN*MM by 2*NN*MM) : the mass associated
% to each node is proportional to the area of the elements sorrounding the
% node.
disp('Calcul de la matrice masse');
% Calcul de l'aire de chaque element
% Compute each element's area
aire_element = zeros(TSObj.MM-1, TSObj.NN-1);
for i=1:TSObj.MM-1,
    for j=1:TSObj.NN-1,
        aire_element(i,j)=abs(( (TSObj.Y0(i+1,j)+TSObj.Y0(i,j))*...
            (TSObj.X0(i+1,j)-TSObj.X0(i,j)) + (TSObj.Y0(i+1,j+1)+...
            TSObj.Y0(i+1,j))*(TSObj.X0(i+1,j+1)-TSObj.X0(i+1,j)) + ...
            (TSObj.Y0(i,j+1)+TSObj.Y0(i+1,j+1))*(TSObj.X0(i,j+1)-...
            TSObj.X0(i+1,j+1)) + (TSObj.Y0(i,j)+TSObj.Y0(i,j+1))*...
            (TSObj.X0(i,j)-TSObj.X0(i,j+1))) / 2.0);
    end
end
aire_totale = sum(aire_element(:)); % sum of all areas

% Calcul de la masse / compute the mass
TSObj.Mass=eye(2*NN*MM);
masse_totale=0.15/35;      % <=> 150 grammes sur 40 mm de large
                           % <=> 150 grams per 40 mm width
                           % possibly 35 mm??
for i=1:TSObj.MM
    for j=1:TSObj.NN
        k=(i-1)*2*TSObj.NN+2*j;
        if (k==2)                  % coin bas gauche / lower left corner
            aire=aire_element(1,1)/4;
        elseif (k==2*(TSObj.MM*TSObj.NN-TSObj.NN+1)) % coin haut gauche / upper left corner
            aire=aire_element(TSObj.MM-1,1)/4;
        elseif (k==2*TSObj.NN)           % coin bas droit / lower right cor
            aire=aire_element(1,TSObj.NN-1)/4;
        elseif (k==2*TSObj.NN*TSObj.MM)        % coin haut droit / upper right corner
            aire=aire_element(TSObj.MM-1,TSObj.NN-1)/4;
        elseif (i==1)              % bords bas / lower edge
            aire=aire_element(1,j-1)/4+aire_element(1,j)/4;
        elseif (j==1)              % bord gauche / left edge
            aire=aire_element(i-1,1)/4+aire_element(i,1)/4;
        elseif (i==TSObj.MM)             % bord haut / upper edge
            aire=aire_element(TSObj.MM-1,j-1)/4+aire_element(TSObj.MM-1,j)/4;
        elseif (j==TSObj.NN)             % bord droit / right edge
            aire=aire_element(i,TSObj.NN-1)/4+aire_element(i-1,TSObj.NN-1)/4;
        else                       % tous les autres noeuds / all the oether nodes
            aire=aire_element(i-1,j-1)/4+aire_element(i,j-1)/4+...
                aire_element(i-1,j)/4+aire_element(i,j)/4;
        end
        TSObj.Mass(k,k)=TSObj.Mass(k,k)*masse_totale/aire_totale*aire;
        TSObj.Mass(k-1,k-1)=TSObj.Mass(k,k);
    end
end

% Pour accelerer les calculs, on prend tout de suite l'inverse de
% cette matrice :
% To accelerate computation, get the inverse of this matrix :
TSObj.invMass=inv(TSObj.Mass);


end

