function K = calculate_K(r, s, XY, lambda2, mu2, pfix)
% ...

global IX;
global IY;
global IA;
global IB;
global IC;
global ID;
global IE;

x = XY(IX);
y = XY(IY);

dpsidr = 0.25 * [s-1, 1-s, -1-s, 1+s];
dpsids = 0.25 * [r-1, -1-r, 1-r, 1+r];

detJ = (dpsidr*x)*(dpsids*y) - (dpsids*x)*(dpsidr*y);
dpsidx = (dpsids*y)*dpsidr - (dpsidr*y)*dpsids;
dpsidy = (dpsidr*x)*dpsids - (dpsids*x)*dpsidr;
dpsi = [dpsidx, dpsidy, 0];

if pfix == 0
    
    IAfix = IA;
    IDfix = ID;
    
elseif pfix == 1
    
    IAfix = [9*ones(1,16), IA(17:32), 9*ones(1,16), IA(49:64)];
    IDfix = [9*ones(1,16), ID(17:32), 9*ones(1,16), ID(49:64)];
    
elseif pfix == 2
    
    IAfix = [IA(1:16), 9*ones(1,16), IA(33:64)];
    IDfix = [ID(1:16), 9*ones(1,16), ID(33:64)];
    
end

A = dpsi(IAfix);
B = dpsi(IB);
C = dpsi(IC);
D = dpsi(IDfix);
E = dpsi(IE);

K = (1/abs(detJ)) * (A.*(lambda2*B+2*mu2*C)+mu2*D.*E);

end
