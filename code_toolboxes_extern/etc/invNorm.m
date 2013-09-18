function L = invNorm(L, Moy, Ecart)
% de-normalize lambdas, formants or forces (use with rbf networks)

[s, ~, h] = size(L);

for i = 1:h
    
	L(:,:,i) = L(:,:,i).*(ones(s,1)*Ecart)+(ones(s,1)*Moy);
    
end
