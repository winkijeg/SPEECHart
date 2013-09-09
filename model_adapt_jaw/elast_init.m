function elast_init=elast_init(activGGA,activGGP,activHyo,activStylo,activSL,activVert,ncontact);

% Calcule la matrice d'elasticite A0 en fonction des activites des
% differents muscles : E vaut 15 kPa pour un element au repos et 250
% kPa pour un element contracte au maximum.
% Ceci correspond a multiplier lambda et mu jusqu'a 16 fois leurs
% valeurs initiales.

% Parametres d'entree :
% -  Les activation des muscles 
% -  ncontact qui est un vecteur contenant 0 et les indices des noeuds qui
%    entrent en contact avec le palais : les coefficients de la
%    matrice d'elasticite dependent en effet des points fixes de
%    l'element considere.


global XY
global NN
global MM
global fact
global lambda
global mu
global ordre
global H
global G

AA=zeros(1,(2*NN*MM)^2);
saut=-2;

for jj=1:(NN-1)*(MM-1)    % Boucle sur les elements
  if rem(jj-1,NN-1)==0  % saut est incremente a chaque changement de ligne
    saut=saut+2;
  end  
  
  % La colonne jj de xy contient les coordonnees des 4 noeuds de
  % l'element jj dans l'ordre : x1 y1 x2 y2 x3 y3 x4 y4
  % 
  %                   2             4
  %                    _____________
  %                   /            /
  %                  /     jj     /
  %                 /            /
  %                 -------------
  %                1            3
  % 
  xy(:,jj)=[XY(2*jj-1+saut:2*jj+2+saut);XY(2*jj-1+2*NN+saut:2*jj+2+2*NN+saut)];
  
  % On rajoute dans KK qui est un morceau d'une ligne de A0 les
  % composantes de la matrice d'elasticite qui correspondent a chaque
  % element.
  % Les calculs font appel aux programmes matlab K*.m selon
  % que l'element considere possede des noeuds fixes ou non.
  % On utilise la formule de la quadrature de Gauss.
  KK=sparse(1,64);
  
  % Les elements sont separes selon leur position : fixe, attache sur
  % un des cotes, et selon les muscles qui les traversent
  
  % Modifications de lambda et mu en fonction de l'activite des muscles
  lambda2=lambda;
  mu2=mu;

  
  % Calcul selon la position de l'element
  if jj==NN-1                    % element au noeud fixe en bas a droite
    pfix=2;
  elseif rem(jj,NN-1)==1         % element aux noeuds fixes a gauche en haut en et bas
    pfix=1;
% Modif Novembre 99 YP - PP
%  elseif sum(jj==6*ncontact/7-6) % element dont le noeud haut gauche entre en contact
%    pfix=3;
%  elseif sum(jj==6*ncontact/7)   % element dont le noeud haut droit entre en contact
%    pfix=4;
  else                           % element libre
    pfix=0;
  end
  for i=1:ordre
    for j=1:ordre
      KK=KK+H(ordre,i)*H(ordre,j)*K(G(ordre,i),G(ordre,j),xy(:,jj),lambda2,mu2,pfix);
    end
  end
  
  debut=(2*NN*MM)*(2*jj-2+saut)+2*jj-1+saut;
  colonne=[debut*ones(1,4)+[0,1,2,3],(debut+2*NN)*ones(1,4)+[0,1,2,3]];
  step=(2*NN*MM)*ones(1,8);
  II=[colonne,colonne+step,colonne+2*step,colonne+3*step];
  I=[II,II+2*NN*(2*NN*MM)*ones(1,32)];
  AA(I)=AA(I)+KK;
end    % de la boucle sur les elements  

elast_init=reshape(AA,2*NN*MM,2*NN*MM);
