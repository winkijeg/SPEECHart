function STYLO(U)
% STYLO.m
% Calculs des forces exercees par le Styloglossus (Stylo)
% Il y a 2 fibres

% Cree le     11/03/99 - CV
% Modifie le  11/03/99 - CV

% -------------------------------------------------------------------+
% Variables globales d'entree                                        |
global NNxMMx2;                 % Offset de U' dans U                |
global Att_Stylo;               % Points d'attache du Stylo          |
global XS YS;                   % Idem, hors langue                  |
global XY;                      % Position des noeuds                |
global LAMBDA_Stylo1 MU;        % Pour calculer l'activation du Stylo|
global LAMBDA_Stylo2;           % Idem                               |
global rho_Stylo c              % Pour calculer la force du Stylo    |
global f1 f2 f3 f4 f5;          % Idem                               |
global longrepos_Stylo;         % Idem                               |
global t_i;                     % 'Temps entier' pout ACTIV_T        |
% -------------------------------------------------------------------+
% Variables globales d'entree/sortie                                 |
global FXY;                     % Force exercee en chaque noeud      |
global ACTIV_T;                 % Activation des muscles             |
% -------------------------------------------------------------------+
% Variables globales de sortie                                       |
global ForceStylo1 ForceStylo2; % Force exercee par chaque fibre     |
% -------------------------------------------------------------------+

% Premiere fibre Stylo
long=sqrt((XY(Att_Stylo(1,2)-1)-XS)^2+(XY(Att_Stylo(1,2))-YS)^2);
LongdotStylo1=((XY(Att_Stylo(1,2)-1)-XS)*U(NNxMMx2+Att_Stylo(1,2)-1)+(XY(Att_Stylo(1,2))-YS)*U(NNxMMx2+Att_Stylo(1,2)))/long;
Activ1=(long-LAMBDA_Stylo1+MU*LongdotStylo1);
if Activ1>0
    ForceStylo1=rho_Stylo*(exp(c*Activ1)-1);
    ForceStylo1=ForceStylo1*(f1+f2*atan(f3+f4*LongdotStylo1/longrepos_Stylo(1))+f5*LongdotStylo1/longrepos_Stylo(1));
    if ForceStylo1>20
        ForceStylo1=20;
    end
    FXY(Att_Stylo(1,2)-1)=FXY(Att_Stylo(1,2)-1)-(XY(Att_Stylo(1,2)-1)-XS)/long*ForceStylo1;
    FXY(Att_Stylo(1,2))=FXY(Att_Stylo(1,2))-(XY(Att_Stylo(1,2))-YS)/long*ForceStylo1;
else
    ForceStylo1=0;
end
ACTIV_T(t_i, 3) = Activ1;

% Seconde fibre Stylo
long1=sqrt((XY(Att_Stylo(2,2)-1)-XY(Att_Stylo(3,2)-1))^2+(XY(Att_Stylo(2,2))-XY(Att_Stylo(3,2)))^2);
long2=sqrt((XY(Att_Stylo(3,2)-1)-XS)^2+(XY(Att_Stylo(3,2))-YS)^2);
long=long1+long2;
LongdotStylo2=((XY(Att_Stylo(2,2)-1)-XS)*U(NNxMMx2+Att_Stylo(2,2)-1)+(XY(Att_Stylo(2,2))-YS)*U(NNxMMx2+Att_Stylo(2,2)))/long;
Activ1=(long-LAMBDA_Stylo2+MU*LongdotStylo2);
if Activ1>0
    ForceStylo2=rho_Stylo*(exp(c*Activ1)-1);
    ForceStylo2=ForceStylo2*(f1+f2*atan(f3+f4*LongdotStylo2/longrepos_Stylo(2))+f5*LongdotStylo2/longrepos_Stylo(2));
    if ForceStylo2>20
        ForceStylo2=20;
    end
    FXY(Att_Stylo(2,2)-1)=FXY(Att_Stylo(2,2)-1)-(XY(Att_Stylo(2,2)-1)-XY(Att_Stylo(3,2)-1))/long1*ForceStylo2;
    FXY(Att_Stylo(2,2))=FXY(Att_Stylo(2,2))-(XY(Att_Stylo(2,2))-XY(Att_Stylo(3,2)))/long1*ForceStylo2;
    
    FXY(Att_Stylo(3,2)-1)=FXY(Att_Stylo(3,2)-1)-(XY(Att_Stylo(3,2)-1)-XY(Att_Stylo(2,2)-1))/long1*ForceStylo2;
    FXY(Att_Stylo(3,2))=FXY(Att_Stylo(3,2))-(XY(Att_Stylo(3,2))-XY(Att_Stylo(2,2)))/long1*ForceStylo2;
    
    FXY(Att_Stylo(3,2)-1)=FXY(Att_Stylo(3,2)-1)-(XY(Att_Stylo(3,2)-1)-XS)/long2*ForceStylo2;
    FXY(Att_Stylo(3,2))=FXY(Att_Stylo(3,2))-(XY(Att_Stylo(3,2))-YS)/long2*ForceStylo2;
else
    ForceStylo2=0;
end

end

