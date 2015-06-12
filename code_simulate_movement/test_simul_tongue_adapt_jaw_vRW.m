% test biomechanical tongue model (adapted) with jaw movement
%

% written 09/2013 (Ralf)

clearvars -global
close all

[path_root, ~,~] = initPaths('dummy1', 'dummy2');

%spkStr = 'pp_FF1';
spkStr = 'cs';
%spkStr = 'av';

t_trans = [0.050 0.050];
t_hold = [0.100 0.100];

seq = 'rai';
jaw_rot = [9 0];
lip_prot = [0 0];
ll_rot = [0 0];
hyoid_mov = [0 0];

% original inputs; order is GGP GGA HYO STY VER SL IL
deltaLambda_av = [0 0 0 0 0 0 0;
    -20 0 0 0 0 0 0];

% deltaLambda_av = [-20  20  20 -15 0 0 0;
%                     20 -20 -7 10 0 0 0];

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
% seq = 'ru';
% jaw_rot = -1;
% lip_prot = 8;
% ll_rot = 6;
% hyoid_mov = -3;
% deltaLambda_av = [20 20 7 -20 0 0 0];


path_model = [path_root 'data/models_obsolete/' spkStr '/'];
%path_model = ['spec_' spkStr '/'];

simul_tongue_adapt_jaw(path_model, spkStr, seq, seq, ...
    deltaLambda_av(:, 1)', ...
    deltaLambda_av(:, 2)', ...
    deltaLambda_av(:, 3)', ...
    deltaLambda_av(:, 4)', ...
    deltaLambda_av(:, 5)', ...
    deltaLambda_av(:, 6)', ...
    deltaLambda_av(:, 7)', ...
    t_trans, t_hold,...
    jaw_rot, lip_prot, ll_rot, hyoid_mov);
