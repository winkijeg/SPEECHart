function GGP(U)
% calculate the forces exercised by the GGP (7 fibres)

% NN-1 lengths match the total length of the fiber divided by the length 
% of each of the NN-1 elements that it crosses.
% longtot is the total length of the fiber.

% Variables globales d'entree
global NNxMMx2                 % Offset de U' dans U
global Att_GGP                 % Points d'attache du GGP
global XY                      % Position des noeuds
global LAMBDA_GGP MU           % Pour calculer l'activation du GGP
global rho_GG c f1 f2 f3 f4 f5 % Pour calculer la force du GGP
global longrepos_GGP           % Idem
global t_i                     % 'Temps entier' pout ACTIV_T

% Variables globales d'entree/sortie
global FXY                     % Force exercee en chaque noeud
global ACTIV_T                 % Activation des muscles

% Variables globales de sortie
global ForceGGP                % Force exercee par chaque fibre

for k = 1:7
    
    longtot = 0;
    for j = Att_GGP(k,2):-1:Att_GGP(k,1)+1
        v1 = 2*j;
        long(j) = sqrt((XY(v1-1)-XY(v1-3))^2+(XY(v1)-XY(v1-2))^2);
        longtot = longtot + long(j);
    end
    
    LongdotGGP(k) = ((XY(Att_GGP(k,4)-1)-XY(Att_GGP(k,3)-1))*U(NNxMMx2+Att_GGP(k,4)-1)+(XY(Att_GGP(k,4))-XY(Att_GGP(k,3)))*U(NNxMMx2+Att_GGP(k,4)))/longtot;
    
    % calculate muscle activity
    Activ1 = (longtot - LAMBDA_GGP(k) + MU*LongdotGGP(k));
    
    % calculate force F of the differential equantion
    if (Activ1 > 0)
        ForceGGP(k) = rho_GG * (exp(c*Activ1)-1);
        ForceGGP(k) = ForceGGP(k) * ...
            (f1+f2*atan(f3+f4*LongdotGGP(k)/longrepos_GGP(k))+f5*LongdotGGP(k)/longrepos_GGP(k));
        
        % saturation of force
        if ForceGGP(k) > 20
            ForceGGP(k) = 20;
        end
        
        if (k == 7)
            ForceGGP(k) = ForceGGP(k) / 2;
        end
        
        % calculate force FXY applied to the nodes
        FXY(Att_GGP(k,4)-1) = FXY(Att_GGP(k,4)-1)-(XY(Att_GGP(k,4)-1)-XY(Att_GGP(k,4)-3))/long(Att_GGP(k,2))*ForceGGP(k);
        FXY(Att_GGP(k,4)) = FXY(Att_GGP(k,4))-(XY(Att_GGP(k,4))-XY(Att_GGP(k,4)-2))/long(Att_GGP(k,2))*ForceGGP(k);
        for j = Att_GGP(k,2)-1:-1:Att_GGP(k,1)+1
            v1 = 2*j; 
            FXY(v1-1) = FXY(v1-1)-(XY(v1-1)-XY(v1+1))/long(j+1)*ForceGGP(k);
            FXY(v1) = FXY(v1)-(XY(v1)-XY(v1+2))/long(j+1)*ForceGGP(k);
            FXY(v1-1) = FXY(v1-1)-(XY(v1-1)-XY(v1-3))/long(j)*ForceGGP(k);
            FXY(v1) = FXY(v1)-(XY(v1)-XY(v1-2))/long(j)*ForceGGP(k);
        end
    else
        ForceGGP(k) = 0;
    end
end

ACTIV_T(t_i,1) = Activ1;

end
