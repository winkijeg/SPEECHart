% test biomechanical tongue model (adapted) with jaw movement
%

% written 09/2013 (Ralf)

clear *
op = addpath(genpath('./model_adapt_jaw'));

%spkStr = 'pp_FF1';
%spkStr = 'cs';
spkStr = 'av';

t_trans = 0.05;
t_hold = 0.100;

% % original inputs; order is GGP GGA HYO STY VER SL IL
% seq = 'rya';
% jaw_rot = [-3 8]:
% lip_prot = [3 -5];
% ll_rot = [-4 6];
% hyoid_mov = [5 -3];
% deltaLambda_av = [-20  20  20 -15 0 200 0; 
%                    10 -10 -7   10 0 200 0];

% % example 1 - /a/
% seq = 'ra';
% jaw_rot = 8;
% lip_prot = -5;
% ll_rot = 6;
% hyoid_mov = -3;
% deltaLambda_av = [10 -10 -7 10 0 0 0];
% 
% % example 2 - /i/
% seq = 'ri';
% jaw_rot = -1;
% lip_prot = -15;
% ll_rot = 6;
% hyoid_mov = -13;
% deltaLambda_av = [-10 10 7 -10 0 0 0];

% example 3 - /u/
seq = 'ru';
jaw_rot = -1;
lip_prot = 8;
ll_rot = 6;
hyoid_mov = -3;
deltaLambda_av = [20 20 7 -20 0 0 0];



path_model = ['spec_' spkStr '/'];

simul_tongue_adapt_jaw(path_model, spkStr, seq, seq, ...
    deltaLambda_av(:, 1)', ...
    deltaLambda_av(:, 2)', ...
    deltaLambda_av(:, 3)', ...
    deltaLambda_av(:, 4)', ...
    deltaLambda_av(:, 5)', ...
    deltaLambda_av(:, 6)', ...
    deltaLambda_av(:, 7)', ...
    t_trans, t_hold,...
    jaw_rot, lip_prot, ll_rot, hyoid_mov, 1);

path(op);