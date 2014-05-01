function IL(U);
% IL.m
% Calculs des forces exercees par l'Inferior Longitudinalis (IL)
% Il y a 1 fibre

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% -------------------------------------------------------------------+
% Variables globales d'entree                                        |
global NNxMMx2;                 % Offset de U' dans U                |
global fact;                    % Resolution du modele               |
global Att_IL;                  % Points d'attache du IL             |
global X2 Y2;                   % Idem, hors langue                  |
global XY;                      % Position des noeuds                |
global LAMBDA_IL MU;            % Pour calculer l'activation du IL   |
global rho_IL c f1 f2 f3 f4 f5; % Pour calculer la force du IL       |
global longrepos_IL;            % Idem                               |
global t_i;                     % 'Temps entier' pout ACTIV_T        |
% -------------------------------------------------------------------+
% Variables globales d'entree/sortie                                 |
global FXY;                     % Force exercee en chaque noeud      |
global ACTIV_T;                 % Activation des muscles             |
% -------------------------------------------------------------------+
% Variables globales de sortie                                       |
global ForceIL;                 % Force exercee par chaque fibre     |
% -------------------------------------------------------------------+


long1=sqrt((XY(Att_IL(1,2)-1)-X2)^2+(XY(Att_IL(1,2))-Y2)^2);
long2=sqrt((XY(Att_IL(2,2)-1)-XY(Att_IL(1,2)-1))^2+(XY(Att_IL(2,2))-XY(Att_IL(1,2)))^2);
long3=sqrt((XY(Att_IL(3,2)-1)-XY(Att_IL(2,2)-1))^2+(XY(Att_IL(3,2))-XY(Att_IL(2,2)))^2);
long_IL=long1+long2+long3;
LongdotIL=((XY(Att_IL(3,2)-1)-X2)*U(NNxMMx2+Att_IL(3,2)-1)+(XY(Att_IL(3,2))-Y2)*U(NNxMMx2+Att_IL(3,2)))/long_IL;
Activ1=(long_IL-LAMBDA_IL+MU*LongdotIL);
if Activ1>0
  ForceIL=rho_IL*(exp(c*Activ1)-1);
  ForceIL=ForceIL*(f1+f2*atan(f3+f4*LongdotIL/longrepos_IL)+f5*LongdotIL/longrepos_IL);
  if ForceIL>20
    ForceIL=20;
  end
  FXY(Att_IL(1,2)-1)=FXY(Att_IL(1,2)-1)-(XY(Att_IL(1,2)-1)-X2)/long1*ForceIL;
  FXY(Att_IL(1,2))=FXY(Att_IL(1,2))-(XY(Att_IL(1,2))-Y2)/long1*ForceIL;

  FXY(Att_IL(1,2)-1)=FXY(Att_IL(1,2)-1)-(XY(Att_IL(1,2)-1)-XY(Att_IL(2,2)-1))/long2*ForceIL;
  FXY(Att_IL(1,2))=FXY(Att_IL(1,2))-(XY(Att_IL(1,2))-XY(Att_IL(2,2)))/long2*ForceIL;
  
  FXY(Att_IL(2,2)-1)=FXY(Att_IL(2,2)-1)-(XY(Att_IL(2,2)-1)-XY(Att_IL(1,2)-1))/long2*ForceIL;
  FXY(Att_IL(2,2))=FXY(Att_IL(2,2))-(XY(Att_IL(2,2))-XY(Att_IL(1,2)))/long2*ForceIL;
  
  FXY(Att_IL(3,2)-1)=FXY(Att_IL(3,2)-1)-(XY(Att_IL(3,2)-1)-XY(Att_IL(2,2)-1))/long3*ForceIL;
  FXY(Att_IL(3,2))=FXY(Att_IL(3,2))-(XY(Att_IL(3,2))-XY(Att_IL(2,2)))/long3*ForceIL;
else 
  ForceIL=0;
end

ACTIV_T(t_i, 6) = Activ1;
