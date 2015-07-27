function h_muscles = plot_muscles( obj, names, col, h_axes )
%plot muscles - tongue rest position of the VT model
    %    
    %input arguments:
    %
    %   - names     : CellString, i.e. {'ANS'}, {'ANS', 'PNS', ...}, or {} 
    %                 - use {'STY'} for plotting just one muscle
    %                 - use {'GGP', 'GGA'} for plotting each muscle in the CellString
    %                   o possible values are: 'GGP', 'GGA', 
    %                     'HYO', 'STY', 'VER', 'SL', 'IL' 
    %                 - leave empty ({}) in order to plot the full muscle set
    %   - col       : color, i.e. 'r' for red, or [1 0 0] ( RGB - triple )
    %   - h_axes    : axes handle of the window to be plotted to
    %

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
    h_muscles = zeros(1, nMuscles);
    for nbMuscle = 1:nMuscles
        
        nameTmp = names{nbMuscle};
        
        % get the muscle
        muscleTmp = obj.muscles.getMuscleFromCollection(nameTmp);
        
        % plot the muscle nodes
        h_muscles(nbMuscle) = obj.tongue.drawMuscleFibers(muscleTmp, col, h_axes);
             
    end
    
end

