function [] = writeUttToMPEG4(obj, utterance, fname)
% write mpeg4 movie of an utterance

    h = obj.initPlotFigure('false');

    writerObj = VideoWriter(fname, 'Uncompressed AVI');
    set(writerObj, 'FrameRate', 4)
    open(writerObj);

    nFrames = utterance.nFrames;

    for k = 1:nFrames
        
        utterance.plotSingleStructure('lowLip', k, 'k--');
%         
%     myPosFrame = myUtt.positionFrames(nbPosFrame);
% 
% myPosFrameRest = myUtt.positionFrames(1);
% myPosFrameRest.drawTongSurface('k--')

        frame = getframe;
        writeVideo(writerObj,frame);
        
    end

    close(writerObj);

    close(h)
    
end

