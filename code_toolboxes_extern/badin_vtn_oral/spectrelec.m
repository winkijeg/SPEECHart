function [H,YE]=spectrelec(w,A,zr,l,no_vibr_paroi);

% Si rien n'est précisé, on prend bien en compte
% les vibrations de paroi
if nargin < 5
	no_vibr_paroi = 0;
end  % if nargin < 5

% utilisation des variables globales
global CONST_DAT

% Par defaut, toutes les longueurs sont egales a 1 cm
if (nargin < 4 )
   l = ones(size(A));
end;
 
% Recuperation des variables
%---------------------------
c = CONST_DAT(1);
ro = CONST_DAT(2);
lambda = CONST_DAT(3);
eta = CONST_DAT(4);
mu = CONST_DAT(5);
cp = CONST_DAT(6);
bp = CONST_DAT(7);
mp = CONST_DAT(8);

% Determination de L,C,R,G,et YP
%-------------------------------

% Périmètre du tube élémentaire
S = 2*sqrt(A*pi) ;

% Caracteristiques du tube
L = ro./A.*l ;
C = A.*l/ro/c/c; % (A*l)/(ro*c^2)

% Perte de Fant 1960
R_coef = sqrt(ro*mu/2*w) ;
G_coef = (eta-1)/(ro*c^2)*sqrt(lambda*w/(2*cp*ro));
R = S.*l./(A.^2) * R_coef ;
G = S.*l * G_coef ;

% pertes par vibration et viscosite le long des parois
YP_coef = 1./(bp^2+mp^2*w.^2) ;
YP = S.*l * ( (bp-j*mp*w).*YP_coef )  ;
if no_vibr_paroi; YP = 0 ; end;

% Sans pertes
%R = 0 ; 
%G = 0 ;
%YP = 0 ;
	
% Determination de Y, Z
%----------------------
Z = R+j*L*w ;
Y = G+j*C*w+YP ;

% Liste des matrices de quadripole
%---------------------------------
aa = (1 + (Z.*Y/2)); 
bb = - (Z + Z.^2 .* Y/4); 
cc = - Y; 
dd = aa;




% calcul de la fonction de transfert
%-----------------------------------
% H=[aa bb ;
%    cc dd]

%    | A  B |
%H = |      |
%    | C  D |
%
%    | a  b |	| A  B |
%H = |      | * |      |
%    | c  d |	| C  D |

aaa = aa(1,:) ;
bbb = bb(1,:) ;
ccc = cc(1,:) ;
ddd = dd(1,:) ;

for ind = (1:length(A)-1)
	
	proda = aa(ind+1,:).*aaa + bb(ind+1,:).*ccc ;
	prodb = aa(ind+1,:).*bbb + bb(ind+1,:).*ddd ;
	prodc = cc(ind+1,:).*aaa + dd(ind+1,:).*ccc ;
	prodd = cc(ind+1,:).*bbb + dd(ind+1,:).*ddd ;
	aaa = proda ;
	bbb = prodb ;
	ccc = prodc ;
	ddd = prodd ;
end

if (zr==inf)
	H=0;
	YE= -ccc./ddd ;
else

	% calcul de la fonction de transfert
	% pl = aaa * pg + bbb * ug
	% ul = ccc * pg + ddd * ug
	% or pl = zr * ul
	% on obtient donc, (aaa*ddd-bbb*ccc =1)
	% ul / ug = 1 / (aaa - ccc * zr)

	H = ones(size(aaa))./( aaa - ccc.*zr) ;

	% calcul de la conductance d'entree
	YE = -( aaa - ccc.*zr ) ./ ( bbb - ddd.*zr ) ;
end;
