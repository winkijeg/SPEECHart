function h_muscles = plot_muscles( obj, names, col, h_axes )
%plot muscles - tongue rest position of the VT model

    if ~exist('names', 'var') || isempty(names)
        names = obj.muscles.names;
    end

    if ~exist('col', 'var') || isempty(col)
        col = 'k';
    end

    if ~exist('h_axes', 'var') || isempty(h_axes)
        h_axes = obj.initPlotFigure(false);
    end

    nMuscles = size(names, 2);
    for nbMuscle = 1:nMuscles
        
        nameTmp = names{nbMuscle};
        
        % get the muscle
        muscleTmp = obj.muscles.getMuscleFromCollection(nameTmp);
        
        % plot the muscle
        h_muscles(nbMuscle) = obj.tongue.drawMuscleNodes(muscleTmp, col, h_axes);
                
    end
    
end

