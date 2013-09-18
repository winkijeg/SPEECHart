function [myfo,mybwo,mysoundo] = vt2fbws(areafile)
% VT2FBWS Calculate formants, bandwidths and spectrum from vocal tract area function
% function [myf,mybw,mysound] = vt2fbws(areafile);
% vt2fbws: Version 30.10.07
%
%   Description
%       Uses tractsondhi to get transfer function of areafunction
%       Then uses invfreqz to get filter coefficients to synthesize speech signal
%       Matlab function roots is then used to obtain formants and bandwidths
%       from the filter coeffiecients
%       The initial value of the area function can be set in the following
%       ways:
%           If there is no input argument, neutral tube with length 17.5 cm, 35
%               sections, and constant area of 6cm2 is used
%           If the input argument is a string, areafile should specify the name of a mat file 
%               This must contain a vector called areadata and
%               a vector called dLen (containing area in cm2 and length in cm of each section, respectively)
%           If the input argument is numeric, with two columns
%               If it has 1 row (i.e a 2-element vector) this is interpreted as
%                   [tractlength number_of_sections].
%               If it has more than 1 rows
%                   then column 1 corresponds to areadata and column 2 to
%                   dLen when the data is read from a file
%       Note that tractsondhi uses 35000cm/s for speed of sound.
%       Output arguments are optional (return formants, bandwidths and sound for last area function used)
%       After the initial area function has been loaded it can then be manipulated interactively, 
%       and the results of successive manipulations can be displayed as a nomogram
%       See the instruction displayed by the program for further help.
%
%   See Also
%       TRACTSONDHI_PH, GLOTLF, INVFREQZ, ROOTS, TUBER

%set up diary outside program
diaryused=0;



samplerate=10000;		%where to get this from
slen=0.5;
f0=110;
f0end=f0-(f0*.1);
fuse=5;

defaultarea=6;

nsec=35;			%for resonanzverschieber
normlength=17.5;

areadata=ones(nsec,1)*defaultarea;
dLen=ones(nsec,1)*(normlength/nsec);

fileused=0;
if nargin
    if ischar(areafile)
        load(areafile);
        fileused=1;
        if diaryused diary on; end;
        disp(areafile);
        if diaryused diary off; end;
    else
        if size(areafile,2)==2
            if size(areafile,1)==1
                normlength=areafile(1);
                nsec=areafile(2);
                areadata=ones(nsec,1)*defaultarea;
                dLen=ones(nsec,1)*(normlength/nsec);
            else
                areadata=areafile(:,1);
                dLen=areafile(:,2);
            end;        %rows in areafile
        end;            %cols in areafile
    end;            %area file is char
    
    
end;

nsec=length(areadata);
secpos=cumsum(dLen);

if size(areadata,1)==1 areadata=areadata'; end;
if size(secpos,1)==1 secpos=secpos'; end;

if length(areadata)~=length(secpos)
    disp('Length of area data and section lengths does not match');
    keyboard;
    return;
end;


%figure for area function
ha=axes;
hf1=gcf;
%room for ui controls at bottom
mypos=get(ha,'position');
mypos([2 4])=[0.3 0.6];
set(ha,'position',mypos);
set(gca,'xlim',[0 secpos(end)+1],'ylim',[0 max(areadata)*1.25]);
xlabel('Distance from glottis (cm)');ylabel('Area (cm)');
grid on;

[plotx,ploty]=makeafgraph(areadata,secpos);

hlaf=line('xdata',plotx,'ydata',ploty,'linewidth',2,'tag','areafunction','color','r','hittest','off');

%permanent ref line not used as not possible to click on
%hlafref=line('xdata',secpos,'ydata',areadata,'linewidth',1,'tag','ref_area','color','g','linestyle','none','marker','x');

set(gca,'buttondownfcn',@vt2fbws_cb);
myS.selectiontype=[];
myS.lastpoint=[0 0];
myS.areadata_restore=areadata;
myS.sectionposition_restore=secpos;
myS.constriction_length=1;
myS.snap_area=0.25;			%also acts as minimum area

myS.areadata=areadata;
myS.sectionposition=secpos;


set(hlaf,'userdata',myS);

areadata_org=areadata;
secpos_org=secpos;


%figure for frequency response function
hf2=figure;
ha2=axes;
%set(ha,'position',[0.25 0.3 0.6 0.6]);
xlabel('HZ');ylabel('dB');
grid on;
set(gca,'xlim',[0 samplerate/2],'ylim',[-60 0]);

hlresp1=line('xdata',[0;1],'ydata',[0;1],'linewidth',2,'tag','response_sondhi','color','r');
hlresp2=line('xdata',[0;1],'ydata',[0;1],'linewidth',2,'tag','response_match','color','g');

for ifi=1:fuse
    hlfor(ifi)=line('xdata',[0;1],'ydata',[0;1],'linewidth',2,'tag',['formant' int2str(ifi)],'color','m');
    hlbw(ifi)=line('xdata',[0;1],'ydata',[0;1],'linewidth',2,'tag',['bandwidth' int2str(ifi)],'color','m');
end;



title('red=tractsondhi, green=impfreqz match');

%figure for nomogram
nomon=2*length(areadata);
hf3=figure;
ha3=axes;

tmpy=ones(nomon,1)*NaN;
tmpx=tmpy;
tmpz=tmpy;

collist='rgbcmy';
for ifi=1:fuse
    hlforn(ifi)=line('xdata',tmpx,'ydata',tmpy,'zdata',tmpz,'linewidth',2,'tag',['formantn' int2str(ifi)],'color',collist(ifi));
    hlbwn1(ifi)=line('xdata',tmpx,'ydata',tmpy,'zdata',tmpz,'linewidth',2,'tag',['bandwidthnp' int2str(ifi)],'color',collist(ifi),'linestyle','none','marker','o');
    hlbwn2(ifi)=line('xdata',tmpx,'ydata',tmpy,'zdata',tmpz,'linewidth',2,'tag',['bandwidthnm' int2str(ifi)],'color',collist(ifi),'linestyle','none','marker','o');
end;

%set([hlforn;hlbwn1;hlbwn2],'erasemode','xor');

ylabel('Hz');
set(gca,'ylim',[0 samplerate/2]);
grid on;

set(gca,'xlim',[0 secpos(end)+1],'zlim',[0 max(areadata)*1.25]);
xlabel('Constriction position (cm)');zlabel('Constriction size (cm)');

nomocnt=1;

%uicontrols

figure(hf1);
uiinc=10;

hutt=uicontrol('style','text','string','Sections');

fixuisize(hutt,uiinc);


hut=uicontrol('style','edit','string','0000');

fixuisize(hut,uiinc);
fixuipos(hut,hutt,uiinc);

set(hut,'string','1');


hub=uicontrol('style','pushbutton','string','Add to nomogram','callback','set(gcbo,''userdata'',1)');
fixuisize(hub,uiinc);
fixuipos(hub,hut,uiinc);

set(hub,'userdata',0);

hubr=uicontrol('style','pushbutton','string','Reference area','callback','set(gcbo,''userdata'',1)');
fixuisize(hubr,uiinc);
fixuipos(hubr,hub,uiinc);

set(hubr,'userdata',0);

tmpp1=get(hub,'position');
hubrn=uicontrol('style','pushbutton','string','Reset nomogram','callback','set(gcbo,''userdata'',1)');
fixuisize(hubrn,uiinc);

tmpp2=get(hubrn,'position');
tmpp2(1)=tmpp1(1);
tmpp2(2)=tmpp1(2)+tmpp1(4)+uiinc;
set(hubrn,'position',tmpp2);


set(hubrn,'userdata',0);

hubra=uicontrol('style','pushbutton','string','Reset area','callback','set(gcbo,''userdata'',1)');
fixuisize(hubra,uiinc);
fixuipos(hubra,hubrn,uiinc);

set(hubra,'userdata',0);


hubp=uicontrol('style','pushbutton','string','Pause','callback','set(gcbo,''userdata'',1)');
fixuisize(hubp,uiinc);
fixuipos(hubp,hubr,uiinc);


set(hubp,'userdata',0);

hubs=uicontrol('style','pushbutton','string','Stop','callback','set(gcbo,''userdata'',1)');
fixuisize(hubs,uiinc);
fixuipos(hubs,hubp,uiinc);


set(hubs,'userdata',0);


set([hf1 hf2 hf3],'units','normalized');

set(hf1,'position',[0.05 0.4 0.5 0.5]);
set(hf2,'position',[0.6 0.5 0.3 0.3]);
set(hf3,'position',[0.6 0.1 0.3 0.3]);


disp('Change area function by clicking at location of desired new value');
disp('Left mouse button for incremental changes');
disp('Right mouse button for single changes to the reference area');
disp('At program start the reference area is simply the neutral tube');
disp('By pressing the reference area button the currently displayed area function becomes the reference area');
disp('The number of sections given in the sections edit box determines how many sections are changed at each mouse click');
disp('When the add to nomogram button is pressed the program tries to estimate the location of the the main constriction');
disp('in the area function, and plots the current formants and bandwidths as a function of this position in figure 3');
disp('Type any key to continue');

pause;
%keyboard;

lastf=zeros(fuse,1);

tic;
alldone=0;
while ~alldone
    
    dokeyboard=get(hubp,'userdata');
    if dokeyboard
        disp('Pause: Type return to exit from keyboard mode');
        keyboard;
        set(hubp,'userdata',0);
    end;
    
    alldone=get(hubs,'userdata');
    
    myS=get(hlaf,'userdata');
    areadata=myS.areadata;
    
    secs=get(hut,'string');
    nsec=str2num(secs);
    nsec=max([nsec 1]);
    nsec=min([nsec length(areadata)]);
    set(hut,'string',int2str(nsec));
    
    myS.constriction_length=nsec;
    
    set(hlaf,'userdata',myS);
    
    
    if get(hubr,'userdata')
        myS.areadata_restore=areadata;
        sectmp=myS.sectionposition;
        myS.sectionposition_restore=sectmp;
        
        set(hlaf,'userdata',myS);
        %      set(hlafref,'xdata',sectmp,'ydata',areadata);
        
        set(hubr,'userdata',0);
    end;
    
    if get(hubra,'userdata')
        myS.areadata_restore=areadata_org;
        myS.sectionposition_restore=secpos_org;
               myS.areadata=areadata_org;
               myS.sectionposition=secpos_org;

        [plotx,ploty]=makeafgraph(areadata_org,secpos_org);
        set(hlaf,'userdata',myS,'xdata',plotx,'ydata',ploty);
        %      set(hlafref,'xdata',sectmp,'ydata',areadata);
        
        set(hubra,'userdata',0);
    end;
    
    
    %modified version of tractsondhi that also returns the complex spectrum
    [impa,H]=tractsondhi_ph(length(areadata),areadata,dLen);
    
    nb=0;
    % to get a good match we need a few more than the lpc rule of thumb
    % of samplerate in kHz plus a couple for overall shape
    na=round(samplerate/1000)*2;
    
    [b,a]=invfreqz(H,linspace(0,pi,length(H)),nb,na);
    
    
    %check the frequency response
    
    [hh,ff]=freqz(b,a,length(impa),samplerate);
    
    set(hlresp1,'xdata',ff,'ydata',impa-max(impa));
    hhh=20*log10(abs(hh));
    set(hlresp2,'xdata',ff,'ydata',hhh-max(hhh));
    drawnow;
    
    %simple excitation
    %x=zeros(samplerate*slen,1);
    
    %pp=round(samplerate/f0);
    
    %x(1:pp:end)=1;
    
    % Benutzung der Fantglottis:	
    %ncyc=100;
    %period=100;
    %t=0:1/period:ncyc;
    %u_g=glotlf(1,t); % glottaler Volumenstrom
    
    
    % Benutzung der Fantglottis:	
    
    f0ref=mean([f0;f0end]);
    
    
    
    ncyc=round(f0ref*slen);
    %simple series of f0 values
    f0v=linspace(f0,f0end,ncyc);
    %convert f0 series to series of excitation time instants
    exv=cumsum(1./f0v);
    %calculate perturbation value for these time instants
    %this implements the suggestion in Klatt and Klatt, as an alternative to simple
    %random jitter
    
    kflutter=25;
    fluttersig=sin(2*pi*12.7*exv)+sin(2*pi*7.1*exv)+sin(2*pi*4.7*exv);
    df0=(kflutter/50).*(f0v/100).*fluttersig;
    %   keyboard;
    
    f0v=f0v+df0;
    
    %   keyboard;
    impint=round(samplerate./f0v);
    t=[];
    for ipi=1:ncyc
        tt=0:1/impint(ipi):1;
        tt(end)=[];
        t=[t tt];
    end;
    
    flowd=1;   
    %t=0:1/impint:ncyc;
    x=glotlf(flowd,t); % glottaler Volumenstrom
    %plot(t,u_g)
    
    
    
    
    %plot(t,u_g)
    
    %soundsc(u_g,samplerate);
    %keyboard;
    
    
    
    %mysound=filter(b,a,x);
    mysoundx=filter(b,a,x);
    
    myroots=roots(a);
    
    myf=angle(myroots)*(samplerate/(2*pi));
    mybw=-log(abs(myroots))*(samplerate/pi);
    
    myf2=myf;
    mybw2=mybw;
    
    
    %rough elimination of useless data
    %Also eliminates the complex conjugate versions of the poles (they have negative frequencies)
    flim=100;		%lower frequency limit
    blim=1000;		%upper limit on bandwidth
    vv=find((myf<flim)|(mybw>blim));
    myf(vv)=NaN;
    mybw(vv)=NaN;
    
    %sort by bandwidth
    
    [mybw,sortindex]=sort(mybw);
    myf=myf(sortindex);
    %keep resonances with smallest bandwidths
    %may need to be more sophisticated
    myf=myf(1:fuse);
    mybw=mybw(1:fuse);
    
    %then sort by frequency
    [myf,sortindex]=sort(myf);
    
    mybw=mybw(sortindex);
    
    if any(myf~=lastf)
        if diaryused diary on; end; 
        disp(['Formants: ' int2str(round(myf')) ' BW: ' int2str(round(mybw'))]);
        if diaryused diary off; end; 
        
    end;
    lastf=myf;
    
    mylim=get(ha2,'ylim');
    for ifi=1:fuse
        set(hlfor(ifi),'xdata',[myf(ifi);myf(ifi)],'ydata',mylim');
        set(hlbw(ifi),'xdata',[myf(ifi)-mybw(ifi);myf(ifi)+mybw(ifi)],'ydata',[mean(mylim);mean(mylim)]);
    end;
    drawnow;
    
    donomo=get(hub,'userdata');
    if donomo
        lastp=myS.lastpoint;
        for ifi=1:fuse
            tmpf=get(hlforn(ifi),'ydata');
            tmpx=get(hlforn(ifi),'xdata');
            tmpz=get(hlforn(ifi),'zdata');
            tmpf(nomocnt)=myf(ifi);
            tmpx(nomocnt)=lastp(1);
            tmpz(nomocnt)=lastp(2);
            set(hlforn(ifi),'ydata',tmpf,'xdata',tmpx,'zdata',tmpz);
            tmpbw=get(hlbwn1(ifi),'ydata');
            tmpbw(nomocnt)=myf(ifi)+mybw(ifi)/1;
            set(hlbwn1(ifi),'ydata',tmpbw,'xdata',tmpx,'zdata',tmpz);
            tmpbw=get(hlbwn2(ifi),'ydata');
            tmpbw(nomocnt)=myf(ifi)-mybw(ifi)/1;
            set(hlbwn2(ifi),'ydata',tmpbw,'xdata',tmpx,'zdata',tmpz);
        end;
        nomocnt=nomocnt+1;
        if nomocnt>nomon 
            disp('Nomogram index reset to 1; type return to continue');
            keyboard;
            nomocnt=1;
        end;
        set(hub,'userdata',0);
        drawnow;
    end;
    
    if get(hubrn,'userdata')
        disp('Nomogram will be reset; type return to continue');
        keyboard;
        tmp=ones(nomon,1)*NaN;
        set(hlforn,'xdata',tmp,'ydata',tmp,'zdata',tmp);
        set(hlbwn1,'xdata',tmp,'ydata',tmp,'zdata',tmp);
        set(hlbwn2,'xdata',tmp,'ydata',tmp,'zdata',tmp);
        nomocnt=1;
        set(hubrn,'userdata',0);
    end;
    
    
    
    
    mytoc=toc;
    mypause=slen-mytoc;
    mypause=max([mypause;0]);
    %XP crashes without extra pause
    pause(mypause+0.1);
    
    mycomputer=computer;
    myabs=max(abs(mysoundx));
    myabs=max([myabs 10*eps]);
    
    if strcmp(mycomputer,'LNX86')
        %not too loud
        soundtmp=mysoundx*(8000./myabs);
        pause(0.25);		%linux keeds extra pause to complete previous output
        au(soundtmp,samplerate);
    else
        
        %note mysound is safe version of soundsc (won't crash if soundcard busy)   
        soundsc(mysoundx,samplerate);
        if fileused
            wavfile=strrep(areafile,'.mat','');
            wavfile=[wavfile '_sound'];
            %      disp(wavfile);
            wavwrite((mysoundx/myabs)*0.9,samplerate,16,wavfile);
        end;
        
        
    end;
    
    tic;
    %keyboard;
    
    
    
end;		%main loop

%disp('Type return to exit');
%keyboard

if nargout
    myfo=myf;
    mybwo=mybw;
    mysoundo=mysoundx;
end;

delete([hf1 hf2 hf3]);

function vt2fbws_cb(cbobj,cbdata)
% VT2FBWS_CB Callback to update area function in vt2fbws
% function vt2fbws_cb
% vt2fbws_cb: Version 12.10.07
%
%   Description
%       At mouse click update areafunction.
%       Tube section number and tube area determined by mouse position


cp=get(cbobj,'currentpoint');
cp=cp(2,1:2);

hh=findobj(cbobj,'type','line','tag','areafunction');

myS=get(hh,'userdata');

x=myS.sectionposition;
y=myS.areadata;


nconst=myS.constriction_length;

mytype=get(get(cbobj,'parent'),'selectiontype');

%disp(['call back ' mytype]);

myS.selectiontype=mytype;

%if strcmp(mytype,'open');
%   myS.sectionposition_restore=x;
%   myS.areadata_restore=y;
%   set(hh,'userdata',myS);
%   return;
%end;




if strcmp(mytype,'alt');
   x=myS.sectionposition_restore;
   y=myS.areadata_restore;
end;


[minw,minp]=min(abs(x-cp(1)));
curx=x(minp);


pgo=round(minp-(nconst-1)/2);
pend=pgo+nconst-1;

pgo=max([pgo 1]);
pend=min([pend length(y)]);

snapa=myS.snap_area;

cury=round(cp(2)/snapa);
cury=max([cury 1]);
cury=cury*snapa;

y(pgo:pend)=cury;
areadata=y;
myS.areadata=areadata;
[dodo,y]=makeafgraph(areadata,x);

set(hh,'ydata',y);

myS.lastpoint=[curx cury];


set(hh,'userdata',myS);
drawnow;



function fixuisize(hu,uiinc)

upos=get(hu,'position');
uext=get(hu,'extent');

upos(3:4)=uext(3:4)+uiinc;

set(hu,'position',upos);

function fixuipos(hu,hul,uiinc);
%position new ui to right of last ui

lastpos=get(hul,'position');
upos=get(hu,'position');

upos(1)=lastpos(1)+lastpos(3)+uiinc;
upos(2)=lastpos(2);

set(hu,'position',upos);
function [x,y]=makeafgraph(areadata,secpos);
%change the list of areas and section lengths into suitable shape for
%plotting
%   keyboard
y=[areadata areadata]';
y=y(:);
x=[[0;secpos(1:(end-1))] secpos]';
x=x(:);


