function VERT(U);
% VERT.m
% Calculs des forces exercees par le Verticalis (Vert)
% Il y a (1+3*fact) fibres

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% -------------------------------------------------------------------+
% Variables globales d'entree                                        |
global NN;                      % Largeur du modele                  |
global NNxMMx2;                 % Offset de U' dans U                |
global fact;                    % Resolution du modele               |
global Att_Vert;                % Points d'attache du Vert           |
global XY;                      % Position des noeuds                |
global LAMBDA_Vert MU;          % Pour calculer l'activation du Vert |
global rho_Vert c;              % Pour calculer la force du Vert     |
global f1 f2 f3 f4 f5;          % Idem                               |
global longrepos_Vert;          % Idem                               |
global t_i;                     % 'Temps entier' pout ACTIV_T        |
% -------------------------------------------------------------------+
% Variables globales d'entree/sortie                                 |
global FXY;                     % Force exercee en chaque noeud      |
global ACTIV_T;                 % Activation des muscles             |
% -------------------------------------------------------------------+
% Variables globales de sortie                                       |
global ForceVert;                % Force exercee par chaque fibre    |
% -------------------------------------------------------------------+
global fac_Vert;

for k=1:3*fact     % boucle sur le nombre de fibres
                   % Modif Nov 99 YP-PP
  longtot=0;
  for j=Att_Vert(k,2):-1:Att_Vert(k,1)+1
    v1=2*j; % %%
    long(j)=sqrt((XY(v1-1)-XY(v1-3))^2+(XY(v1)-XY(v1-2))^2);
    longtot=longtot+long(j);
  end
  LongdotVert(k)=((XY(Att_Vert(k,4)-1)-XY(Att_Vert(k,3)-1))*U(NNxMMx2+Att_Vert(k,4)-1)+(XY(Att_Vert(k,4))-XY(Att_Vert(k,3)))*U(NNxMMx2+Att_Vert(k,4)))/longtot;
  Activ1=(longtot-LAMBDA_Vert(k)+MU*LongdotVert(k));
  if Activ1>0
    ForceVert(k)=rho_Vert*(exp(c*Activ1)-1);
    ForceVert(k)=ForceVert(k)*(f1+f2*atan(f3+f4*LongdotVert(k)/longrepos_Vert(k))+f5*LongdotVert(k)/longrepos_Vert(k));
    ForceVert(k)=ForceVert(k)/fac_Vert(k);
    if ForceVert(k)>20
      ForceVert(k)=20;
    end
    FXY(Att_Vert(k,4)-1)=FXY(Att_Vert(k,4)-1)-(XY(Att_Vert(k,4)-1)-XY(Att_Vert(k,4)-3))/long(Att_Vert(k,2))*ForceVert(k);
    FXY(Att_Vert(k,4))=FXY(Att_Vert(k,4))-(XY(Att_Vert(k,4))-XY(Att_Vert(k,4)-2))/long(Att_Vert(k,2))*ForceVert(k);
    FXY(Att_Vert(k,3)-1)=FXY(Att_Vert(k,3)-1)-(XY(Att_Vert(k,3)-1)-XY(Att_Vert(k,3)+1))/long(Att_Vert(k,1)+1)*ForceVert(k);
    FXY(Att_Vert(k,3))=FXY(Att_Vert(k,3))-(XY(Att_Vert(k,3))-XY(Att_Vert(k,3)+2))/long(Att_Vert(k,1)+1)*ForceVert(k);
    for j=Att_Vert(k,2)-1:-1:Att_Vert(k,1)+1
      v1=2*j; % %%
      FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1+1))/long(j+1)*ForceVert(k);
      FXY(v1)=FXY(v1)-(XY(v1)-XY(v1+2))/long(j+1)*ForceVert(k);
      FXY(v1-1)=FXY(v1-1)-(XY(v1-1)-XY(v1-3))/long(j)*ForceVert(k);
      FXY(v1)=FXY(v1)-(XY(v1)-XY(v1-2))/long(j)*ForceVert(k);
    end
  else 
    ForceVert(k)=0;
  end
end

ACTIV_T(t_i, 7) = Activ1;

