function h = plotSingleStructure(obj, structName, nbFrame, plotString, h_axes)
%plot single (nonrigid) structure for a given time frame
    %    
    %input arguments:
    %
    %   - structName    : String, i.e. 'lowerLip'
    %                       values are:
    %                       o 'condyle'
    %                       o 'upperLip'
    %                       o 'lowerLip'
    %                       o 'lowerIncisor'
    %                       o 'tongueLarynx'
    %                       o 'larynxArytenoid'
    %   - nbFrame       : frame number
    %   - plotString    : standard MATLAB plot string
    %   - h_axes        : axes handle of the window to be plotted to 
    %
    
    posX = obj.structures.(structName)(nbFrame, 1:2:end);
    posY = obj.structures.(structName)(nbFrame, 2:2:end);
    
    h = plot(h_axes, posX, posY, plotString);
    
end

