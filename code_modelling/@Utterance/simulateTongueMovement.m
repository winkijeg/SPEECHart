function simulateTongueMovement(obj, pauseSeconds, colStr, model, h_axes)
%plot tongue over time - simulates movement

colorPastFrames = 0.85;

% extract one muscle - GGP
myMuscle = model.muscles.muscleArray(1);

model.plot_fixed_contours('k', h_axes);

h_nonrigid = [];
for nbFrame = 1:obj.nFrames
    
    if ~isempty(h_nonrigid)
        %delete (h_nonrigid);
        set(h_nonrigid, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_rigid1, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_rigid2, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_rigid3, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_rigid4, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_rigid5, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_rigid6, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
  
        set(h_mesh, 'EdgeColor', [colorPastFrames colorPastFrames colorPastFrames])
        
        set(h_muscle, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        
        %delete (h_nodeNumbers);
  
    end
    
    % draw rigid parts
    h_nonrigid = drawTongSurface(obj.tongue(nbFrame), colStr);
    
    
    % draw nonrigid parts
    h_rigid1 = plotSingleStructure(obj, 'lowerLip', nbFrame, colStr, h_axes);
    h_rigid2 = plotSingleStructure(obj, 'upperLip', nbFrame, colStr, h_axes);
    
    h_rigid3 = plotSingleStructure(obj, 'lowerIncisor', nbFrame, colStr, h_axes);
    h_rigid4 = plotSingleStructure(obj, 'larynxArytenoid', nbFrame, colStr, h_axes);
    h_rigid5 = plotSingleStructure(obj, 'tongueLarynx', nbFrame, colStr, h_axes);

    % draw time course of a single point (condyle)
    h_rigid6 = plotSingleStructure(obj, 'condyle', nbFrame, [colStr '.'], h_axes);
    
    h_mesh = obj.tongue(nbFrame).drawMesh('k', h_axes);
    
    h_muscle = obj.tongue(nbFrame).drawMuscleFibers(myMuscle, 'r', h_axes);
    
    
    %h_nodeNumbers = obj.positionFrames(nbFrame).drawNodeNumbers('k');
    
    
    
    pause(pauseSeconds)

end
