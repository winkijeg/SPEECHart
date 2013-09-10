% test biomechanical tongue model (adapted) with jaw movement
%

% written 09/2013 (Ralf)


addpath(genpath('./model_adapt_jaw'))

clear *

spkStr = 'pp_FF1';

path_model = ['spec_' spkStr '/'];

simul_tongue_adapt_jaw(path_model, spkStr, 'rya', 'rya', [-20 10], [20 -10], ...
    [20 -7], [-15 10], [0 0], [200 200], [0 0], [0.05 0.05], [0.100 0.100],...
    [-3 8], [3 -5], [-4 6], [5 -3], 1);
