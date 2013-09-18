function [areas,lgths] = TractBuilder(stat,tv);
%Author: Brad Story
%
%stat = structure of static vectors: x, phi, ne, ft
%tv = structure of time-varying parameters: q,lc,sc,ac,rc,np,Lg,rglot,Lp,rlip

NS = length(stat.ne);

for n=1:length(tv.mc)
    
    %[af,V,C,Lvectnew,xnew] = TubeTalker(stat.x,stat.phi,stat.ne,stat.ft,tv.q(n,:),tv.lc(n,:),tv.ac(n,:),tv.mc(n,:),tv.rc(n,:),tv.sc(n,:),tv.np(n),tv.pg(n),tv.lg(n),tv.rg(n),tv.pm(n),tv.lm(n),tv.rm(n));
                                                            
     %[af,V,C,Lvectnew,xnew] = TubeTalker(stat.x,stat.phi,stat.ne,stat.ft,tv.q(n,:),tv.lc(n,:),tv.ac(n,:),tv.mc(n,:),tv.rc(n,:),tv.sc(n,:),tv.np(n),tv.pg(n),tv.Lg(n),tv.rg(n),tv.pm(n),tv.lm(n),tv.rm(n));
     [af,V,C,Lvectnew,xnew] = TubeTalker([1:44],stat.phi,stat.ne,stat.ft,tv.q(n,:),tv.lc(n,:),tv.ac(n,:),tv.mc(n,:),tv.rc(n,:),tv.sc(n,:),tv.np(n),tv.pg(n),tv.lg(n),tv.rg(n),tv.pm(n),tv.lm(n),tv.rm(n));
                                                            

  
    areas(n,1:NS) = af';
    areas(n,NS+1) = tv.np(n);
    lgths(n,1:NS) = Lvectnew;
end;

