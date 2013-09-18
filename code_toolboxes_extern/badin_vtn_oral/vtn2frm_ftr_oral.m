function [H_eq, F_form] = vtn2frm_ftr_oral(ORAL, nbfreq, Fmax, Fmin)

% nbfreq = 256; Fmax = 5000; Fmin = Fmax / nbfreq; 
f = linspace(Fmin, Fmax, nbfreq);
seuil2 = 10;

% Calcul de la FT associée
[H_eq, F_form] = aire2spectre_oral(ORAL, nbfreq, Fmax, Fmin);

% Détermination des pics du module de fonction de transfert
[maxi, ind_maxi, mini, ind_mini] = peakpick(20*log10(abs(H_eq)));
frq_min = f(ind_mini); 
frq_max = f(ind_maxi); 

FEST = frq_max; 
IFEST = length(FEST);

FE = 300; BNPE = 50; ITERMX = 100; FMAX = 5000; NF = 0; F_form = []; Z_form = [];
for II = 1:IFEST
    
    FE = FEST(II);
	% Recherche des poles de H_eq par nraph
    [F, BP] = nraph_oral(FE, BNPE, ITERMX, FMAX, ORAL, F_form);
    NF = NF + 1;
    F_form(NF, 2) = F;
    F_form(NF, 4) = BP;
    % % % % % 	F_form(NF, 4) = 20*log10(aire2spectre_oral(ORAL, 1, F, F)); F_form(NF, 1) = NF;
	% On ne prend pas en compte si par erreur on retombe sur le même pole
	if NF > 1
		if (abs(F_form(NF, 2) - F_form(NF-1, 2))) < seuil2
			F_form(NF, :) = []; NF = NF - 1;
		end
	end % if NF > 1
%	H_cor = aire2spectre_cor(ORAL, NASAL, nbfreq, Fmax, Fmin, F_form, Z_form);
%	plot(f, 20*log10(abs(H_cor)), coul(NF))
end


return







