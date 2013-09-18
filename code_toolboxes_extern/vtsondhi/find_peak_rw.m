function [ForFreq, kP] = find_peak_rw(ImpA, Kfft)
% find peaks by peakpicking and parabolic interpolation

% Konstanten definieren

% Samplingfrequenz
fSamp = 5000;
% Omega
% for nbBinFFT=1:Kfft 
%    Omega(nbBinFFT) = 2*pi*fSamp*nbBinFFT/Kfft;
% end;

% plot(Omega/(2*pi), ImpA);
% axis([0 5000 -20 60]);      
% grid on;
% hold on;

nFormants = 1;
for nbBinFFT = 2:Kfft-1
    
	if (ImpA(nbBinFFT-1) < ImpA(nbBinFFT)) && (ImpA(nbBinFFT+1) < ImpA(nbBinFFT))
        kP(nFormants) = nbBinFFT;
        nFormants = nFormants+1;
    end
    
end

ForAnz = nFormants-1;

% plot kP()
%for l=1:ForAnz
%   plot(Omega(kP(l))/(2*pi),...
%      ImpA(kP(l)),'or');
%   Omega(kP(l))/(2*pi);
%end;

% parabolic interpolation
for nFormants = 1:ForAnz
   c = ImpA(kP(nFormants));
   b = (ImpA(kP(nFormants)+1)-ImpA(kP(nFormants)-1))/2;
   a = (ImpA(kP(nFormants)-1)+ImpA(kP(nFormants)+1))/2 ...
      - ImpA(kP(nFormants));
   lamda =-b/(2*a);
   ForFreq(nFormants)=(kP(nFormants)+lamda)*fSamp/Kfft;
   % Kontrolle
   %plot(ForFreq(l),...
   %   ImpA(kP(l)),'og');
   for nbBinFFT=1:Kfft
      parab(nbBinFFT)=a*(nbBinFFT-kP(nFormants))*(nbBinFFT-kP(nFormants))+b*(nbBinFFT-kP(nFormants))+c;
   end;
	%plot(Omega/(2*pi), parab,'g');
end
