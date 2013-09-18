function L = doNorm(L, Moy, Ecart)
% normalize lambdas, formants or forces (use with rbf networks)

[s,tmp,h] = size(L);

for k = 1:h
	L(:,:,k) = (L(:,:,k) - ones(s,1)*Moy) ./ (ones(s,1) * Ecart);
end
