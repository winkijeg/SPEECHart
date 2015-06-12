function GGA(U)
% Calculs des forces exercees par le Ant. Genoiglossus (GGA) (6 fibres)

% Variables globales d'entree
global NNxMMx2                  % Offset de U' dans U  
global Att_GGA                  % Points d'attache du GGA
global XY                       % Position des noeuds
global LAMBDA_GGA MU            % Pour calculer l'activation du GGA
global rho_GG c f1 f2 f3 f4 f5  % Pour calculer la force du GGA
global longrepos_GGA            % Idem
global t_i                      % 'Temps entier' pout ACTIV_T

% Variables globales d'entree/sortie
global FXY                      % Force exercee en chaque noeud
global ACTIV_T                  % Activation des muscles

% Variables globales de sortie 
global ForceGGA                 % Force exercee par chaque fibre


for k = 1:6
    longtot = 0;
    for j = Att_GGA(k,2):-1:Att_GGA(k,1)+1
        v1 = 2*j;
        long(j) = sqrt((XY(v1-1)-XY(v1-3))^2+(XY(v1)-XY(v1-2))^2);
        longtot = longtot + long(j);
    end
    LongdotGGA(k) = ((XY(Att_GGA(k,4)-1)-XY(Att_GGA(k,3)-1))*U(NNxMMx2+Att_GGA(k,4)-1)+(XY(Att_GGA(k,4))-XY(Att_GGA(k,3)))*U(NNxMMx2+Att_GGA(k,4)))/longtot;
    % Calcul de l'activite musculaire
    Activ1=(longtot-LAMBDA_GGA(k)+MU*LongdotGGA(k));
    % Calcul de la force F de l'equa diff
    if Activ1>0
        ForceGGA(k)=rho_GG*(exp(c*Activ1)-1);
        ForceGGA(k)=ForceGGA(k)*(f1+f2*atan(f3+f4*LongdotGGA(k)/longrepos_GGA(k))+f5*LongdotGGA(k)/longrepos_GGA(k));
        % Saturation de la force
        if ForceGGA(k)>20
            ForceGGA(k)=20;
        end
        if (k == 1)
            ForceGGA(k)= ForceGGA(k)/2;
        end
        
        % Calcul de la force FXY appliquee aux noeuds
        FXY(Att_GGA(k,4)-1)=FXY(Att_GGA(k,4)-1)-(XY(Att_GGA(k,4)-1)-XY(Att_GGA(k,4)-3))/long(Att_GGA(k,2))*ForceGGA(k);
        FXY(Att_GGA(k,4))=FXY(Att_GGA(k,4))-(XY(Att_GGA(k,4))-XY(Att_GGA(k,4)-2))/long(Att_GGA(k,2))*ForceGGA(k);
        for j=Att_GGA(k,2)-1:-1:Att_GGA(k,1)+1
            v1=2*j; % %%
            FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1+1))/long(j+1)*ForceGGA(k);
            FXY(v1)=FXY(v1)-(XY(v1)-XY(v1+2))/long(j+1)*ForceGGA(k);
            FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1-3))/long(j)*ForceGGA(k);
            FXY(v1)=FXY(v1)-(XY(v1)-XY(v1-2))/long(j)*ForceGGA(k);
            % Il serait bien vu de faire un  regroupement des 2 lignes...
        end
    else
        ForceGGA(k)=0;
    end
end

ACTIV_T(t_i, 2) = Activ1;

end


