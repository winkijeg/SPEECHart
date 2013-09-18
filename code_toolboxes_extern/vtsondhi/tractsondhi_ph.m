function [ImpA, Hlout] = tractsondhi_ph(lEnd, Area, dLen)
% function [ImpA] = TractSondhi_cg(lEnd, Area, dLen);
% ------------------------------------------------
% Parameter: 
% Input Args: 
% lEnd: Skalar: letztes Röhrchen
% Area: areavector der Länge 1 * lEnd
% dLen: Rörchenlänge of each section; i.e dimension is also 1*lEnd
% Output: ImpA
% -------------------------------------------------
% aus:
% @Article{SonSchroe87,
% author = 	 {Sondhi, M. M. and Schroeter, J.},
%  title = 	 {A hybrid time frequency domain articulatory speech synthesizer},
%  journal = 	 {IEEE Transactions on Acoustics, Speech and Signal Processing},
%  year = 	 {1987},
%  OPTvolume = 	 {35},
%  OPTpages = 	 {955-967},


% Konstanten definieren
% Länge der FFT
Kfft=128;
% Samplingfrequenz
fSamp=5000;
% speed of sound ...
cSou = 35000;
Rho = 1.14e-3;
Mue = 1.86e-4;

%Tabelle II, vocal tract
At=130*pi;
Bt=30*30*pi*pi;
Ct1 = 4;
Om2 = 406*406*pi*pi;

% Impuls im Zeitbereich
uSig(1)=1;
for k=2:Kfft 
   uSig(k)=0;
end;
uIn=fft(uSig);

% chain matrix erstellen....
for k=1:Kfft 
   Omega(k) = 2*pi*fSamp*k/Kfft;
   pIn(k) = 0.;
   %uIn(k) = 1.;
   % die Griechen:
	Alpha(k) = sqrt(1j*Omega(k)*Ct1);
	Beta(k)  = Alpha(k) + (1j*Omega(k)*Om2)/...
      ((1j*Omega(k)+At)*1j*Omega(k)+Bt); 
   Gamma(k) = sqrt((At+1j*Omega(k))/...
      (Beta(k)+1j*Omega(k)));
   Sigma(k) = Gamma(k)*(Beta(k)+1j*Omega(k));
end;

% Beginn der Synthese
for k=1:Kfft 
   % l: die einzelnen ror
   Kges = [1 0; 0 1];
   for l=1:lEnd
      area=Area(l);
		dlen=dLen(l);
	   % chain Matrix - Elemente:
	   sl = Sigma(k)*dlen/cSou;
	   am = cosh(sl);
	   bm = -1*Rho*cSou*Gamma(k)*...
   		   sinh(sl)/area;
	   cm = -1*area*sinh(sl)/...
		      (Rho*cSou*Gamma(k));
	   dm = cosh(sl);
   	% die Matrixmultiplikation
      Kdl  = [am bm; cm dm];
      Kges = Kdl * Kges;
   end;
   % l=lEnd: Lippen
   % Fant Liljencrants
   %Ks=1.4;
   %Ls=1.15;
   %akLi   = sqrt(area/pi)*Omega(k)/cSou;
   %zLi(k) = Ks*akLi*akLi/4 + ...
   %   1j*Ls*4*akLi/(3*pi);
   %zLi(k) = zLi(k)*Rho*cSou/area;
	% lip radiation impedance: Laine 1982
	omTLai  = Omega(k)*sqrt(area)/(4*13500); 
   Kw = (0.674-0.00854*area)*...
      (1-cos(omTLai)) + ...
      1j*0.674*sin(omTLai);
   zLi(k)= Kw*Rho*cSou/area; 
   % die Multiplikation
   Inp = [pIn(k); uIn(k)];
   Out = Kges*Inp;
   pOut(k) = Out(1);
   uOut(k) = Out(2);
   Hl(k) = zLi(k)/(Kges(1,1)-Kges(2,1)*zLi(k));
   ImpA(k) = 10*log10(real(Hl(k))*real(Hl(k))+imag(Hl(k))*imag(Hl(k)));
end;

if nargout > 1
    Hlout = Hl;
end;

% plotten
% plot(Omega/(2*pi), ImpA, ':');
% axis([0 5000 -20 60]);      
% grid on;
%input ('weiter');
%save ImpA ImpA;
% -----------------------------------------------

