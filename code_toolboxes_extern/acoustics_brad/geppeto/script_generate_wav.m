% creates wav-files from area functions (developed by B. Story)
%
% According to area functions, the sound signal is produced.

% written 09/2012 by RW

clear *

simNr = '15_07';
simNr_sh = simNr(1:2);

playFlag = 0;

%[0 | 1 | 2 ] corresponds to 3 types of contours 
% proposed by Brad Story; 0 creates a monotone F0 that is exactly 
% constant over the duration of the simulation. 1 creates an F0 
% contour as a statement, 2 is a question;

F0Contour = 0; 
F0 = 100;      % Pitch in Hz
Dur = 0.3;     % Duration of the sound in seconds

% ---------------------------------------------------------------------
[~, machineName] = system('hostname');
switch deblank(machineName)
    case 'laptop-079'
        path_GRN = 'D:\USERS\perrierp\Pascal\ModeleLangue\Modele_Inverse_Ralf_PP_Version15_7_Octobre2012\';
    case 'winkler-laptop'
        path_GRN = 'e:/projects/project_postdocGRN/';
    otherwise
        error(['unknown machine name ' machineName])
end
path_af = [path_GRN 'db_' simNr '/area_functions/'];
path_wav = [path_GRN 'db_' simNr '/wav/'];

% ---------------------------------------------------------------------

matFiles = dir([path_af 'r_x' simNr_sh '_*_AIRE.mat']);
nFiles = size(matFiles, 1);

for matNr = 1:nFiles
    
    [fn_sh, ext] = basename( matFiles(matNr).name );
    
    fn_af = [fn_sh '.' ext];
    fn_wav = [fn_sh '.wav'];

    af = load([path_af fn_af]);

    % synthesize sound
    [snd, fs] = sythese_brad(af , F0Contour, F0, Dur);
    
    % play sound
    if playFlag == 1
        soundsc(snd, fs);
    end

    % save sound into the proper directory
    wavwrite(snd, fs, [path_wav fn_wav])
    
end
