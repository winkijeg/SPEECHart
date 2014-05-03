function GGP(U)
% Calculs des forces exercees par le Post. Genioglossus (GGP) (7 fibres)

% Les NN-1 longueurs correspondent a la longueur totale de la fibre divisee
% par la longueur de chacun des NN-1 elements qu'elle traverse
% longtot est la longueur totale de la fibre
% longdotGGP(k) est la derivee temporelle de la longueur

% Variables globales d'entree                                        |
global NNxMMx2;                 % Offset de U' dans U                |
global Att_GGP;                 % Points d'attache du GGP            |
global XY;                      % Position des noeuds                |
global LAMBDA_GGP MU;           % Pour calculer l'activation du GGP  |
global rho_GG c f1 f2 f3 f4 f5; % Pour calculer la force du GGP      |
global longrepos_GGP;           % Idem                               |
global t_i;                     % 'Temps entier' pout ACTIV_T        |

% Variables globales d'entree/sortie                                 |
global FXY;                     % Force exercee en chaque noeud      |
global ACTIV_T;                 % Activation des muscles             |

% Variables globales de sortie                                       |
global ForceGGP;                % Force exercee par chaque fibre     |

for k = 1:7
    longtot = 0;
    for j = Att_GGP(k,2):-1:Att_GGP(k,1)+1
        v1 = 2*j; % %%
        long(j)=sqrt((XY(v1-1)-XY(v1-3))^2+(XY(v1)-XY(v1-2))^2);
        longtot=longtot+long(j);
    end
    LongdotGGP(k)=((XY(Att_GGP(k,4)-1)-XY(Att_GGP(k,3)-1))*U(NNxMMx2+Att_GGP(k,4)-1)+(XY(Att_GGP(k,4))-XY(Att_GGP(k,3)))*U(NNxMMx2+Att_GGP(k,4)))/longtot;
    % Calcul de l'activite musculaire
    Activ1=(longtot-LAMBDA_GGP(k)+MU*LongdotGGP(k));
    % Activ1=((longtot-LAMBDA_GGP(k))/fac_GGP(k)+MU*LongdotGGP(k)); %%% ESSAI
    
    % Calcul de la force F de l'equa diff
    if Activ1>0
        ForceGGP(k) = rho_GG * (exp(c*Activ1)-1);
        ForceGGP(k) = ForceGGP(k)*(f1+f2*atan(f3+f4*LongdotGGP(k)/longrepos_GGP(k))+f5*LongdotGGP(k)/longrepos_GGP(k));
        
        % Saturation de la force
        if ForceGGP(k) > 20
            
            ForceGGP(k) = 20;
            
        end
        
        if (k == 7)
            
            ForceGGP(k) = ForceGGP(k) / 2;
            
        end
        
        % Calcul de la force FXY appliquee aux noeuds
        FXY(Att_GGP(k,4)-1)=FXY(Att_GGP(k,4)-1)-(XY(Att_GGP(k,4)-1)-XY(Att_GGP(k,4)-3))/long(Att_GGP(k,2))*ForceGGP(k);
        FXY(Att_GGP(k,4))=FXY(Att_GGP(k,4))-(XY(Att_GGP(k,4))-XY(Att_GGP(k,4)-2))/long(Att_GGP(k,2))*ForceGGP(k);
        for j=Att_GGP(k,2)-1:-1:Att_GGP(k,1)+1
            v1=2*j; % %%
            FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1+1))/long(j+1)*ForceGGP(k);
            FXY(v1)=FXY(v1)-(XY(v1)-XY(v1+2))/long(j+1)*ForceGGP(k);
            FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1-3))/long(j)*ForceGGP(k);
            FXY(v1)=FXY(v1)-(XY(v1)-XY(v1-2))/long(j)*ForceGGP(k);
        end
    else
        ForceGGP(k)=0;
    end
end

ACTIV_T(t_i,1) = Activ1;

end
