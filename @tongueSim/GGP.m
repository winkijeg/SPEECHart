function GGP(TSObj, U);
% GGP.m
% Calculs des forces exercees par le Post. Genioglossus (GGP)
% Il y a (1+3*TSObj.fact) fibres
% Les NN-1 longueurs correspondent a la longueur totale de la fibre divisee
% par la longueur de chacun des NN-1 elements qu'elle traverse
% longtot est la longueur totale de la fibre
% longdotGGP(k) est la derivee temporelle de la longueur

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% % -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global TSObj.fact;                    % Resolution du modele               |
% global TSObj.Att.GGP;                 % Points d'attache du GGP            |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.GGP TSObj.MU;           % Pour calculer l'activation du GGP  |
% global TSObj.rho.GG TSObj.c TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5; % Pour calculer la force du GGP      |
% global TSObj.restpos.restLength_GGP;           % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global ACTIV_T;                 % Activation des muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.GGP;                % Force exercee par chaque fibre     |
% % -------------------------------------------------------------------+

% global fac_GGP; % ESSAI


for k=1:1+3*TSObj.fact        % boucle sur le nombre de fibres
  longtot=0;
  for j=TSObj.Att.GGP(k,2):-1:TSObj.Att.GGP(k,1)+1
    v1=2*j; % %%
    long(j)=sqrt((TSObj.XY(v1-1)-TSObj.XY(v1-3))^2+(TSObj.XY(v1)-TSObj.XY(v1-2))^2);
    longtot=longtot+long(j);
  end
  LongdotGGP(k)=((TSObj.XY(TSObj.Att.GGP(k,4)-1)-TSObj.XY(TSObj.Att.GGP(k,3)-1))*U(TSObj.NNxMMx2+TSObj.Att.GGP(k,4)-1)+(TSObj.XY(TSObj.Att.GGP(k,4))-TSObj.XY(TSObj.Att.GGP(k,3)))*U(TSObj.NNxMMx2+TSObj.Att.GGP(k,4)))/longtot;
  % Calcul de l'activite musculaire
  Activ1=(longtot-TSObj.Lambda.GGP(k)+TSObj.MU*LongdotGGP(k));
  % Activ1=((longtot-TSObj.Lambda.GGP(k))/fac_GGP(k)+TSObj.MU*LongdotGGP(k)); %%% ESSAI

  % Calcul de la force F de l'equa diff
  if Activ1>0
    TSObj.Force.GGP(k)=TSObj.rho.GG*(exp(TSObj.c*Activ1)-1);
    TSObj.Force.GGP(k)=TSObj.Force.GGP(k)*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotGGP(k)/TSObj.restpos.restLength_GGP(k))+TSObj.f5*LongdotGGP(k)/TSObj.restpos.restLength_GGP(k));
    % Saturation de la force
    if TSObj.Force.GGP(k)>20
      TSObj.Force.GGP(k)=20;
   end
      if (k == (1+3*TSObj.fact))
      TSObj.Force.GGP(k)= TSObj.Force.GGP(k)/2;
   end

    % Calcul de la force TSObj.FXY appliquee aux noeuds
    TSObj.FXY(TSObj.Att.GGP(k,4)-1)=TSObj.FXY(TSObj.Att.GGP(k,4)-1)-(TSObj.XY(TSObj.Att.GGP(k,4)-1)-TSObj.XY(TSObj.Att.GGP(k,4)-3))/long(TSObj.Att.GGP(k,2))*TSObj.Force.GGP(k);
    TSObj.FXY(TSObj.Att.GGP(k,4))=TSObj.FXY(TSObj.Att.GGP(k,4))-(TSObj.XY(TSObj.Att.GGP(k,4))-TSObj.XY(TSObj.Att.GGP(k,4)-2))/long(TSObj.Att.GGP(k,2))*TSObj.Force.GGP(k);
    for j=TSObj.Att.GGP(k,2)-1:-1:TSObj.Att.GGP(k,1)+1
      v1=2*j; % %%
      TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1+1))/long(j+1)*TSObj.Force.GGP(k);
      TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1+2))/long(j+1)*TSObj.Force.GGP(k);
      TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1-3))/long(j)*TSObj.Force.GGP(k);
      TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1-2))/long(j)*TSObj.Force.GGP(k);
    end
  else 
    TSObj.Force.GGP(k)=0;
  end
end
TSObj.ACTIV_T(TSObj.t_i,1)=Activ1;
