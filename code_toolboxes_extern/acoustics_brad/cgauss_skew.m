function c = cgauss_skew(x,mc,dc,lc,rc,qs);
%Author: Brad Story
%

dx = mean(diff(x)); 

%2*log(4) = 2.7725 for width at the "half power" point, 18 for width at 3 standard deviations
A = 2*log(4);
rc2 = rc/(1+qs);
rc1 = qs*rc/(1+qs);


c1 = 1-mc*dc*exp((-A)*((x-lc)/(2*rc1)).^2);
c2 = 1-mc*dc*exp((-A)*((x-lc)/(2*rc2)).^2);

[i,xc1] = min(c1);
[i,xc2] = min(c2);

if(xc1 == xc2)
    c = c1;
    c(xc2:end) = c2(xc2:end);
    c = max(c,0);
    
else
    disp('Something is amiss! xc1~=xc2');
    c = 0*x;
end




