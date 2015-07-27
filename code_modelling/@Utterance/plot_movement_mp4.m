function [] = plot_movement_mp4(obj, model, colStr, fname, h_axes)
%plot movement into a MATLAB figure/ store mp4 - just examples
    %this is just to give examples - write your own plot-method!

    colorPastFrames = 0.75;

    writerObj = VideoWriter(fname, 'Uncompressed AVI');
    set(writerObj, 'FrameRate', 4)
    open(writerObj);
    
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
            % set(h_muscle, 'Color', [colorPastFrames colorPastFrames colorPastFrames])

            %delete (h_nodeNumbers);

        end

        % draw rigid parts
        h_nonrigid = drawTongSurface(obj.tongue(nbFrame), colStr);


        % draw nonrigid parts
        h_rigid1 = obj.plotSingleStructure('lowerLip', nbFrame, colStr, h_axes);
        h_rigid2 = obj.plotSingleStructure('upperLip', nbFrame, colStr, h_axes);

        h_rigid3 = obj.plotSingleStructure('lowerIncisor', nbFrame, colStr, h_axes);
        h_rigid4 = obj.plotSingleStructure('larynxArytenoid', nbFrame, colStr, h_axes);
        h_rigid5 = obj.plotSingleStructure('tongueLarynx', nbFrame, colStr, h_axes);

        % draw time course of a single point (condyle)
        h_rigid6 = obj.plotSingleStructure('condyle', nbFrame, ...
            [colStr '.'], h_axes);

        h_mesh = obj.tongue(nbFrame).drawMesh('k', h_axes);

        %h_muscle = obj.positionFrames(nbFrame).drawMuscleNodes(myMuscle, 'g');


        %h_nodeNumbers = obj.positionFrames(nbFrame).drawNodeNumbers('k');



        %pause(pauseSeconds)

        frame = getframe;
        writeVideo(writerObj, frame);

    end

    
    close(writerObj);

    h_figure = get(h_axes, 'Parent');
    close(h_figure)
    
end

