function SL(U)
% Calculs des forces exercees par le Superior Longitudinalis (SL) (1 fibre)

% Variables globales d'entree                                        |
global NN NNx2;                 % Largeur du modele                  |
global NNxMMx2;                 % Offset de U' dans U                |
global Att_SL;                  % Points d'attache du SL             |
global XY;                      % Position des noeuds                |
global LAMBDA_SL MU;            % Pour calculer l'activation du SL   |
global rho_SL c f1 f2 f3 f4 f5; % Pour calculer la force du SL       |
global longrepos_SL;            % Idem                               |
global t_i;                     % 'Temps entier' pout ACTIV_T        |

% Variables globales d'entree/sortie                                 |
global FXY;                     % Force exercee en chaque noeud      |
global ACTIV_T;                 % Activation des muscles             |

% Variables globales de sortie                                       |
global ForceSL;                 % Force exercee par chaque fibre     |

%Att_SL
for k = 1:2
    long_SL(k) = 0;
    for j=Att_SL(k,1)+NN:NN:Att_SL(k,2) % Modifs YP-PP Dec 99
        v1=2*j; % %%
        long(j)=sqrt((XY(v1-1)-XY(v1-NNx2-1))^2+(XY(v1)-XY(v1-NNx2))^2);
        long_SL(k)=long_SL(k)+long(j);  % Modifs YP-PP Dec 99
    end
    LongdotSL(k)=((XY(Att_SL(k,4)-1)-XY(Att_SL(k,3)-1))*U(NNxMMx2+Att_SL(k,4)-1)+(XY(Att_SL(k,4))-XY(Att_SL(k,3)))*U(NNxMMx2+Att_SL(k,4)))/long_SL(k);
    Activ1=(long_SL(k)-LAMBDA_SL+MU*LongdotSL(k));
    if Activ1>0
        ForceSL = rho_SL * (exp(c*Activ1)-1);
        ForceSL = ForceSL * (f1+f2*atan(f3+f4*LongdotSL(k)/longrepos_SL(k))+f5*LongdotSL(k)/longrepos_SL(k));
        if ForceSL > 20
            ForceSL = 20;
        end
        for j = Att_SL(k,1)+NN:NN:Att_SL(k,2)-NN
            v1 = 2*j; % %%
            FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1+NNx2-1))/long(j+NN)*ForceSL;
            FXY(v1)=FXY(v1)-(XY(v1)-XY(v1+NNx2))/long(j+NN)*ForceSL;
            FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1-NNx2-1))/long(j)*ForceSL;
            FXY(v1)=FXY(v1)-(XY(v1)-XY(v1-NNx2))/long(j)*ForceSL;
        end
        FXY(Att_SL(k,4)-1)=FXY(Att_SL(k,4)-1)-(XY(Att_SL(k,4)-1)-XY(Att_SL(k,4)-NNx2-1))/long(Att_SL(k,2))*ForceSL;
        FXY(Att_SL(k,4))=FXY(Att_SL(k,4))-(XY(Att_SL(k,4))-XY(Att_SL(k,4)-NNx2))/long(Att_SL(k,2))*ForceSL;
        % Modif Mars 2004 PP.
        %On applique aussi une force sur l'origine du muscle dans la
        %langue (noeuds 65=Att_SL(1,1) et 64 = tt_SL(2,1)), qui
        %correspondent dans la matrice FXY aux positions
        %(2*65-1)=Att_SL(1,3)-1 et (2*64-1)=Att_SL(2,3)-1 pour la force en x
        % et aux positions
        %(2*65)=Att_SL(1,3) et (2*64)=Att_SL(2,3) pour la force en y
        % force en X
        FXY(Att_SL(k,3)-1) = FXY(Att_SL(k,3)-1)-(XY(Att_SL(k,3)-1)-XY(Att_SL(k,3)+NNx2-1))/long(Att_SL(k,1)+NN)*ForceSL;
        % force en Y
        FXY(Att_SL(k,3)) = FXY(Att_SL(k,3))-(XY(Att_SL(k,3))-XY(Att_SL(k,3)+NNx2))/long(Att_SL(k,1)+NN)*ForceSL;
        
    else
        ForceSL = 0;
    end
    
    ACTIV_T(t_i, 5) = Activ1;
end

end
