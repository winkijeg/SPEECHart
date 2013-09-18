function [af,V,Ct,Lvectnew,xnew] = TubeTalker(x,phi,ne,ft,q,lc,ac,mc,rc,sc,np,pg,lg,rg,pm,lm,rm);
%Author: Brad Story, 
%see Story, B.H., (2005).  A parametric model of the vocal tract area function for vowel and consonant simulation, 
%J. Acoust. Soc. Am., 117(5), 3231-3254.
%
%x = vector for the x-axis of the area function
%N = number of modes to use
%phi = mode matrix phi(:,1:N)
%q = model coefficients q(1:N);
%ne = mean(neutral) DIAMETER function
%lc = location of constriction - can be a vector
%dc = degree of constriction
%ac = area of the constriction location, (negative values will spread (squash) the constriction - can be a vector
%rc = extent along the x-axis of the constriction - can be a vector
%np = nasal port area (in cm2)
%sc = skewing quotient for consonant overlays, rc = range, zc = rc1/rc2 where rc1 = descent to min, 
% and rc2 = ascent to 1,  if zc = 1 then no skew;
%mc = magnitude of the constriction
%gammalp = lip protrusion
%gammalx = lip raising
%ft = function type - character string - if 'c' then cosine, if 'g' then gaussian
%pg = Length of larynx lowering(-Lg) or raising(+Lg)
%Lg = location along the x-axis where the length change is centered - if pglot=x(1) the maximum length change occurs at the glottis
%rg = extent along the x-axis of the larynx lowering/raising
%pm = Length of lip spreading(retraction)(-Lp)/rounding(protrusion)(+Lp)
%lm = location along the x-axis where the length change is centered - if plip=x(end) the maximum length change occurs at the lips
%rm = extent along the x-axis of the lip spreading/rounding
%Lvect = vector of lengths corresponding to each area cross-section

%example calls:
%the first is a call with a single constriction
%[af,V,Ct,Lvectnew,xnew] = vtkmodel(stat.x,stat.phi,stat.ne,stat.ft,[4 0],dx*44,0,1,2,1,0,0,0,4,0,17.5,4);
%the second is a call with two constrictions
%[af,V,Ct,Lvectnew,xnew] = vtkmodel(stat.x,stat.phi,stat.ne,stat.ft,[4 0],dx*[44 38],[0 .1],[1 1],[2 2],[1 1],0,0,0,4,0,17.5,4);
%note: the LENGTH of lc, ac, rc, zc, and sc must be the same!


%A note on plotting the area function correctly with stairs:
%x must be in this form:  x = [dx1, dx1+dx2, dx1+dx2+d3, .....] NOT x = [0, dx1, dx1+dx2, .....]
% clf
% hold
% plot(x,af,'-ob');
% stairs(x-x(1),af,'r');
% stairs([x-x(1);x(end)],[af;af(end)],'r');
%
%This produces a plot where the tubes extend from 0 to VTL

%minA = 0.2;
minA = 0.05;

%------Create the vowel substrate ( V(x) ) -----------------------

V = zeros(length(x),1);
N = length(q);

for i=1:N
    V = q(i)*phi(:,i) + V; 
end
V = (pi/4)*(V+ne).^2;

[i,j]=find(V<minA);
V(i(i>7)) = minA;



%-------Create consonant overlay ------------------------

dx = x(2)-x(1);

Ct = ones(length(x),1);

for i=1:length(lc)
    
    if(lc(i) > x(end))
        lc(i) = x(end);
    elseif(lc(i) < x(1))
        lc(i) = x(1);
    end;
    
    nlc = round(lc(i)/dx);
    dc(i) = 1 - ( ac(i)/V(nlc) );
    
   
    %skewing quotient for consonant overlays, rc = range, sc = rc1/rc2 where rc1 = descent to min, 
    % and rc2 = ascent to 1,  if sc = 1 then no skew;
    
    if(ft == 'c' )
        %c = ccosine(x,dc(i)*mc(i),lc(i),rc(i))';
        c = ccosine_skew(x,mc(i),dc(i),lc(i),rc(i),sc(i))';
        c(c<0) = 0;
        C(:,i) = c;
       
    elseif(ft == 'g' )
        %c = cgauss(x,dc(i)*mc(i),lc(i),rc(i))';
       
        c = cgauss_skew(x,mc(i),dc(i),lc(i),rc(i),sc(i))';
        c(c<0) = 0;
        C(:,i) = c;
        
    end
    

   Ct = C(:,i).*Ct;
    
    
end;

%------Generate the complete area function ---------------

af = V.*Ct;


%------ Length Changes-----------------------

% 
% [Lvectnew,Q,a,b] = LengthChanger(Lg,pg,rg,Lm,pm,rm,x);
% xnew = make_lengthv(Lvectnew);

if(abs(pg) > 0 | abs(pm) > 0)
[Lvectnew,Q,a,b] = LengthChanger(pg,lg,rg,pm,lm,rm,x);
xnew = make_lengthv(Lvectnew);
else
    Lvectnew  = [x(1) diff(x)];
    xnew = x;
end;
