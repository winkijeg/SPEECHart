function [Lvectnew,Q,a,b] = LengthChanger(pg, Lg, rg, pm, Lm, rm, x);
%Author: Brad Story
%
%INPUTS
%pg = Length of larynx lowering(-Lg) or raising(+Lg)
%Lg = location along the x-axis where the length change is centered - if pglot=x(1) the maximum length change occurs at the glottis
%rg = extent along the x-axis of the larynx lowering/raising
%pm = Length of lip spreading(retraction)(-Lp)/rounding(protrusion)(+Lp)
%lm = location along the x-axis where the length change is centered - if plip=x(end) the maximum length change occurs at the lips
%rm = extent along the x-axis of the lip spreading/rounding
%Lvect = vector of lengths corresponding to each area cross-section

% x = EITHER a vector of equal lengths (e.g. x = 0.396825*ones(44,1) ) or a
% vector of cumulative length e.g. x = [.396825:.396825:44*.396825];
% The initial "if" statement assume that if x(end) > 6, then you must be 
% sending in a cumulative length, otherwise the assumption is an equal
% length vector.

%example call:
% x = 0.396825*ones(44,1); 
% Lengthen the lip end of vocal tract by 2 cm,  
% Settings: Lg=0,pg=0,rg=1 (Setting Lg =0 says that we are not going lengthen or shorten at the glottal end
% Lm = 2, pm = 17.5 (end of the tract), rm = 4 cm (spread the lengthening out over 4 cm of the original tract length,
% [Lvectnew,Q,a,b] = LengthChanger(Lg, pg, rg, Lm, pm, rm, x);
% [Lvectnew,Q,a,b] = LengthChanger(0,0,1,2,17.5,4,x);
% Now Lvectnew is the new vector of lengths
% xnew = make_lengthv(Lvectnew) with create a new cumulative length vector
% for plotting purposes.
% Q, a, b  are intermediate steps that sometimes are useful.  Mostly can be
% ignored.


%another example call:
% Lengthen a portion of the mouth cavity by 2.5 cm but not at the lips  
% Settings: Lg=0,pg=0,rg=1 (Setting Lg =0 says that we are not going lengthen or shorten at the glottal end
% Lm = 2.5, pm = 12.5 (end of the tract), rm = 5 cm (spread the lengthening out over 5 cm of the original tract length,
% [Lvectnew,Q,a,b] = LengthChanger(Lg, pg, rg, Lm, pm, rm, x);
% [Lvectnew,Q,a,b] = LengthChanger(0,0,1,2.5,12.5,5,x);
% Now Lvectnew is the new vector of lengths


if(x(end) > 6.0)

%------Create the length vector ----------------------------------
%assume that the x-vectors are in the form x = [dx1, dx1+dx2, dx1+dx2+d3, .....]
%then [x(1) diff(x)] = [dx1, dx1+dx2-dx1, dx1+dx2+d3-(dx1+dx2), ...] = [dx1, dx2, dx3, ...]
Lvect = [x(1) diff(x)];
dx = Lvect(1);  %Now I'm assuming equal dx's

else
    Lvect = x;
    dx = Lvect(1);
    x = make_lengthv(x);
end;



if(pg < dx)
    Lg = x(1);
end;

if(pm > x(end))
    Lm = x(end);
end;


A = 2*log(10000);  %rglot and rlip will specify range based on 1 to 0.01 
dx = 0.396825;

K_Brad = 1/(sum((exp(-A*((x-Lg)/rg).^2)))*dx);
alpha = 1 + (K_Brad*pg*exp(-A*((x-Lg)/rg).^2));

if(min(alpha)<=0)
    disp('specified range cannot accomodate requested shortening');
end


K_Brad = 1/(sum((exp(-A*((x-Lm)/rm).^2)))*dx);
beta = 1 + (K_Brad*pm*exp(-A*((x-Lm)/rm).^2));

if(min(beta)<=0)
    disp('specified range cannot accomodate requested shortening');
end

Q = alpha.*beta;
a = alpha;
b = beta;
Lvectnew = Lvect.*Q;
%Lvectnew = Lvect.*Q;