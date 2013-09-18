function [c,c1,c2] = ccosine_skew(x,sc,dc,lc,rc,qs);
%Author: Brad Story
%

dx = x(2)-x(1);

rc2 = rc/(1+qs);
rc1 = qs*rc2;

rc2 = 2*rc2; 
rc1 = rc1*2;

if(dx ~= 1)
    xn = x/dx;
    lc = floor(lc/dx);
    rc1 = floor(rc1/dx);
    rc2 = floor(rc2/dx);
else
    xn = x;
end;


tc = sc*dc;
%-----------------Function 1------------------------------
a = floor(lc-rc1);
b = floor(lc+rc1);
if(b > length(x)) 
    b = length(x);
end;


c1 = ones(1,length(xn));
xp = [a:1:b];

theta = pi*( (1/rc1)*(xp-lc)+1 );
c1(a:b) = 1+ (tc/2)*(cos(theta)-1);


%-----------------Function 2------------------------------
a = floor(lc-rc2);
b = floor(lc+rc2);
if(b > length(x)) 
    b = length(x);
end;


c2 = ones(1,length(xn));
xp = [a:1:b];

theta = pi*( (1/rc2)*(xp-lc)+1 );
c2(a:b) = 1+ (tc/2)*(cos(theta)-1);

%----------------------Composite function -------------------



c = c1;
c(lc:end) = c2(lc:end);
c = max(c,1-dc);



