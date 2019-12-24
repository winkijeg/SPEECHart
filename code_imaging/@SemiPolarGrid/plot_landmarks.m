function [] = plot_landmarks(obj, col, h_axes)
%Plot manually labeled landmarks corresponding to the grid

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = gca;
    end
    
    %fieldNamesStr = {'Lx', 'Palate', 'AlvRidge', 'LipU', 'LipL', ...
    %    'PharL', 'PharH', 'ANS', 'PNS'};
    fieldNamesStr = {'Lx', 'Palate', 'AlvRidge', 'LipU', 'LipL', ...
        'PharL', 'PharH'}; 

    nLandmarks = size(fieldNamesStr, 2);
    for nbLandmark = 1:nLandmarks

        lab_tmp = fieldNamesStr{nbLandmark};
        ptTmp = obj.labeledPoints.(fieldNamesStr{nbLandmark});
        
         plot(h_axes, ptTmp(1), ptTmp(2), 'Color', col, 'Marker', ...
             'd', 'MarkerSize', 10, 'Tag', 'grid_lm');
         %text(ptTmp(1)+3, ptTmp(2)+3, lab_tmp, 'Color', col, 'Parent', h_axes);
    
    end
    
end
