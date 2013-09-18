function H_eq = aire2spectre_cor_oral(ORAL, nbfreq, Fmax, Fmin, F_form);

H_eq = aire2spectre_oral(ORAL, nbfreq, Fmax, Fmin);

f = linspace(Fmin, Fmax, nbfreq); 
if isreal(f) SI = complex(0, 2 * pi * f); else SI = 2 * pi * j * f; end

NF = size(F_form, 1);
for I = 1 : NF
	SI1 = complex(F_form(I, 4) * pi, F_form(I, 2) * 2 * pi);
	H_eq = H_eq .* ((SI - SI1) .* (SI-conj(SI1))) ./ (SI1 .* conj(SI1));
end

return
