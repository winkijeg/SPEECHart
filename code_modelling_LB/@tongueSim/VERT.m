function VERT(TSObj, U);
% VERT.m
% Calculs des forces exercees par le Verticalis (Vert)
% Il y a (1+3*TSObj.fact) fibres

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% % -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NN;                      % Largeur du modele                  |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global TSObj.fact;                    % Resolution du modele               |
% global TSObj.Att.Vert;                % Points d'attache du Vert           |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.Vert TSObj.MU;          % Pour calculer l'activation du Vert |
% global TSObj.rho.Vert TSObj.c;              % Pour calculer la force du Vert     |
% global TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5;          % Idem                               |
% global TSObj.restpos.restLength_Vert;          % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout TSObj.ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global TSObj.ACTIV_T;                 % Activation des muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.Vert;                % Force exercee par chaque fibre    |
% % -------------------------------------------------------------------+
% global TSObj.restpos.fac_Vert;

for k=1:3*TSObj.fact     % boucle sur le nombre de fibres
                   % Modif Nov 99 YP-PP
  longtot=0;
  for j=TSObj.Att.Vert(k,2):-1:TSObj.Att.Vert(k,1)+1
    v1=2*j; % %%
    long(j)=sqrt((TSObj.XY(v1-1)-TSObj.XY(v1-3))^2+(TSObj.XY(v1)-TSObj.XY(v1-2))^2);
    longtot=longtot+long(j);
  end
  LongdotVert(k)=((TSObj.XY(TSObj.Att.Vert(k,4)-1)-TSObj.XY(TSObj.Att.Vert(k,3)-1))*U(TSObj.NNxMMx2+TSObj.Att.Vert(k,4)-1)+(TSObj.XY(TSObj.Att.Vert(k,4))-TSObj.XY(TSObj.Att.Vert(k,3)))*U(TSObj.NNxMMx2+TSObj.Att.Vert(k,4)))/longtot;
  Activ1=(longtot-TSObj.Lambda.Vert(k)+TSObj.MU*LongdotVert(k));
  if Activ1>0
    TSObj.Force.Vert(k)=TSObj.rho.Vert*(exp(TSObj.c*Activ1)-1);
    TSObj.Force.Vert(k)=TSObj.Force.Vert(k)*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotVert(k)/TSObj.restpos.restLength_Vert(k))+TSObj.f5*LongdotVert(k)/TSObj.restpos.restLength_Vert(k));
    TSObj.Force.Vert(k)=TSObj.Force.Vert(k)/TSObj.restpos.fac_Vert(k);
    if TSObj.Force.Vert(k)>20
      TSObj.Force.Vert(k)=20;
    end
    TSObj.FXY(TSObj.Att.Vert(k,4)-1)=TSObj.FXY(TSObj.Att.Vert(k,4)-1)-(TSObj.XY(TSObj.Att.Vert(k,4)-1)-TSObj.XY(TSObj.Att.Vert(k,4)-3))/long(TSObj.Att.Vert(k,2))*TSObj.Force.Vert(k);
    TSObj.FXY(TSObj.Att.Vert(k,4))=TSObj.FXY(TSObj.Att.Vert(k,4))-(TSObj.XY(TSObj.Att.Vert(k,4))-TSObj.XY(TSObj.Att.Vert(k,4)-2))/long(TSObj.Att.Vert(k,2))*TSObj.Force.Vert(k);
    TSObj.FXY(TSObj.Att.Vert(k,3)-1)=TSObj.FXY(TSObj.Att.Vert(k,3)-1)-(TSObj.XY(TSObj.Att.Vert(k,3)-1)-TSObj.XY(TSObj.Att.Vert(k,3)+1))/long(TSObj.Att.Vert(k,1)+1)*TSObj.Force.Vert(k);
    TSObj.FXY(TSObj.Att.Vert(k,3))=TSObj.FXY(TSObj.Att.Vert(k,3))-(TSObj.XY(TSObj.Att.Vert(k,3))-TSObj.XY(TSObj.Att.Vert(k,3)+2))/long(TSObj.Att.Vert(k,1)+1)*TSObj.Force.Vert(k);
    for j=TSObj.Att.Vert(k,2)-1:-1:TSObj.Att.Vert(k,1)+1
      v1=2*j; % %%
      TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1+1))/long(j+1)*TSObj.Force.Vert(k);
      TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1+2))/long(j+1)*TSObj.Force.Vert(k);
      TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1-3))/long(j)*TSObj.Force.Vert(k);
      TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1-2))/long(j)*TSObj.Force.Vert(k);
    end
  else 
    TSObj.Force.Vert(k)=0;
  end
end

TSObj.ACTIV_T(TSObj.t_i, 7) = Activ1;

