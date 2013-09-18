function resfreq = tuber(mylength, mytype, lb, lc)
% TUBER Calculate 1/2, 1/4 and Helmholtz tube resonances
% function resfreq = tuber(mylength, mytype, lb, lc);
% tuber: Version 10.10.07
%
%   Syntax
%       If two input args, mytype distinguishes half vs. quarter-wave
%           and (currently) first five resonances are returned
%           mylength: Tube length in cm. Can be a vector (to generate
%           nomograms)
%           mytype: 1 for quarter wavelength, 2 for half
%       If four input args calculate Helmholtz resonance with
%           mylength and mytype treated as area of body and area of
%           constriction, respectively. lb and lc are length of body and
%           constriction
%           Any of the four input arguments can then be a vector, and all
%           combinations of lengths are returned (probably easier to understand
%           result if only one argument at a time is a vector (outer to inner
%           loop for combinations in the order ab, ac, lb, lc))

resfreq=[];

%speed of sound
c=35000;


nlength=length(mylength);

if nargin==2
nres=5;
resvec=1:nres;
    if mytype==1
        resfreq=ones(nlength,nres)*NaN;
        for ili=1:nlength
            resfreq(ili,:)=(((2*resvec)-1)*c)/(4*mylength(ili));
        end;
        
    end;
    
    if mytype==2
        resfreq=ones(nlength,nres)*NaN;
        for ili=1:nlength
            resfreq(ili,:)=(resvec*c)/(2*mylength(ili));
        end;
    end;
    
end;
if nargin==4
nres=1;
    ab=mylength;
    ac=mytype;
    
    nab=length(ab);
    nac=length(ac);
    nlb=length(lb);
    nlc=length(lc);
    
    nall=nab*nac*nlb*nlc;
    
    resfreq=ones(nall,nres)*NaN;
    ipi=1;
    for iab=1:nab
        for iac=1:nac
            for ilb=1:nlb
                for ilc=1:nlc
                    resfreq(ipi,:)=(c/(2*pi))*sqrt(ac(iac)/(ab(iab)*lb(ilb)*lc(ilc)));
                    ipi=ipi+1;
                end;
            end;
        end;
    end;
    
end;

if isempty(resfreq) 
    disp('no resonance calculation possible');
    help tuber;
end;
