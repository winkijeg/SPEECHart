classdef Utterance
    % represent data / trajectories over time of an utterance 
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        
        modelUUID@char              % chars identifying the corresponding VT model 
        nFrames@uint8               % number of time frames
        uttDuration@double          % total duration of the utterance [s]
        
        isEquidistant@logical       % indicating if frames are equidistant

        timeOfFrames@double         % line vector of frame timepoints
        
        %forceFrames@ForceFrame
        positionFrames@PositionFrame    % tongue position over time
       
        
    end

    properties (Constant)
        
        nNodes = 221;
        
    end
    
    properties (GetAccess = private)

        lowLipPosX
        lowLipPosY
        
        upperLipPosX
        upperLipPosY

        lowIncisorPosX
        lowIncisorPosY
       
        larynxArytenoidPosX
        larynxArytenoidPosY
        
        tongueLarynxPosX
        tongueLarynxPosY
        
        condylePosX
        condylePosY
    end
    
    methods
        
        
        function obj = Utterance(matFile)
        % construct object from simulation mat-file
        
        obj.modelUUID = matFile.modelUUID;
        obj.isEquidistant = false;
        
        % determine number of valid frames / invalid first frames are 
        % the consequence of the way synthesis has been programmed ...
        nFramesInvalid = sum(matFile.t == 0)-1;
        nFramesOriginal = length(matFile.t);
        
        obj.nFrames = uint8(nFramesOriginal - nFramesInvalid);
        obj.timeOfFrames = matFile.t(nFramesInvalid+1:nFramesOriginal);
        
        obj.uttDuration = matFile.t(1, obj.nFrames);
        
        
        
        
            % up from now neutral position and deviations have the same format
            % extract relevant neutral positions 
            x0 = reshape(matFile.X0', 1, obj.nNodes);
            y0 = reshape(matFile.Y0', 1, obj.nNodes);
            
            
            % extract first half of points/ second half contains ...
            % velocity of nodes
            positionsTongueTmp = matFile.U(nFramesInvalid+1:nFramesOriginal, ...
                1:2*obj.nNodes);
            
            posTongDevX = positionsTongueTmp(:, 1:2:2*obj.nNodes);
            posTongDevY = positionsTongueTmp(:, 2:2:2*obj.nNodes);
                
            % add neutral and deviation ?????? RW
            posTongX = repmat(x0, nFramesOriginal, 1) + posTongDevX;
            posTongY = repmat(y0, nFramesOriginal, 1) + posTongDevY;

%             posTongX = matFile.X0_seq(nFramesInvalid+1:nFramesOriginal,1:221);
%             posTongY = matFile.Y0_seq(nFramesInvalid+1:nFramesOriginal,1:221);
%             
%             % read data related to force .............................
%             forceValsXDirOrig = ...
%                 matFile.FXY_TRAJ(nFramesInvalid+1:nFramesOriginal, ...
%                 1:2:2*obj.nNodes);
%             forceValsYDirOrig = ...
%                 matFile.FXY_TRAJ(nFramesInvalid+1:nFramesOriginal, ...
%                 2:2:2*obj.nNodes);
% 
%             % convert from original scale to Newton
%             forceValsXDirNewton = forceValsXDirOrig * 0.001 * 35;
%             forceValsYDirNewton = forceValsYDirOrig * 0.001 * 35;
%            
            % read data related to jaw movement
            positionsLowLipTmp = matFile.U_lowlip(nFramesInvalid+1:nFramesOriginal, 1:30);
            obj.lowLipPosX = positionsLowLipTmp(:, 1:15);
            obj.lowLipPosY = positionsLowLipTmp(:, 16:30);
            
            positionsupperLipTmp = matFile.U_upperlip(nFramesInvalid+1:nFramesOriginal, 1:46);
            obj.upperLipPosX = positionsupperLipTmp(:, 1:23);
            obj.upperLipPosY = positionsupperLipTmp(:, 24:46);
            
            positionsLowIncisorTmp = matFile.U_dents_inf(nFramesInvalid+1:nFramesOriginal, 1:34);
            obj.lowIncisorPosX = positionsLowIncisorTmp(:, 1:17);
            obj.lowIncisorPosY = positionsLowIncisorTmp(:, 18:34);

            positionslarynxArytenoidTmp = matFile.U_lar_ar_mri(nFramesInvalid+1:nFramesOriginal, 1:18);
            obj.larynxArytenoidPosX = positionslarynxArytenoidTmp(:, 1:9);
            obj.larynxArytenoidPosY = positionslarynxArytenoidTmp(:, 10:18);
            
            positionstongueLarynxTmp = matFile.U_tongue_lar_mri(nFramesInvalid+1:nFramesOriginal, 1:24);
            obj.tongueLarynxPosX = positionstongueLarynxTmp(:, 1:12);
            obj.tongueLarynxPosY = positionstongueLarynxTmp(:, 13:24);
            
            obj.condylePosX = matFile.U_X_origin(1, nFramesInvalid+1:nFramesOriginal)';
            obj.condylePosY = matFile.U_Y_origin(1, nFramesInvalid+1:nFramesOriginal)';
            
            
%             
%             % resample trajectories .................................
%             frameDuration = 1/fs;
%             endTimeOfLastFrame = max(matFile.t);
% 
%             % Sample time points for the new frames
%             timeOfFramesResampled = 0:frameDuration:endTimeOfLastFrame;
%                   
%             % resample position data
%             positionTongXResampled = ...
%                 interp1(timeOfFramesOrigValid, posTongX, ...
%                 timeOfFramesResampled);
%             positionTongYResampled = ...
%                 interp1(timeOfFramesOrigValid, posTongY, ...
%                 timeOfFramesResampled);
%             
%             % resample force data
%             forceXDirResampled = ...
%                 interp1(timeOfFramesOrigValid, forceValsXDirNewton, ...
%                 timeOfFramesResampled);
%             forceYDirResampled = ...
%                 interp1(timeOfFramesOrigValid, forceValsYDirNewton, ...
%                 timeOfFramesResampled);
%       
%             % resample lower lip and lower teeth data
%             posLowLipXResampled = interp1(timeOfFramesOrigValid, posLowLipX, ...
%                 timeOfFramesResampled);
%             posLowLipYResampled = interp1(timeOfFramesOrigValid, posLowLipY, ...
%                 timeOfFramesResampled);
% 
%             
%             posLowIncisorXResampled = interp1(timeOfFramesOrigValid, posLowIncisorX, ...
%                 timeOfFramesResampled);
%             posLowIncisorYResampled = interp1(timeOfFramesOrigValid, posLowIncisorY, ...
%                 timeOfFramesResampled);
%             
%             posCondyleXResampled = interp1(timeOfFramesOrigValid, posCondyleX, ...
%                 timeOfFramesResampled);
%             posCondyleYResampled = interp1(timeOfFramesOrigValid, posCondyleY, ...
%                 timeOfFramesResampled);
%              
%             
%             nFramesResampled = length(timeOfFramesResampled);

%             % memory allocation for creating objects
            obj.positionFrames(obj.nFrames) = PositionFrame();
            %obj.forceFrames(nFramesResampled) = ForceFrame();
            for k = 1:obj.nFrames
                
                obj.positionFrames(k) = ...
                    PositionFrame(obj.timeOfFrames(k), ...
                    posTongX(k, :), posTongY(k, :));
                
%                 obj.forceFrames(k) = ...
%                     ForceFrame(timeOfFramesResampled(k), ...
%                     forceXDirResampled(k, :), forceYDirResampled(k, :));
            end
            
            
%             
%             obj.xyLowLipOverTime = [posLowLipXResampled(:, 12)'; posLowLipYResampled(:, 12)'];
%             
%             obj.xLowLip = posLowLipXResampled;
%             obj.yLowLip = posLowLipYResampled;
%             
%             obj.lowIncisorPosX = posLowIncisorXResampled;
%             obj.lowIncisorPosY = posLowIncisorYResampled;
%             
%             obj.condylePosX(:, 1) = posCondyleXResampled;
%             obj.condylePosY(:, 1) = posCondyleYResampled;
%             
        end
        
        function nbFrame = getFrameNumberFromTime(obj, timePoint)
        % returns the frame number at a given time instant
           
            if timePoint > obj.durationTotal
                error('time instant greater than total duration of utterance ...')
            else
                [~, nbFrame] = min(abs(obj.timeOfFrames - ...
                    timePoint*ones(1, obj.nFrames) ));
            end
            
        end
    
        h = plotSingleStructure(obj, structName, targetFrame, colorStr)
        [] = simulateTongueMovement(obj, pauseSeconds, colStr, model)
        
    end
    
        
            
    
end

