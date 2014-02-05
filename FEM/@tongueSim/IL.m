function IL(TSObj, U);
% IL.m
% Calculs des forces exercees par l'Inferior Longitudinalis (IL)
% Il y a 1 fibre

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% % -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global fact;                    % Resolution du modele               |
% global TSObj.Att.IL;                  % Points d'attache du IL             |
% global TSObj.cont.X2 TSObj.cont.Y2;                   % Idem, hors langue                  |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.IL TSObj.MU;            % Pour calculer l'activation du IL   |
% global TSObj.rho.IL TSObj.c TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5; % Pour calculer la force du IL       |
% global TSObj.restpos.restLength_IL;            % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout TSObj.ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global TSObj.ACTIV_T;                 % Activation des muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.IL;                 % Force exercee par chaque fibre     |
% % -------------------------------------------------------------------+


long1=sqrt((TSObj.XY(TSObj.Att.IL(1,2)-1)-TSObj.cont.X2)^2+(TSObj.XY(TSObj.Att.IL(1,2))-TSObj.cont.Y2)^2);
long2=sqrt((TSObj.XY(TSObj.Att.IL(2,2)-1)-TSObj.XY(TSObj.Att.IL(1,2)-1))^2+(TSObj.XY(TSObj.Att.IL(2,2))-TSObj.XY(TSObj.Att.IL(1,2)))^2);
long3=sqrt((TSObj.XY(TSObj.Att.IL(3,2)-1)-TSObj.XY(TSObj.Att.IL(2,2)-1))^2+(TSObj.XY(TSObj.Att.IL(3,2))-TSObj.XY(TSObj.Att.IL(2,2)))^2);
long_IL=long1+long2+long3;
LongdotIL=((TSObj.XY(TSObj.Att.IL(3,2)-1)-TSObj.cont.X2)*U(TSObj.NNxMMx2+TSObj.Att.IL(3,2)-1)+(TSObj.XY(TSObj.Att.IL(3,2))-TSObj.cont.Y2)*U(TSObj.NNxMMx2+TSObj.Att.IL(3,2)))/long_IL;
Activ1=(long_IL-TSObj.Lambda.IL+TSObj.MU*LongdotIL);
if Activ1>0
  TSObj.Force.IL=TSObj.rho.IL*(exp(TSObj.c*Activ1)-1);
  TSObj.Force.IL=TSObj.Force.IL*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotIL/TSObj.restpos.restLength_IL)+TSObj.f5*LongdotIL/TSObj.restpos.restLength_IL);
  if TSObj.Force.IL>20
    TSObj.Force.IL=20;
  end
  TSObj.FXY(TSObj.Att.IL(1,2)-1)=TSObj.FXY(TSObj.Att.IL(1,2)-1)-(TSObj.XY(TSObj.Att.IL(1,2)-1)-TSObj.cont.X2)/long1*TSObj.Force.IL;
  TSObj.FXY(TSObj.Att.IL(1,2))=TSObj.FXY(TSObj.Att.IL(1,2))-(TSObj.XY(TSObj.Att.IL(1,2))-TSObj.cont.Y2)/long1*TSObj.Force.IL;

  TSObj.FXY(TSObj.Att.IL(1,2)-1)=TSObj.FXY(TSObj.Att.IL(1,2)-1)-(TSObj.XY(TSObj.Att.IL(1,2)-1)-TSObj.XY(TSObj.Att.IL(2,2)-1))/long2*TSObj.Force.IL;
  TSObj.FXY(TSObj.Att.IL(1,2))=TSObj.FXY(TSObj.Att.IL(1,2))-(TSObj.XY(TSObj.Att.IL(1,2))-TSObj.XY(TSObj.Att.IL(2,2)))/long2*TSObj.Force.IL;
  
  TSObj.FXY(TSObj.Att.IL(2,2)-1)=TSObj.FXY(TSObj.Att.IL(2,2)-1)-(TSObj.XY(TSObj.Att.IL(2,2)-1)-TSObj.XY(TSObj.Att.IL(1,2)-1))/long2*TSObj.Force.IL;
  TSObj.FXY(TSObj.Att.IL(2,2))=TSObj.FXY(TSObj.Att.IL(2,2))-(TSObj.XY(TSObj.Att.IL(2,2))-TSObj.XY(TSObj.Att.IL(1,2)))/long2*TSObj.Force.IL;
  
  TSObj.FXY(TSObj.Att.IL(3,2)-1)=TSObj.FXY(TSObj.Att.IL(3,2)-1)-(TSObj.XY(TSObj.Att.IL(3,2)-1)-TSObj.XY(TSObj.Att.IL(2,2)-1))/long3*TSObj.Force.IL;
  TSObj.FXY(TSObj.Att.IL(3,2))=TSObj.FXY(TSObj.Att.IL(3,2))-(TSObj.XY(TSObj.Att.IL(3,2))-TSObj.XY(TSObj.Att.IL(2,2)))/long3*TSObj.Force.IL;
else 
  TSObj.Force.IL=0;
end

TSObj.ACTIV_T(TSObj.t_i, 6) = Activ1;
