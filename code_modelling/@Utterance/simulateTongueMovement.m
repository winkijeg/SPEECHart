function simulateTongueMovement(obj, pauseSeconds, colStr, model)
%plot tongue over time - simulates movement

colorPastFrames = 0.75;

% extract one muscle - GGP
myMuscle = model.muscleCollection.muscles(4);

model.plotRigidStructures('k');

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
  
        set(h_mesh, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        set(h_muscle, 'Color', [colorPastFrames colorPastFrames colorPastFrames])
        
        %delete (h_nodeNumbers);
  
    end
    
    % draw rigid parts
    h_nonrigid = drawTongSurface(obj.positionFrames(nbFrame), colStr);
    
    
    % draw nonrigid parts
    h_rigid1 = plotSingleStructure(obj, 'lowLip', nbFrame, colStr);
    h_rigid2 = plotSingleStructure(obj, 'upperLip', nbFrame, colStr);
    
    h_rigid3 = plotSingleStructure(obj, 'lowIncisor', nbFrame, colStr);
    h_rigid4 = plotSingleStructure(obj, 'larynxArytenoid', nbFrame, colStr);
    h_rigid5 = plotSingleStructure(obj, 'tongueLarynx', nbFrame, colStr);

    % draw time course of a single point (condyle)
    h_rigid6 = plotSingleStructure(obj, 'condyle', nbFrame, ...
        [colStr '.']);
    
    h_mesh = obj.positionFrames(nbFrame).drawMesh('r');
    
    h_muscle = obj.positionFrames(nbFrame).drawMuscleNodes(myMuscle, 'g');
    
    
    %h_nodeNumbers = obj.positionFrames(nbFrame).drawNodeNumbers('k');
    
    
    
    pause(pauseSeconds)

end
