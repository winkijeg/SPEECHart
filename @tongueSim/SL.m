function SL(TSObj, U);
% SL.m
% Calculs des forces exercees par le Superior Longitudinalis (SL)
% Il y a 1 fibre

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV
% Modifié en Mars 2004 - PP (Forces appliquées aux insertions du muscle
% dans la langue)
% -------------------------------------------------------------------+
% % Variables globales d'entree                                        |
% global TSObj.NN TSObj.NNx2;                 % Largeur du modele                  |
% global TSObj.NNxMMx2;                 % Offset de U' dans U                |
% global fact;                    % Resolution du modele               |
% global TSObj.Att.SL;                  % Points d'attache du SL             |
% global TSObj.XY;                      % Position des noeuds                |
% global TSObj.Lambda.SL TSObj.MU;            % Pour calculer l'activation du SL   |
% global TSObj.rho.SL TSObj.c TSObj.f1 TSObj.f2 TSObj.f3 TSObj.f4 TSObj.f5; % Pour calculer la force du SL       |
% global TSObj.restpos.restLength_SL;            % Idem                               |
% global TSObj.t_i;                     % 'Temps entier' pout TSObj.ACTIV_T        |
% % -------------------------------------------------------------------+
% % Variables globales d'entree/sortie                                 |
% global TSObj.FXY;                     % Force exercee en chaque noeud      |
% global TSObj.ACTIV_T;                 % Activation des muscles             |
% % -------------------------------------------------------------------+
% % Variables globales de sortie                                       |
% global TSObj.Force.SL;                 % Force exercee par chaque fibre     |
% % -------------------------------------------------------------------+
%TSObj.Att.SL
for k=1:2
	long_SL(k)=0;  % Modifs YP-PP Dec 99
	for j=TSObj.Att.SL(k,1)+TSObj.NN:TSObj.NN:TSObj.Att.SL(k,2) % Modifs YP-PP Dec 99
  		v1=2*j; % %%
  		long(j)=sqrt((TSObj.XY(v1-1)-TSObj.XY(v1-TSObj.NNx2-1))^2+(TSObj.XY(v1)-TSObj.XY(v1-TSObj.NNx2))^2);
  		long_SL(k)=long_SL(k)+long(j);  % Modifs YP-PP Dec 99
	end
	LongdotSL(k)=((TSObj.XY(TSObj.Att.SL(k,4)-1)-TSObj.XY(TSObj.Att.SL(k,3)-1))*U(TSObj.NNxMMx2+TSObj.Att.SL(k,4)-1)+(TSObj.XY(TSObj.Att.SL(k,4))-TSObj.XY(TSObj.Att.SL(k,3)))*U(TSObj.NNxMMx2+TSObj.Att.SL(k,4)))/long_SL(k);
	Activ1=(long_SL(k)-TSObj.Lambda.SL+TSObj.MU*LongdotSL(k));
	if Activ1>0
  		TSObj.Force.SL=TSObj.rho.SL*(exp(TSObj.c*Activ1)-1);
  		TSObj.Force.SL=TSObj.Force.SL*(TSObj.f1+TSObj.f2*atan(TSObj.f3+TSObj.f4*LongdotSL(k)/TSObj.restpos.restLength_SL(k))+TSObj.f5*LongdotSL(k)/TSObj.restpos.restLength_SL(k));
  		if TSObj.Force.SL>20
   		 TSObj.Force.SL=20;
  		end
  		for j=TSObj.Att.SL(k,1)+TSObj.NN:TSObj.NN:TSObj.Att.SL(k,2)-TSObj.NN
   		 v1=2*j; % %%
   		 TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1+TSObj.NNx2-1))/long(j+TSObj.NN)*TSObj.Force.SL;
   		 TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1+TSObj.NNx2))/long(j+TSObj.NN)*TSObj.Force.SL;
    		TSObj.FXY(v1-1)=TSObj.FXY(v1-1)-(TSObj.XY(v1-1)-TSObj.XY(v1-TSObj.NNx2-1))/long(j)*TSObj.Force.SL;
    		TSObj.FXY(v1)=TSObj.FXY(v1)-(TSObj.XY(v1)-TSObj.XY(v1-TSObj.NNx2))/long(j)*TSObj.Force.SL;
  		end
  		TSObj.FXY(TSObj.Att.SL(k,4)-1)=TSObj.FXY(TSObj.Att.SL(k,4)-1)-(TSObj.XY(TSObj.Att.SL(k,4)-1)-TSObj.XY(TSObj.Att.SL(k,4)-TSObj.NNx2-1))/long(TSObj.Att.SL(k,2))*TSObj.Force.SL;
 		 TSObj.FXY(TSObj.Att.SL(k,4))=TSObj.FXY(TSObj.Att.SL(k,4))-(TSObj.XY(TSObj.Att.SL(k,4))-TSObj.XY(TSObj.Att.SL(k,4)-TSObj.NNx2))/long(TSObj.Att.SL(k,2))*TSObj.Force.SL;
         % Modif Mars 2004 PP.
         %On applique aussi une force sur l'origine du muscle dans la
         %langue (noeuds 65=TSObj.Att.SL(1,1) et 64 = tt_SL(2,1)), qui
         %correspondent dans la matrice TSObj.FXY aux positions 
         %(2*65-1)=TSObj.Att.SL(1,3)-1 et (2*64-1)=TSObj.Att.SL(2,3)-1 pour la force en x
         % et aux positions
         %(2*65)=TSObj.Att.SL(1,3) et (2*64)=TSObj.Att.SL(2,3) pour la force en y
         % force en X
   		TSObj.FXY(TSObj.Att.SL(k,3)-1)=TSObj.FXY(TSObj.Att.SL(k,3)-1)-(TSObj.XY(TSObj.Att.SL(k,3)-1)-TSObj.XY(TSObj.Att.SL(k,3)+TSObj.NNx2-1))/long(TSObj.Att.SL(k,1)+TSObj.NN)*TSObj.Force.SL;
 		% force en Y
        TSObj.FXY(TSObj.Att.SL(k,3))=TSObj.FXY(TSObj.Att.SL(k,3))-(TSObj.XY(TSObj.Att.SL(k,3))-TSObj.XY(TSObj.Att.SL(k,3)+TSObj.NNx2))/long(TSObj.Att.SL(k,1)+TSObj.NN)*TSObj.Force.SL;

         %	display('x')
 	%	 TSObj.FXY(TSObj.Att.SL(k,4)-1)-(TSObj.XY(TSObj.Att.SL(k,4)-1)-TSObj.XY(TSObj.Att.SL(k,4)-TSObj.NNx2-1))/long(TSObj.Att.SL(k,2)) % TEST
 	%	 display('y')
 	%	 TSObj.FXY(TSObj.Att.SL(k,4))-(TSObj.XY(TSObj.Att.SL(k,4))-TSObj.XY(TSObj.Att.SL(k,4)-TSObj.NNx2))/long(TSObj.Att.SL(k,2)) % TEST

		else 
		  TSObj.Force.SL=0;
	end
   TSObj.ACTIV_T(TSObj.t_i, 5) = Activ1;
end
   

