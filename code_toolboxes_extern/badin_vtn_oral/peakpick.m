% [maxi, ind_maxi, mini, ind_mini] = peakpick(signal);
% 
% Détection des maximas et minimas locaux d'un signal
% 
% Entrée: 
%   signal(1:nb_ech) : signal à analyser
% 
% Sorties: 
%   maxi, ind_maxi   : valeurs et indices des maximas locaux
%   mini, ind_mini   : valeurs et indices des minimas locaux
% 

function [maxi, ind_maxi, mini, ind_mini] = peakpick(signal)

% Détection des minimas et maximas locaux d'un signal
mini = []; ind_mini = []; maxi = []; ind_maxi = [];

nb_ech = length(signal);
for ind = 2:nb_ech-1
  if (signal(ind-1) < signal(ind)) & (signal(ind+1) < signal(ind))
    ind_maxi = [ind_maxi, ind]; maxi = [maxi, signal(ind)];
  end
  if (signal(ind-1) > signal(ind)) & (signal(ind+1) > signal(ind))
    ind_mini = [ind_mini, ind]; mini = [mini, signal(ind)];
  end
end

%  Si on n'a pas trouvé d'extremum local, il faut prendre l'extrêmité du signal  
if isempty(maxi) 
	[maxi, ind_maxi] = max(signal);
end
if isempty(mini) 
	[mini, ind_mini] = min(signal);
end
return
