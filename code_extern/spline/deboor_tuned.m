function val = deboor_tuned(knotsTmp, controlPoints, y, order)
%
% INPUT:  knotsTmp          Stützstellen
%         controlPoints     Kontrollpunkte [n x 2] - matrix
%         y                 Auswertungspunkte (Spaltenvektor)
%         order             spline order
%
% OUTPUT: val   Werte des B-Splines an y (mx2-Matrix)
%
% Date:   2007-11-27
% Author: Jonas Ballani

m = size(controlPoints, 1);
n = length(y);
X = zeros(order, order);
Y = zeros(order, order);
a = knotsTmp(1);
b = knotsTmp(end);

knotsFinal = [ones(1, order-1)*a, knotsTmp, ones(1, order-1)*b];

for cnt = 1:n
    t0 = y(cnt);
    id = find(t0 >= knotsFinal);
    k = id(end);
		if (k > m)
			return;
		end
    X(:,1) = controlPoints(k-order+1:k, 1);
    Y(:,1) = controlPoints(k-order+1:k, 2);

    for i = 2:order
        for j = i:order
            num = t0-knotsFinal(k-order+j);
            if num == 0
                weight = 0;
            else
                s = knotsFinal(k+j-i+1)-knotsFinal(k-order+j);
                weight = num/s;
            end
            X(j,i) = (1-weight)*X(j-1,i-1) + weight*X(j,i-1);
            Y(j,i) = (1-weight)*Y(j-1,i-1) + weight*Y(j,i-1);
        end
    end
    val(cnt, 1) = X(order, order);
    val(cnt, 2) = Y(order, order);
end


