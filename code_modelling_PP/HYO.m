function HYO(U)
% Calculs des forces exercees par le Hyoglossus (Hyo) (3 fibres)

% Variables globales d'entree 
global NNxMMx2;                 % Offset de U' dans U
global Att_Hyo;                 % Points d'attache du Hyo 
global X1 Y1 X2 Y2 X3 Y3;       % Idem, hors langue
global XY;                      % Position des noeuds 
global LAMBDA_Hyo1 LAMBDA_Hyo2; % Pour calculer l'activation du Hyo
global LAMBDA_Hyo3 MU;          % Idem
global rho_Hyo c f1 f2 f3 f4 f5;% Pour calculer la force du Hyo
global longrepos_Hyo;           % Idem 
global t_i;                     % 'Temps entier' pout ACTIV_T

% Variables globales d'entree/sortie 
global FXY;                     % Force exercee en chaque noeud 
global ACTIV_T;                 % Activation des muscles 

% Variables globales de sortie 
global ForceHyo;                % Force exercee par chaque fibre

% Premiere fibre Hyo
long1=sqrt((XY(Att_Hyo(1,2)-1)-X1)^2+(XY(Att_Hyo(1,2))-Y1)^2);
long2=sqrt((XY(Att_Hyo(2,2)-1)-XY(Att_Hyo(1,2)-1))^2+(XY(Att_Hyo(2,2))-XY(Att_Hyo(1,2)))^2);
long_Hyo1=long1+long2;
LongdotHyo1=((XY(Att_Hyo(2,2)-1)-X1)*U(NNxMMx2+Att_Hyo(2,2)-1)+(XY(Att_Hyo(2,2))-Y1)*U(NNxMMx2+Att_Hyo(2,2)))/long_Hyo1;
 Activ1=(long_Hyo1-LAMBDA_Hyo1+MU*LongdotHyo1);
% Activ1=((long_Hyo1-LAMBDA_Hyo1)/fac_Hyo(1)+MU*LongdotHyo1); %%% ESSAI
if Activ1>0
  ForceHyo(1)=rho_Hyo*(exp(c*Activ1)-1);
  ForceHyo(1)=ForceHyo(1)*(f1+f2*atan(f3+f4*LongdotHyo1/longrepos_Hyo(1))+f5*LongdotHyo1/longrepos_Hyo(1));
  ForceHyo(1)=ForceHyo(1)/15.; % Modifs Dec 99 YP-PP On divise par 2 car la force de la premiere fibre est trop grande et la langue ne se deforme pas correctement.
  if ForceHyo(1)>20
    ForceHyo(1)=20;
  end
  FXY(Att_Hyo(1,2)-1)=FXY(Att_Hyo(1,2)-1)-(XY(Att_Hyo(1,2)-1)-X1)/long1*ForceHyo(1);
  FXY(Att_Hyo(1,2))=FXY(Att_Hyo(1,2))-(XY(Att_Hyo(1,2))-Y1)/long1*ForceHyo(1);
  
  FXY(Att_Hyo(1,2)-1)=FXY(Att_Hyo(1,2)-1)-(XY(Att_Hyo(1,2)-1)-XY(Att_Hyo(2,2)-1))/long2*ForceHyo(1);
  FXY(Att_Hyo(1,2))=FXY(Att_Hyo(1,2))-(XY(Att_Hyo(1,2))-XY(Att_Hyo(2,2)))/long2*ForceHyo(1);
  
  FXY(Att_Hyo(2,2)-1)=FXY(Att_Hyo(2,2)-1)-(XY(Att_Hyo(2,2)-1)-XY(Att_Hyo(1,2)-1))/long2*ForceHyo(1);
  FXY(Att_Hyo(2,2))=FXY(Att_Hyo(2,2))-(XY(Att_Hyo(2,2))-XY(Att_Hyo(1,2)))/long2*ForceHyo(1);
else 
  ForceHyo(1)=0;
end

ACTIV_T(t_i, 4) = Activ1;

% Seconde fibre Hyo
long_Hyo2=sqrt((XY(Att_Hyo(3,2)-1)-X2)^2+(XY(Att_Hyo(3,2))-Y2)^2);
LongdotHyo2=((XY(Att_Hyo(3,2)-1)-X2)*U(NNxMMx2+Att_Hyo(3,2)-1)+(XY(Att_Hyo(3,2))-Y2)*U(NNxMMx2+Att_Hyo(3,2)))/long_Hyo2;
 Activ1=(long_Hyo2-LAMBDA_Hyo2+MU*LongdotHyo2);
% Activ1=((long_Hyo2-LAMBDA_Hyo2)/fac_Hyo(2)+MU*LongdotHyo2); %%% ESSAI
if Activ1>0
  ForceHyo(2)=rho_Hyo*(exp(c*Activ1)-1);
  ForceHyo(2)=ForceHyo(2)*(f1+f2*atan(f3+f4*LongdotHyo2/longrepos_Hyo(2))+f5*LongdotHyo2/longrepos_Hyo(2));
  ForceHyo(2)=ForceHyo(2)/3; % Modifs Dec 99 YP-PP On divise par 1.5 car la force de la deuxieme fibre est trop grande et la langue ne se deforme pas correctement.
  if ForceHyo(2)>20
    ForceHyo(2)=20;
  end
  FXY(Att_Hyo(3,2)-1)=FXY(Att_Hyo(3,2)-1)-(XY(Att_Hyo(3,2)-1)-X2)/long_Hyo2*ForceHyo(2);
  FXY(Att_Hyo(3,2))=FXY(Att_Hyo(3,2))-(XY(Att_Hyo(3,2))-Y2)/long_Hyo2*ForceHyo(2); 
else 
  ForceHyo(2)=0;
end


% Troisieme fibre Hyo
long_Hyo3=sqrt((XY(Att_Hyo(4,2)-1)-X3)^2+(XY(Att_Hyo(4,2))-Y3)^2);
LongdotHyo3=((XY(Att_Hyo(4,2)-1)-X3)*U(NNxMMx2+Att_Hyo(4,2)-1)+(XY(Att_Hyo(4,2))-Y3)*U(NNxMMx2+Att_Hyo(4,2)))/long_Hyo3;
 Activ1=(long_Hyo3-LAMBDA_Hyo3+MU*LongdotHyo3);
% Activ1=((long_Hyo3-LAMBDA_Hyo3)/fac_Hyo(3)+MU*LongdotHyo3); %%% ESSAI
if Activ1>0
  ForceHyo(3)=rho_Hyo*(exp(c*Activ1)-1);
  ForceHyo(3)=ForceHyo(3)*(f1+f2*atan(f3+f4*LongdotHyo3/longrepos_Hyo(3))+f5*LongdotHyo3/longrepos_Hyo(3));
  if ForceHyo(3)>20
    ForceHyo(3)=20;
  end
  FXY(Att_Hyo(4,2)-1)=FXY(Att_Hyo(4,2)-1)-(XY(Att_Hyo(4,2)-1)-X3)/long_Hyo3*ForceHyo(3);
  FXY(Att_Hyo(4,2))=FXY(Att_Hyo(4,2))-(XY(Att_Hyo(4,2))-Y3)/long_Hyo3*ForceHyo(3);
else 
  ForceHyo(3)=0;
end

end

