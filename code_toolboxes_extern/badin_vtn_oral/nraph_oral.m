%---c----C----c----C----c----C----c----C----c----C----c----C----c----C
%
%                     INSTITUT DE LA COMMUNICATION PARLEE
%                               GRENOBLE, FRANCE
%
%                               ** nraph3.ftn **
%
%       Creation : 7 Juin 1987
%
%
% Hugo SANCHEZ
% Creation : 19 Juin 1984
% Mis a jour : 19 Juin 1984
% Derniere modification : Pierre BADIN (21 novembre 1985)
%     "         "       : 86-08-29 (Possibilite de recherche de zeros
%                       et de poles simples et complexes conjugues,
%                       aussi bien dans TP que dans TZ.
%     "         "       : 87-02-13 (Commentaires pour une version globale 0)
% Derniere Modification : 87-03-04 (Passage sur VAX)
%     "         "       : 87-06_08 (Conditions sur INAS)
%-----------------------------------------------------------------------------
%       Entree
%               FE, BNPE, Estimation de depart des parametres
%               ITERMX, Nombre d'iterations autorisees
%               MODE =1 recherche des poles de TP
%                    =2     "         poles de TZ
%                    =3     "     des zeros de TP
%                    =4     "         zeros de TZ
%               FMAX, Frequence maximum autorisee
%
%       Sorties
%               F, BP, Parametres estimes par le programme
%               NRAPH, Nombre d'iterations (=0 si pas de solution)


function [F, BP, ITER, FRQ, HHH] = nraph_oral(FE, BNPE, ITERMX, FMAX, ORAL, F_form);

DELTAS = complex(30, 30); SEUIL = 0.3; ITER = 1;
SI = complex(-BNPE*pi, FE*2*pi);

F = NaN; BP = NaN;

% Suivant que Z_form existe ou non, on cherche les pôles ou les zéros

% Recherche des poles ou des zéros
while ITER < ITERMX
	% Calcul du premier point
	FIcx = -j * SI / (2*pi); 
	Q = 1 / aire2spectre_cor_oral(ORAL, 1, FIcx, FIcx, F_form);

	% Calcul du deuxieme point
	SIP = SI + DELTAS; FIPcx = -j * SIP / (2*pi);
	QP = 1 / aire2spectre_cor_oral(ORAL, 1, FIPcx, FIPcx, F_form);
	% Point d'intersection avec 0
	Q1D = (QP - Q) / DELTAS; SISU = SI - (Q / Q1D);
	
	% Si on a trouve ...
	if(abs(SISU-SI) < SEUIL) F = imag(SISU) / (2*pi); BP = - real(SISU)/pi; return
	% ... sinon
	else SI = SISU; ITER = ITER + 1;	end
end  % while ITER < ITERMX	


return
