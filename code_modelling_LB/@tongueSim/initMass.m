function  initMass( TSObj )
%INITMASS Summary of this function goes here
% Compute the matrix of mass (dim 2*NN*MM by 2*NN*MM) : the mass associated
% to each node is proportional to the area of the elements sorrounding the
% node.
disp('Calculating the mass matrix.');
% Calcul de l'aire de chaque element
% Compute each element's area
aire_element = zeros(TSObj.restpos.MM-1, TSObj.restpos.NN-1);
for i=1:TSObj.restpos.MM-1,
    for j=1:TSObj.restpos.NN-1,
        aire_element(i,j)=abs(( (TSObj.restpos.Y0(i+1,j)+TSObj.restpos.Y0(i,j))*...
            (TSObj.restpos.X0(i+1,j)-TSObj.restpos.X0(i,j)) + (TSObj.restpos.Y0(i+1,j+1)+...
            TSObj.restpos.Y0(i+1,j))*(TSObj.restpos.X0(i+1,j+1)-TSObj.restpos.X0(i+1,j)) + ...
            (TSObj.restpos.Y0(i,j+1)+TSObj.restpos.Y0(i+1,j+1))*(TSObj.restpos.X0(i,j+1)-...
            TSObj.restpos.X0(i+1,j+1)) + (TSObj.restpos.Y0(i,j)+TSObj.restpos.Y0(i,j+1))*...
            (TSObj.restpos.X0(i,j)-TSObj.restpos.X0(i,j+1))) / 2.0);
    end
end
aire_totale = sum(aire_element(:)); % sum of all areas

% Calcul de la masse / compute the mass
TSObj.Mass=eye(2*TSObj.restpos.NN*TSObj.restpos.MM);
masse_totale=0.15/35;      % <=> 150 grammes sur 40 mm de large
                           % <=> 150 grams per 40 mm width
                           % possibly 35 mm??
for i=1:TSObj.restpos.MM
    for j=1:TSObj.restpos.NN
        k=(i-1)*2*TSObj.restpos.NN+2*j;
        if (k==2)                  % coin bas gauche / lower left corner
            aire=aire_element(1,1)/4;
        elseif (k==2*(TSObj.restpos.MM*TSObj.restpos.NN-TSObj.restpos.NN+1)) % coin haut gauche / upper left corner
            aire=aire_element(TSObj.restpos.MM-1,1)/4;
        elseif (k==2*TSObj.restpos.NN)           % coin bas droit / lower right cor
            aire=aire_element(1,TSObj.restpos.NN-1)/4;
        elseif (k==2*TSObj.restpos.NN*TSObj.restpos.MM)        % coin haut droit / upper right corner
            aire=aire_element(TSObj.restpos.MM-1,TSObj.restpos.NN-1)/4;
        elseif (i==1)              % bords bas / lower edge
            aire=aire_element(1,j-1)/4+aire_element(1,j)/4;
        elseif (j==1)              % bord gauche / left edge
            aire=aire_element(i-1,1)/4+aire_element(i,1)/4;
        elseif (i==TSObj.restpos.MM)             % bord haut / upper edge
            aire=aire_element(TSObj.restpos.MM-1,j-1)/4+aire_element(TSObj.restpos.MM-1,j)/4;
        elseif (j==TSObj.restpos.NN)             % bord droit / right edge
            aire=aire_element(i,TSObj.restpos.NN-1)/4+aire_element(i-1,TSObj.restpos.NN-1)/4;
        else                       % tous les autres noeuds / all the oether nodes
            aire=aire_element(i-1,j-1)/4+aire_element(i,j-1)/4+...
                aire_element(i-1,j)/4+aire_element(i,j)/4;
        end
        TSObj.Mass(k,k)=TSObj.Mass(k,k)*masse_totale/aire_totale*aire;
        TSObj.Mass(k-1,k-1)=TSObj.Mass(k,k);
    end
end

% To accelerate computation, get the inverse of this matrix :
TSObj.invMass=inv(TSObj.Mass);

end

