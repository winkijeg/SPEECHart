function tv = tvStructGenerator(N)
%%Author: Brad Story
%
%The purpose of this function is to build a default tv structure with the
%desired number of time samples (N).  The idea is that the relevant variables
%could be altered elsewhere.

ZN = zeros(N,1);
ON = ones(N,1);

tv.q = [ZN ZN ZN];
tv.mc = [ZN ZN ];
tv.lc = [ON ON];
tv.ac= [ZN ZN];
tv.rc= [ON ON];
tv.sc= [ON ON];
tv.np= ZN;
tv.lg= ZN;
tv.lm= ZN;
tv.pg= ZN;
tv.rg= ON;
tv.pm= ZN;
tv.rm= ON;
tv.Fo = 120*ON;
tv.Vamp = 200*ON;
tv.Fsp = 80;
tv.N = N;