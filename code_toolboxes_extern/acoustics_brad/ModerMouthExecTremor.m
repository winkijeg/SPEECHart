function  [audn,ugn,t,r,tv,areas,lgths,fo,p] = ModerMouthExecTremor(q);
%Author: Brad Story
% TO BE IMPLEMENTED: Left/right asymmetry in displacement; Sentence-level
% speech; mucosal wave change, lung pressure, phase control, loading areas
% for words or sentences,
% INPUTS
% vow1 = initial vocal tract configuration where 1=/i/, 2 = /ih/, 3=/eh/, 4 = /ae/, 5 = /uh/, 6 = /ah/, 7 = /aw/, 8 = /o/, 9 = /ooh/, 10 = /u/
% vow2 = second vocal tract configuration; if vow2 = vow1 then you have a static vowel.
%     
% dxnew = length of each vocal tract section (there are 44 sections). Typically set this to 0.396825;
% Td = desired duration of the simulation (in seconds). 
% Tsvt = sampling period for the vocal tract movements. Default is Tsvt = 0.006866 s; this is an artifact of the sampling period of the 
% U. Wisc. x-ray microbeam data.
% fotarg = target Fo;
% fo: set to []
% amp: set to [];
% nc: set to [];
% nareas: set to [];
% mod_m: set to [];
% 
% x02 = adduction (in cm)  example: x02 = 0.1
% xib = bulging (in cm) example: xib = 0.1;
% aepi = minimum x-sect area in the epilarynx; example: aepi = 0.5;
% lepi = location of aepi (in number of sections NOT cm); example lepi = 3;
% npr = nodal point ratio (zn/T); ranges from 0 to 1; 0 is at the bottom (inf) of the folds and 1 is at the top; example npr = 0.75
% pgap = area of the posterior glottal gap.
%
% OUTPUTS
% 
% audn = normalized output acoustic pressure. Guaranteed to be sampled at 44100 Hz. This signal is suitable for writing to wav files.
%         TO LISTEN IN MATLAB
%         >> soundsc(audn,44100);
%         TO WRITE TO WAV FORMAT
%         >> wavwrite(audn,44100,16,'filename.wav');
%         
% ugn = normalized glottal flow. Guaranteed to be sampled at 44100 Hz. This signal is suitable for writing to wav files. Probably not be used much.
% 
% t = structure of parameters that was fed into the model. Probably not much to look at here except to verify parameter values.
% ...may want to look at t.x02_tm, t.ar_tm, t.F0_tm for time-varying inputs
% r = stucture of output signals
%         r.ug = true glottal flow
%         r.ga = true glottal area
%         r.pout = output pressure (audio signal, but in actual pressure units)
%         r.ps = true subglottal pressure
%         r.pg = intraglottal pressure - Yet to come!!!
%         
% tv = structure with info about the vocal tract model. Probably not of much interest.
% areas = time-varying area function produced during the simulation. If vow1=vow2, all area functions are the same.
%         To plot the first area function-
%         >>plot(areas(1,1:44))
%         To save the area function into another variable:
%         >>af1 = areas(1,1:44);
%         
% lgths = time-varying length. Probably not useful.
% fo = generated fo contour
% p = structure of model parameters.
%
%Example call with no external parameters:
%[audn,ugn,t,r,tv,areas,lgths,fo,p] = KVF(2,2,.396825,.5,110,[],[],[],[],[],.1,.1,.5,3,.85,0);



%------------------------------------------------------------------------
Tsvt = 0.006866;
Td = q.td;
dxnew = q.dxnew;
vow1 = q.vow1;
vow2 = q.vow2;
fotarg = q.fotarg;
nareas = q.areas;
nc = q.nqf;
mod_m = q.mod_m;
%nc = [];
%mod_m = [];
fo = [];
amp = [];



load static_params_bhs.mat; %based Story, Titze, and Hoffman (1996) area functions
%load static_params_bhs9602.mat;
%load static_params_mrm1.mat
%load static_params_mrmx.mat;
%load static_params_dm_norm.mat
%load static_params_mrf3.mat
%load d:/users/brad/mri/ua/SM/sm123_meandata.mat

%N = round(Td * 80);
N = round(Td * 1/Tsvt);

if(isempty(mod_m) == 0)
    stat.ne = stat.ne.*mod_m;
end


%--------Determine new sampling freq.-----------------
if(dxnew == 0.396825)
    Fs = 44100;
else
    Fs = round(35000/(2*dxnew));
end




if(isempty(nc) ==1)

    %  q1 = MovementTraj([1 round(.4*N)  round(.75*N)  N],[stat.coeff(1,vow1) stat.coeff(1,vow1)  stat.coeff(1,vow2) stat.coeff(1,vow2) ]);
    %  q2 = MovementTraj([1 round(.4*N)  round(.75*N)   N],[stat.coeff(2,vow1) stat.coeff(2,vow1) stat.coeff(2,vow2) stat.coeff(2,vow2) ]);

    if(vow1 > 0 && vow2 > 0)
        q1 = 1*MovementTraj([1 round(.4*N)  round(.75*N)   N],[stat.coeff(1,vow1) stat.coeff(1,vow1) 1*stat.coeff(1,vow2)  1*stat.coeff(1,vow2) ]);
        q2 = 1*MovementTraj([1 round(.4*N)  round(.75*N)   N],[stat.coeff(2,vow1) stat.coeff(2,vow1) stat.coeff(2,vow2)  stat.coeff(2,vow2) ]);
         
    elseif(vow1 > 0 && vow2 > 0 && q.areaflag == 'bvb---')
        
        q1 = 1*MovementTraj([1 round(.3*N) round(.5*N)  round(.75*N)  round(.85*N) N],[0.5*stat.coeff(1,vow1) stat.coeff(1,vow1) stat.coeff(1,vow1) 1*stat.coeff(1,vow2)  1*stat.coeff(1,vow2) 0.5*stat.coeff(2,vow1) ]);
        q2 = 1*MovementTraj([1 round(.3*N) round(.5*N)  round(.75*N)  round(.85*N) N],[0.5*stat.coeff(2,vow1) stat.coeff(2,vow1) stat.coeff(2,vow1) stat.coeff(2,vow2)  stat.coeff(2,vow2) 0.5*stat.coeff(2,vow1)]);
        
        
    elseif(vow1 > 0 && vow2 ==0)
        %q1 = 1*MovementTraj([1 round(.4*N)  round(.75*N)   N],[stat.coeff(1,vow1) stat.coeff(1,vow1) 0  0 ]);
        %q2 = 1*MovementTraj([1 round(.4*N)  round(.75*N)   N],[stat.coeff(2,vow1) stat.coeff(2,vow1) 0  0 ]);
        q1 = 1*MovementTraj([1   round(.85*N)   N],[stat.coeff(1,vow1) stat.coeff(1,vow1)   0 ]);
        q2 = 1*MovementTraj([1   round(.85*N)   N],[stat.coeff(2,vow1) stat.coeff(2,vow1)   0 ]);
    elseif(vow1 == 0 && vow2 > 0)
        q1 = 1*MovementTraj([1 round(.4*N)  round(.75*N)   N],[0 0 1*stat.coeff(1,vow2)  1*stat.coeff(1,vow2) ]);
        q2 = 1*MovementTraj([1 round(.4*N)  round(.75*N)   N],[0 0 stat.coeff(2,vow2)  stat.coeff(2,vow2) ]);
    elseif(vow1 == 0 && vow2 == 0)
        q1 = zeros(N,1);
        q2 = zeros(N,1);
    elseif(vow1 == vow2 && vow1 > 0)
        q1 = 1*MovementTraj([1 round(.75*N)  round(.90*N)   N],[stat.coeff(1,vow1) stat.coeff(1,vow1) 1*stat.coeff(1,vow2)  0.75*stat.coeff(1,vow2) ]);
        q2 = 1*MovementTraj([1 round(.75*N)  round(.90*N)   N],[stat.coeff(2,vow1) stat.coeff(2,vow1) stat.coeff(2,vow2)  0.75*stat.coeff(2,vow2) ]);
    end


else
   
    Ntmp = length(nc);
    tm = [0:1:Ntmp-1];
    tmn = [0:(Ntmp)/N:Ntmp-1];
    q1 = interp1(tm,nc(:,1),tmn)';
    q2 = interp1(tm,nc(:,2),tmn)';
    N = length(q1);

end

q1( q1 < min(stat.coeff(1,:)) ) = min(stat.coeff(1,:));
q1( q1 > max(stat.coeff(1,:)) ) = max(stat.coeff(1,:));
q2( q2 < min(stat.coeff(2,:)) ) = min(stat.coeff(2,:));
q2( q2 > max(stat.coeff(2,:)) ) = max(stat.coeff(2,:));

%----------Standard setup--------------------- 
ac1 = q.aepi;
ac2 = 0;
ac3 = 0.1;
lc1 = q.lepi;
lc2 = q.lphrx;
lc3 = 32;
rc1 = 6;
rc2 = 20;
rc3 = 4;
mc1 = 1;  % sc in new format
mc2 = 1;
mc3 = 0;
sc1 = 1; %mc in new format
sc2 = 1;
sc3 = 1;
pm = 0;



ZN = zeros(N,1);
ON = ones(N,1);




tv = tvStructGenerator(N);

tv.q = [q1 q2];
tv.lc = [lc1*ON lc2*ON lc3*ON];
tv.ac= [ac1*ON  ac2*ON ac3*ON];
tv.rc= [rc1*ON rc2*ON rc3*ON];
tv.sc= [sc1*ON sc2*ON sc3*ON];
tv.np= ZN;
tv.lg= ZN;
tv.lm= 44*ON;
tv.pg= ZN;
tv.rg= ON;
tv.pm= pm*ON;
tv.rm= ON;
tv.Fo = 120*ON;
tv.Vamp = 200*ON;
tv.Fsp = 80;
tv.N = N;

%---------Standard Setup------------------
if(q.lepi ==0)
    mc1 = 0;
end

if(q.lphrx ==0)
    mc2 = 0;
end

mc = MovementTraj([1 round(.4*N) round(.6*N) round(.8*N) N],[mc1 mc1 mc1 mc1 mc1 ]);
tv.mc(:,1) = mc;


%Modulation of the pharynx ----------------------------------
mc = MovementTraj([1  N],[mc2 mc2 ]);
if(mc2 > 0)
    mc = modulate_fo2(mc,1/Tsvt,q.PhrxModExt,q.PhrxModFreq)-1;
end
tv.mc(:,2) = mc;

%-------------------------------------------------------------
tv.mc(:,3) = 0*mc;
%----------------------------------------------------------

%Modulation of the length ----------------------------------
pm = MovementTraj([1  N],[0  pm  ]);
tv.pm(:,1) = pm;

%Nasalization ----------------------------
np = MovementTraj([1 round(0.35*N) round(0.75*N) N],[0.0 0. 0.0 0.0 ]);
tv.np(:,1) = np;
%---------------------------------------------

[areas,lgths] = TractBuilder(stat,tv);

tmp = isempty(nareas);

if(tmp == 0)
    foo = size(nareas);
    if(foo(1) == 1)
        if(foo(2) == 44)
            nareas(45) = 0;
        end
        for i=1:N
            areas(i,:) = nareas;
        end
    elseif(foo(2) == 1)
        if(foo(1) == 44)
            nareas(45) = 0;
        end
        nareas = nareas';

        for i=1:N
            areas(i,:) = nareas;
        end
    else
        areas = nareas;
    end
end

Nfo = ceil((N*Tsvt) * 2000);

if(isempty(fo) == 1)
    i = 1;
    
    %Question
    %fo = MovementTraj([1 round(.4*Nfo) round(.9*Nfo) Nfo],[1.3*fotarg(i) .9*fotarg(i)  2.*fotarg(i) 1.8*fotarg(i)]);
    %Lively statement
    %fo = MovementTraj([1 round(.4*Nfo)  Nfo],[.85*fotarg(i) 1.7*fotarg(i)  .70*fotarg(i)]);
    %monotone
    %fo = MovementTraj([1 round(.4*Nfo) round(.6*Nfo)  Nfo],[1.*fotarg(i) 1.*fotarg(i) 1*fotarg(i) 1*fotarg(i)]);

    if(q.F0contour == 1)
        fo = MovementTraj([1 round(.4*Nfo)  Nfo],[.85*fotarg(i) 1.2*fotarg(i)  .70*fotarg(i)]);
    elseif(q.F0contour == 2)
        fo = MovementTraj([1 round(.35*Nfo) round(.9*Nfo) Nfo],[.8*fotarg(i) .9*fotarg(i)  1.4*fotarg(i) 1.35*fotarg(i)]);
    else
        fo = MovementTraj([1 round(.4*Nfo) round(.6*Nfo)  Nfo],[1.*fotarg(i) 1.*fotarg(i) 1*fotarg(i) 1*fotarg(i)]);
    end
    
    
    
    if(q.FMext > 0)
        fo = modulate_fo2(fo,2000,q.FMext,q.FMfreq);
    end
    
end

tm = [0:1/2000:(length(fo)-1)/2000];
tmn = [0:1/Fs:tm(end)];
F0 = interp1(tm,fo,tmn);



%Nsim = ceil( (N/80) * Fs);
Nsim = length(F0);

load trach.mat
init_modermouth
p.PL = q.PL;
pl = p.PL*ones(Nsim,1);
tmp = round(.01*Nsim);
tmp2 = round(.1*Nsim);
pl(1:tmp) = focontour_cos(1000,p.PL,tmp)';
pl(end-tmp2+1:end) = focontour_cos(p.PL,1000,tmp2)';
if(q.AMext > 0)
    pl = modulate_fo2(pl,Fs,q.AMext,q.AMfreq);
end


% Time-varying adduction ------------------
%x02 = [0:length(F0)-1]'/length(F0) * 0.3;
%x02 = focontour_cos(0,0.2,Nsim)';

%x02tm = x02(1)*ones(Nsim,1);
tmp = round(.1*Nsim);
tmp2 = round(.1*Nsim);
%x02tm(1:tmp) = focontour_cos(0.3,x02(1),tmp)';
%x02tm(end-tmp2+1:end) = focontour_cos(x02(1),0.3,tmp2)';

%DO NOT CHANGE (copy or comment) - produces /h/ sound in "ohio"
%x02tm= MovementTraj([1 round(.2*Nsim) round(.35*Nsim) round(.5*Nsim) Nsim],[x02  x02 3*x02 x02 x02]);
x02 = q.x02r;
if(q.areaflag == 'ohio--');
    x02tm= MovementTraj([1 round(.2*Nsim) round(.35*Nsim) round(.5*Nsim) Nsim],[x02  x02 3*x02 x02 x02]);
elseif(q.areaflag == 'hawaii');
    x02tm= MovementTraj([1 round(.1*Nsim) round(.35*Nsim) round(.5*Nsim) Nsim],[3*x02  x02 x02 x02 x02]);
else
    x02tm= MovementTraj([1 round(.1*Nsim) round(.35*Nsim) round(.5*Nsim) Nsim],[x02  x02 x02 x02 x02]);
end

 
%x02tm= MovementTraj([1 round(.2*Nsim) round(.35*Nsim) round(.5*Nsim) Nsim],[x02  x02 x02 x02 x02]);
if(q.AdductModExt > 0)
    x02tm = modulate_fo2(x02tm,Fs,q.AdductModExt,q.AdductModFreq);
end

%Abduction for production of /p/
%x02tm= MovementTraj([1 round(.2*Nsim) round(.35*Nsim) round(.5*Nsim)  round(.65*Nsim) Nsim],[x02  x02 x02+.6 x02+.6 x02 x02]);
%-----------------------------------------

%----Modulate F0 contour based on PL--------- at 3 Hz/cmH20

F0 = F0 + (q.HzpercmH20/980)*(pl'-p.PL);

%-----------------------------------------------------%


p.x02R = q.x02r;
p.x02L = q.x02l;
c.xibR = q.xibr;
c.xibL = q.xibr;
c.asym = q.asym;
c.phi0R = q.phi0R;
c.phi0L = q.phi0L;
%c.R = q.npr;
c.npR = q.npr;
c.npL = q.npl;
c.pgap = q.pgap;
%t.vox = vox;
t.PL_tm = pl';
t.Fo_tm = F0';
t.x02_tm = x02tm';
%t.Fo_tm = 128*ones(Nsim,1);
t.ar_tm = areas(:,1:45);
t.Fs = Fs;
t.VS = 4;
%t.VS = 1;
%t.yw = 0;
[p, r, t] = ModerMouth(p,c,t,Nsim);

aud = r.pout + r.foo*0.1;
%aud = r.pout;
r.ga = r.ad;

%--------Resample--------------

if(Fs ~= 44100)
    told = [0:1/Fs:(length(aud)-1)/Fs];
    tnew = [0:1/44100:told(end)];
    audn = spline(told,aud,tnew);
    ugn = spline(told,r.ug,tnew);
else
    audn = aud;
    ugn = r.ug;
end;


d = fir1(500,6000/(44100/2));
audn = filtfilt(d,1,audn);
%audn = fade(audn,.05,44100);
audn = .7*audn/max(abs(audn));

ugn = filtfilt(d,1,ugn);
%ugn = fade(ugn,.05,44100);
ugn = .7*ugn/max(abs(ugn));

lgths = dxnew*lgths;
