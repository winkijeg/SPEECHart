function [H_oral, Y_oral] = aire2spectre_oral(ORAL, nbfreq, Fmax, Fmin);

% function [H_oral, Y_oral] = aire2spectre_oral(ORAL{, nbfreq, Fmax, Fmin});
%
% Calcule:
%   - la FT totale pour les freq Fmin � Fmax � partir de la fonction d'aire ORAL et NASAL
%   - Les formants associ�s
%   - la FT orale
%
% Entr�es
%      ORAL.A(nb_tubes_oral)	  : Aires des tubes oraux (glotte -> l�vres)
%      ORAL.L(nb_tubes_oral)	  : Longueurs des tubes oraux (glotte -> l�vres)
%
%      nbfreq ([256])           : Nombre de point d'�chantillonnage fr�quentiel entre 0 et Fmax
%      Fmax ([5000])            : Fr�quence maximale de la fonction de transfert
%      Fmin ([Fmax/nbfreq])     : Fr�quence minimale de la fonction de transfert
%
%
% Sorties
%      H_oral(nbfreq)           : Fonction de transfert orale (lin�aire)
%      Y_oral(nbfreq)           : Imp�dance d'entr�e du tuyau oral


global CONST_DAT

if nargin == 2 nbfreq = 256; Fmax = 5000; end;
if nargin == 3 Fmax = 5000; end;

% valeurs des constantes Mrayati
c = 35100; % cm/s
rho = 1.14e-3; % g/cm^3
lambda = 5.5e-5;
eta = 1.4;
mu = 1.86e-4;
cp = 0.24;
bp = 1600; % dynes.s/cm
mp = 1.4; % g/cm�

CONST_DAT = [c ; rho ; lambda ; eta ; mu ; cp ; bp ; mp];

% Variables frequences et pulsations
%% ATTENTION : Pas de Fr�quence Nulle !!!
f = linspace(Fmax/nbfreq, Fmax, nbfreq);
if nargin == 5 f = linspace(Fmin, Fmax, nbfreq); end  % if nargin == 5
w=2*pi*f;


% Fonction de transfert Bucale (= de l'embranchement avec le conduit nasal aux l�vres)
%=====================================================================================
% Fonction de Transfert
% Imp�dance de rayonnement aux l�vres
Zr_oral =  rho/(2*pi*c)*(w.^2)+j*8*rho/(3*pi.*sqrt(pi*ORAL.A(end)))*w; 
%Zr_oral =  Inf * ones(size(f)); 
%Zr_oral =  0 * ones(size(f)); 
[H_oral, Y_oral] = spectrelec(w, ORAL.A', Zr_oral, ORAL.L');

% %***************************************
% figure
% clf; hold on; grid on;
% plot(f, 20*log10(abs(H_oral)))
% %***************************************
return




