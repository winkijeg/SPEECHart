function fon = modulate_fo2(fo,fs,modExt,modF)
%
%cum time

tme = [];
tme(1) = 0;
tme = [0:1/fs:(length(fo)-1)/fs];

M = modExt*fo.*sin(2*pi*modF.*tme');

fon = M + fo; 

