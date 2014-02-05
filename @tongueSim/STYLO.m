function STYLO(TSObj, U);
% STYLO.m
% Calculs des forces exercees par le Styloglossus (Stylo)
% Il y a 2 fibres

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% % -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global fact;                    % Resolution du modele               |
% global TSObj.Att.Stylo1;               % Points d'attache du Stylo          |
% global TSObj.cont.XS TSObj.cont.YS;                   % Idem, hors langue                  |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.Stylo1 TSObj.MU;        % Pour calculer l'activation du Stylo|
% global TSObj.Lambda.Stylo2;           % Idem                               |
% global TSObj.rho.Stylo TSObj.c              % Pour calculer la force du Stylo    |
% global TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5;          % Idem                               |
% global TSObj.restpos.restLength_Stylo;         % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout TSObj.ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global TSObj.ACTIV_T;                 % Activation des TSObj.muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.Stylo1 TSObj.Force.Stylo2; % Force exercee par chaque fibre     |
% % -------------------------------------------------------------------+

% Premiere fibre Stylo
  long=sqrt((TSObj.XY(TSObj.Att.Stylo1(1,2)-1)-TSObj.cont.XS)^2+(TSObj.XY(TSObj.Att.Stylo1(1,2))-TSObj.cont.YS)^2);
  LongdotStylo1=((TSObj.XY(TSObj.Att.Stylo1(1,2)-1)-TSObj.cont.XS)*U(TSObj.NNxMMx2+TSObj.Att.Stylo1(1,2)-1)+(TSObj.XY(TSObj.Att.Stylo1(1,2))-TSObj.cont.YS)*U(TSObj.NNxMMx2+TSObj.Att.Stylo1(1,2)))/long;
  Activ1=(long-TSObj.Lambda.Stylo1+TSObj.MU*LongdotStylo1);
  if Activ1>0
    TSObj.Force.Stylo1=TSObj.rho.Stylo*(exp(TSObj.c*Activ1)-1);
    TSObj.Force.Stylo1=TSObj.Force.Stylo1*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotStylo1/TSObj.restpos.restLength_Stylo(1))+TSObj.f5*LongdotStylo1/TSObj.restpos.restLength_Stylo(1));
    if TSObj.Force.Stylo1>20
      TSObj.Force.Stylo1=20;
    end
    TSObj.FXY(TSObj.Att.Stylo1(1,2)-1)=TSObj.FXY(TSObj.Att.Stylo1(1,2)-1)-(TSObj.XY(TSObj.Att.Stylo1(1,2)-1)-TSObj.cont.XS)/long*TSObj.Force.Stylo1;
    TSObj.FXY(TSObj.Att.Stylo1(1,2))=TSObj.FXY(TSObj.Att.Stylo1(1,2))-(TSObj.XY(TSObj.Att.Stylo1(1,2))-TSObj.cont.YS)/long*TSObj.Force.Stylo1;
  else
    TSObj.Force.Stylo1=0;
  end
TSObj.ACTIV_T(TSObj.t_i, 3) = Activ1;
  
  % Seconde fibre Stylo
  long1=sqrt((TSObj.XY(TSObj.Att.Stylo1(2,2)-1)-TSObj.XY(TSObj.Att.Stylo1(3,2)-1))^2+(TSObj.XY(TSObj.Att.Stylo1(2,2))-TSObj.XY(TSObj.Att.Stylo1(3,2)))^2);
  long2=sqrt((TSObj.XY(TSObj.Att.Stylo1(3,2)-1)-TSObj.cont.XS)^2+(TSObj.XY(TSObj.Att.Stylo1(3,2))-TSObj.cont.YS)^2);
  long=long1+long2;
  LongdotStylo2=((TSObj.XY(TSObj.Att.Stylo1(2,2)-1)-TSObj.cont.XS)*U(TSObj.NNxMMx2+TSObj.Att.Stylo1(2,2)-1)+(TSObj.XY(TSObj.Att.Stylo1(2,2))-TSObj.cont.YS)*U(TSObj.NNxMMx2+TSObj.Att.Stylo1(2,2)))/long;
  Activ1=(long-TSObj.Lambda.Stylo2+TSObj.MU*LongdotStylo2);
  if Activ1>0
    TSObj.Force.Stylo2=TSObj.rho.Stylo*(exp(TSObj.c*Activ1)-1);
    TSObj.Force.Stylo2=TSObj.Force.Stylo2*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotStylo2/TSObj.restpos.restLength_Stylo(2))+TSObj.f5*LongdotStylo2/TSObj.restpos.restLength_Stylo(2));
    if TSObj.Force.Stylo2>20
      TSObj.Force.Stylo2=20;   
    end
    TSObj.FXY(TSObj.Att.Stylo1(2,2)-1)=TSObj.FXY(TSObj.Att.Stylo1(2,2)-1)-(TSObj.XY(TSObj.Att.Stylo1(2,2)-1)-TSObj.XY(TSObj.Att.Stylo1(3,2)-1))/long1*TSObj.Force.Stylo2;
    TSObj.FXY(TSObj.Att.Stylo1(2,2))=TSObj.FXY(TSObj.Att.Stylo1(2,2))-(TSObj.XY(TSObj.Att.Stylo1(2,2))-TSObj.XY(TSObj.Att.Stylo1(3,2)))/long1*TSObj.Force.Stylo2;
    
    TSObj.FXY(TSObj.Att.Stylo1(3,2)-1)=TSObj.FXY(TSObj.Att.Stylo1(3,2)-1)-(TSObj.XY(TSObj.Att.Stylo1(3,2)-1)-TSObj.XY(TSObj.Att.Stylo1(2,2)-1))/long1*TSObj.Force.Stylo2;
    TSObj.FXY(TSObj.Att.Stylo1(3,2))=TSObj.FXY(TSObj.Att.Stylo1(3,2))-(TSObj.XY(TSObj.Att.Stylo1(3,2))-TSObj.XY(TSObj.Att.Stylo1(2,2)))/long1*TSObj.Force.Stylo2;
    
    TSObj.FXY(TSObj.Att.Stylo1(3,2)-1)=TSObj.FXY(TSObj.Att.Stylo1(3,2)-1)-(TSObj.XY(TSObj.Att.Stylo1(3,2)-1)-TSObj.cont.XS)/long2*TSObj.Force.Stylo2;
    TSObj.FXY(TSObj.Att.Stylo1(3,2))=TSObj.FXY(TSObj.Att.Stylo1(3,2))-(TSObj.XY(TSObj.Att.Stylo1(3,2))-TSObj.cont.YS)/long2*TSObj.Force.Stylo2;
  else 
    TSObj.Force.Stylo2=0;
  end
