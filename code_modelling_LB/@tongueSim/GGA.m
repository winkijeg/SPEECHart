function GGA(TSObj, U);
% GGA.m
% Calculs des forces exercees par le Ant. Genoiglossus (GGA)
% Il y a (1+2*TSObj.fact) fibres

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% % -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global TSObj.fact;                    % Resolution du modele               |
% global TSObj.Att.GGA;                 % Points d'attache du GGA            |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.GGA TSObj.MU;           % Pour calculer l'activation du GGA  |
% global TSObj.rho.GG TSObj.c TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5; % Pour calculer la force du GGA      |
% global TSObj.restpos.restLength_GGA;           % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout TSObj.ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global TSObj.ACTIV_T;                 % Activation des muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.GGA;                % Force exercee par chaque fibre     |
% % -------------------------------------------------------------------+


for k=1:3*TSObj.fact          % boucle sur le nombre de fibres Modif Nov 99 3*TSObj.fact
  longtot=0;
  for j=TSObj.Att.GGA(k,2):-1:TSObj.Att.GGA(k,1)+1
    v1=2*j; % %%
    long(j)=sqrt((TSObj.XY(v1-1)-TSObj.XY(v1-3))^2+(TSObj.XY(v1)-TSObj.XY(v1-2))^2);
    longtot=longtot+long(j);
  end
  LongdotGGA(k)=((TSObj.XY(TSObj.Att.GGA(k,4)-1)-TSObj.XY(TSObj.Att.GGA(k,3)-1))*U(TSObj.NNxMMx2+TSObj.Att.GGA(k,4)-1)+(TSObj.XY(TSObj.Att.GGA(k,4))-TSObj.XY(TSObj.Att.GGA(k,3)))*U(TSObj.NNxMMx2+TSObj.Att.GGA(k,4)))/longtot;
  % Calcul de l'activite musculaire
  Activ1=(longtot-TSObj.Lambda.GGA(k)+TSObj.MU*LongdotGGA(k));
  % Calcul de la force F de l'equa diff
  if Activ1>0
    TSObj.Force.GGA(k)=TSObj.rho.GG*(exp(TSObj.c*Activ1)-1);
    TSObj.Force.GGA(k)=TSObj.Force.GGA(k)*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotGGA(k)/TSObj.restpos.restLength_GGA(k))+TSObj.f5*LongdotGGA(k)/TSObj.restpos.restLength_GGA(k));
    % Saturation de la force
    if TSObj.Force.GGA(k)>20
      TSObj.Force.GGA(k)=20;
   end
   if (k == 1)
      TSObj.Force.GGA(k)= TSObj.Force.GGA(k)/2;
   end
   
    % Calcul de la force TSObj.FXY appliquee aux noeuds
    TSObj.FXY(TSObj.Att.GGA(k,4)-1)=TSObj.FXY(TSObj.Att.GGA(k,4)-1)-(TSObj.XY(TSObj.Att.GGA(k,4)-1)-TSObj.XY(TSObj.Att.GGA(k,4)-3))/long(TSObj.Att.GGA(k,2))*TSObj.Force.GGA(k);
    TSObj.FXY(TSObj.Att.GGA(k,4))=TSObj.FXY(TSObj.Att.GGA(k,4))-(TSObj.XY(TSObj.Att.GGA(k,4))-TSObj.XY(TSObj.Att.GGA(k,4)-2))/long(TSObj.Att.GGA(k,2))*TSObj.Force.GGA(k);
    for j=TSObj.Att.GGA(k,2)-1:-1:TSObj.Att.GGA(k,1)+1
      v1=2*j; % %%
      TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1+1))/long(j+1)*TSObj.Force.GGA(k);
      TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1+2))/long(j+1)*TSObj.Force.GGA(k);
      TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1-3))/long(j)*TSObj.Force.GGA(k);
      TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1-2))/long(j)*TSObj.Force.GGA(k);
      % Il serait bien vu de faire un  regroupement des 2 lignes...
    end
  else 
    TSObj.Force.GGA(k)=0;
  end
end
TSObj.ACTIV_T(TSObj.t_i, 2) = Activ1;


