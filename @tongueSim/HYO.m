function HYO(TSObj, U);
% HYO.m
% Calculs des forces exercees par le Hyoglossus (Hyo)
% Il y a 3 fibres

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% % -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global fact;                    % Resolution du modele               |
% global TSObj.Att.Hyo1;                 % Points d'attache du Hyo            |
% global TSObj.cont.X1 TSObj.cont.Y1 TSObj.cont.X2 TSObj.cont.Y2 TSObj.cont.X3 TSObj.cont.Y3;       % Idem, hors langue                  |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.Hyo1 TSObj.Lambda.Hyo2; % Pour calculer l'activation du Hyo  |
% global TSObj.Lambda.Hyo3 TSObj.MU;          % Idem                               |
% global TSObj.rho.Hyo TSObj.c TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5;% Pour calculer la force du Hyo      |
% global TSObj.restpos.restLength_Hyo;           % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout TSObj.§ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global TSObj.ACTIV_T;                 % Activation des muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.Hyo1;                % Force exercee par chaque fibre     |
% % -------------------------------------------------------------------+
% % global fac_Hyo   %%% ESSAI

% Premiere fibre Hyo
long1=sqrt((TSObj.XY(TSObj.Att.Hyo1(1,2)-1)-TSObj.cont.X1)^2+(TSObj.XY(TSObj.Att.Hyo1(1,2))-TSObj.cont.Y1)^2);
long2=sqrt((TSObj.XY(TSObj.Att.Hyo1(2,2)-1)-TSObj.XY(TSObj.Att.Hyo1(1,2)-1))^2+(TSObj.XY(TSObj.Att.Hyo1(2,2))-TSObj.XY(TSObj.Att.Hyo1(1,2)))^2);
long_Hyo1=long1+long2;
LongdotHyo1=((TSObj.XY(TSObj.Att.Hyo1(2,2)-1)-TSObj.cont.X1)*U(TSObj.NNxMMx2+TSObj.Att.Hyo1(2,2)-1)+(TSObj.XY(TSObj.Att.Hyo1(2,2))-TSObj.cont.Y1)*U(TSObj.NNxMMx2+TSObj.Att.Hyo1(2,2)))/long_Hyo1;
 Activ1=(long_Hyo1-TSObj.Lambda.Hyo1+TSObj.MU*LongdotHyo1);
% Activ1=((long_Hyo1-TSObj.Lambda.Hyo1)/fac_Hyo(1)+TSObj.MU*LongdotHyo1); %%% ESSAI
if Activ1>0
  TSObj.Force.Hyo1(1)=TSObj.rho.Hyo*(exp(TSObj.c*Activ1)-1);
  TSObj.Force.Hyo1(1)=TSObj.Force.Hyo1(1)*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotHyo1/TSObj.restpos.restLength_Hyo(1))+TSObj.f5*LongdotHyo1/TSObj.restpos.restLength_Hyo(1));
  TSObj.Force.Hyo1(1)=TSObj.Force.Hyo1(1)/15.; % Modifs Dec 99 YP-PP On divise par 2 car la force de la premiere fibre est trop grande et la langue ne se deforme pas correctement.
  if TSObj.Force.Hyo1(1)>20
    TSObj.Force.Hyo1(1)=20;
  end
  TSObj.FXY(TSObj.Att.Hyo1(1,2)-1)=TSObj.FXY(TSObj.Att.Hyo1(1,2)-1)-(TSObj.XY(TSObj.Att.Hyo1(1,2)-1)-TSObj.cont.X1)/long1*TSObj.Force.Hyo1(1);
  TSObj.FXY(TSObj.Att.Hyo1(1,2))=TSObj.FXY(TSObj.Att.Hyo1(1,2))-(TSObj.XY(TSObj.Att.Hyo1(1,2))-TSObj.cont.Y1)/long1*TSObj.Force.Hyo1(1);
  
  TSObj.FXY(TSObj.Att.Hyo1(1,2)-1)=TSObj.FXY(TSObj.Att.Hyo1(1,2)-1)-(TSObj.XY(TSObj.Att.Hyo1(1,2)-1)-TSObj.XY(TSObj.Att.Hyo1(2,2)-1))/long2*TSObj.Force.Hyo1(1);
  TSObj.FXY(TSObj.Att.Hyo1(1,2))=TSObj.FXY(TSObj.Att.Hyo1(1,2))-(TSObj.XY(TSObj.Att.Hyo1(1,2))-TSObj.XY(TSObj.Att.Hyo1(2,2)))/long2*TSObj.Force.Hyo1(1);
  
  TSObj.FXY(TSObj.Att.Hyo1(2,2)-1)=TSObj.FXY(TSObj.Att.Hyo1(2,2)-1)-(TSObj.XY(TSObj.Att.Hyo1(2,2)-1)-TSObj.XY(TSObj.Att.Hyo1(1,2)-1))/long2*TSObj.Force.Hyo1(1);
  TSObj.FXY(TSObj.Att.Hyo1(2,2))=TSObj.FXY(TSObj.Att.Hyo1(2,2))-(TSObj.XY(TSObj.Att.Hyo1(2,2))-TSObj.XY(TSObj.Att.Hyo1(1,2)))/long2*TSObj.Force.Hyo1(1);
else 
  TSObj.Force.Hyo1(1)=0;
end

TSObj.ACTIV_T(TSObj.t_i, 4) = Activ1;

% Seconde fibre Hyo
long_Hyo2=sqrt((TSObj.XY(TSObj.Att.Hyo1(3,2)-1)-TSObj.cont.X2)^2+(TSObj.XY(TSObj.Att.Hyo1(3,2))-TSObj.cont.Y2)^2);
LongdotHyo2=((TSObj.XY(TSObj.Att.Hyo1(3,2)-1)-TSObj.cont.X2)*U(TSObj.NNxMMx2+TSObj.Att.Hyo1(3,2)-1)+(TSObj.XY(TSObj.Att.Hyo1(3,2))-TSObj.cont.Y2)*U(TSObj.NNxMMx2+TSObj.Att.Hyo1(3,2)))/long_Hyo2;
 Activ1=(long_Hyo2-TSObj.Lambda.Hyo2+TSObj.MU*LongdotHyo2);
% Activ1=((long_Hyo2-TSObj.Lambda.Hyo2)/fac_Hyo(2)+TSObj.MU*LongdotHyo2); %%% ESSAI
if Activ1>0
  TSObj.Force.Hyo1(2)=TSObj.rho.Hyo*(exp(TSObj.c*Activ1)-1);
  TSObj.Force.Hyo1(2)=TSObj.Force.Hyo1(2)*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotHyo2/TSObj.restpos.restLength_Hyo(2))+TSObj.f5*LongdotHyo2/TSObj.restpos.restLength_Hyo(2));
  TSObj.Force.Hyo1(2)=TSObj.Force.Hyo1(2)/3; % Modifs Dec 99 YP-PP On divise par 1.5 car la force de la deuxieme fibre est trop grande et la langue ne se deforme pas correctement.
  if TSObj.Force.Hyo1(2)>20
    TSObj.Force.Hyo1(2)=20;
  end
  TSObj.FXY(TSObj.Att.Hyo1(3,2)-1)=TSObj.FXY(TSObj.Att.Hyo1(3,2)-1)-(TSObj.XY(TSObj.Att.Hyo1(3,2)-1)-TSObj.cont.X2)/long_Hyo2*TSObj.Force.Hyo1(2);
  TSObj.FXY(TSObj.Att.Hyo1(3,2))=TSObj.FXY(TSObj.Att.Hyo1(3,2))-(TSObj.XY(TSObj.Att.Hyo1(3,2))-TSObj.cont.Y2)/long_Hyo2*TSObj.Force.Hyo1(2); 
else 
  TSObj.Force.Hyo1(2)=0;
end


% Troisieme fibre Hyo
long_Hyo3=sqrt((TSObj.XY(TSObj.Att.Hyo1(4,2)-1)-TSObj.cont.X3)^2+(TSObj.XY(TSObj.Att.Hyo1(4,2))-TSObj.cont.Y3)^2);
LongdotHyo3=((TSObj.XY(TSObj.Att.Hyo1(4,2)-1)-TSObj.cont.X3)*U(TSObj.NNxMMx2+TSObj.Att.Hyo1(4,2)-1)+(TSObj.XY(TSObj.Att.Hyo1(4,2))-TSObj.cont.Y3)*U(TSObj.NNxMMx2+TSObj.Att.Hyo1(4,2)))/long_Hyo3;
 Activ1=(long_Hyo3-TSObj.Lambda.Hyo3+TSObj.MU*LongdotHyo3);
% Activ1=((long_Hyo3-TSObj.Lambda.Hyo3)/fac_Hyo(3)+TSObj.MU*LongdotHyo3); %%% ESSAI
if Activ1>0
  TSObj.Force.Hyo1(3)=TSObj.rho.Hyo*(exp(TSObj.c*Activ1)-1);
  TSObj.Force.Hyo1(3)=TSObj.Force.Hyo1(3)*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotHyo3/TSObj.restpos.restLength_Hyo(3))+TSObj.f5*LongdotHyo3/TSObj.restpos.restLength_Hyo(3));
  if TSObj.Force.Hyo1(3)>20
    TSObj.Force.Hyo1(3)=20;
  end
  TSObj.FXY(TSObj.Att.Hyo1(4,2)-1)=TSObj.FXY(TSObj.Att.Hyo1(4,2)-1)-(TSObj.XY(TSObj.Att.Hyo1(4,2)-1)-TSObj.cont.X3)/long_Hyo3*TSObj.Force.Hyo1(3);
  TSObj.FXY(TSObj.Att.Hyo1(4,2))=TSObj.FXY(TSObj.Att.Hyo1(4,2))-(TSObj.XY(TSObj.Att.Hyo1(4,2))-TSObj.cont.Y3)/long_Hyo3*TSObj.Force.Hyo1(3);
else 
  TSObj.Force.Hyo1(3)=0;
end

