function [x,y,i,l]=intersection(x1,y1,xx1,yy1,x2,y2,xx2,yy2);

global tt;

% cette fonction calcule le point d'intersection eventuel de la droite
% definie par les quatre premiers parametres avec le segment defini
% par les quatre derniers.
% 
% Entree :
%   (x1,y1)    Premier point du premier segment
%   (xx1,yy1)  Second point du premier segment
%   (x2,y2)    Premier point du second segment
%   (xx2,yy2)  Second point du second segment
% 
% Sortie :
%   (x,y)      Coordonnees du point d'intersection des *droites*
%   i          Drapeau mis a 1 s'il y a bien intersection des *segments*
%   l          Distance de (x,y) a (x2,y2) en cas d'intersection (i=1)

% equ de la premiere droite y=a1x+b1
a1=(yy1-y1)/(xx1-x1);
b1=y1-a1*x1;
% equ de la deuxieme droite y=a2x+b2
a2=(yy2-y2)/(xx2-x2);
b2=y2-a2*x2;
% resolution du systeme d'equation
x=(b2-b1)/(a1-a2);
y=a1*x+b1;
% calcul de la distance max du point 3 aux points 1 ou 2 du segment
D1=(x-x2)^2+(y-y2)^2;
D2=(x-xx2)^2+(y-yy2)^2;
Dmax=max(D1,D2);
% Longueur du segment
Long=(xx2-x2)^2+(yy2-y2)^2;
% Test de l'intersection avec le segment
if(tt>035)
  disp('Dmax Long');
  disp([Dmax Long]);
end
if(Dmax<=Long)
  i=1;
  l=sqrt(D1);
else
  i=0;
  l=0;
end
