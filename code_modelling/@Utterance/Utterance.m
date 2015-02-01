classdef Utterance
    % represents trajectories over a whole utterance 
    %   Detailed explanation goes here
    
    properties
        
        nNodes = [];
        timeOfFrames = [];
        nFrames = [];
        durationTotal = NaN;
        
        % to be modeled later ...
        lowLipPosX = [];
        lowLipPosY = [];
        
        lowIncisorPosX = [];
        lowIncisorPosY = [];
        
        condylePosX = [];
        condylePosY = [];

    end

    properties (SetAccess = private)
        
        forceFrames = ForceFrame;
        positionFrames = PositionFrame;
        
    end
    
    methods
        
        % constructor makes simulation equidistant
        function obj = Utterance(matFile, varargin)
        % first paramater is the mat file (simulation), second parameter
        % is the sampling frequency (fs) of the simulation
        
            switch nargin
                case 1
                    fs = 100; % default value of 100 Hz == 10 ms
                case 2
                    fs = varargin{1};
                otherwise
                    error ('to many input arguments ...')
            end

            % assign values that are not affected by resampling ...
            obj.nNodes = matFile.NN * matFile.MM;
            
            % up from now neutral position and deviations have the same format
            % extract relevant neutral positions 
%             x0 = reshape(matFile.X0', 1, obj.nNodes);
%             y0 = reshape(matFile.Y0', 1, obj.nNodes);

            nFramesOriginal = length(matFile.t);
            
            % invalid first frames are the consequence of the way synthesis
            % has been programmed ...
            nFramesInvalid = sum(matFile.t == 0)-1;
            timeOfFramesOrigValid = ...
                matFile.t(nFramesInvalid+1:nFramesOriginal);
            
            nFramesOrigValid = nFramesOriginal - nFramesInvalid;
            
            % extract first half of points/ second half contains ...
            % velocity of nodes
%             positionsTongueTmp = matFile.U(nFramesInvalid+1:nFramesOriginal, ...
%                 1:2*obj.nNodes);
%             
%             posTongDevX = positionsTongueTmp(:, 1:2:2*obj.nNodes);
%             posTomgDevY = positionsTongueTmp(:, 2:2:2*obj.nNodes);
%                 
%             % add neutral and deviation
%             posTongX = repmat(x0, nFramesOrigValid, 1) + posTongDevX;
%             posTongY = repmat(y0, nFramesOrigValid, 1) + posTomgDevY;

            posTongX = matFile.X0_seq(nFramesInvalid+1:nFramesOriginal,1:221);
            posTongY = matFile.Y0_seq(nFramesInvalid+1:nFramesOriginal,1:221);
            
            % read data related to force .............................
            forceValsXDirOrig = ...
                matFile.FXY_TRAJ(nFramesInvalid+1:nFramesOriginal, ...
                1:2:2*obj.nNodes);
            forceValsYDirOrig = ...
                matFile.FXY_TRAJ(nFramesInvalid+1:nFramesOriginal, ...
                2:2:2*obj.nNodes);

            % convert from original scale to Newton
            forceValsXDirNewton = forceValsXDirOrig * 0.001 * 35;
            forceValsYDirNewton = forceValsYDirOrig * 0.001 * 35;
           
            % read data related to jaw movement
            positionsLowLipTmp = matFile.U_lowlip(nFramesInvalid+1:nFramesOriginal, 1:30);
            posLowLipX = positionsLowLipTmp(:, 1:15);
            posLowLipY = positionsLowLipTmp(:, 16:30);
            
            positionsLowIncisorTmp = matFile.U_dents_inf(nFramesInvalid+1:nFramesOriginal, 1:34);
            posLowIncisorX = positionsLowIncisorTmp(:, 1:17);
            posLowIncisorY = positionsLowIncisorTmp(:, 18:34);
            
            posCondyleX = matFile.U_X_origin(1, nFramesInvalid+1:nFramesOriginal)';
            posCondyleY = matFile.U_Y_origin(1, nFramesInvalid+1:nFramesOriginal)';
            
            
            
            % resample trajectories .................................
            frameDuration = 1/fs;
            endTimeOfLastFrame = max(matFile.t);

            % Sample time points for the new frames
            timeOfFramesResampled = 0:frameDuration:endTimeOfLastFrame;
                  
            % resample position data
            positionTongXResampled = ...
                interp1(timeOfFramesOrigValid, posTongX, ...
                timeOfFramesResampled);
            positionTongYResampled = ...
                interp1(timeOfFramesOrigValid, posTongY, ...
                timeOfFramesResampled);
            
            % resample force data
            forceXDirResampled = ...
                interp1(timeOfFramesOrigValid, forceValsXDirNewton, ...
                timeOfFramesResampled);
            forceYDirResampled = ...
                interp1(timeOfFramesOrigValid, forceValsYDirNewton, ...
                timeOfFramesResampled);
      
            % resample lower lip and lower teeth data
            posLowLipXResampled = interp1(timeOfFramesOrigValid, posLowLipX, ...
                timeOfFramesResampled);
            posLowLipYResampled = interp1(timeOfFramesOrigValid, posLowLipY, ...
                timeOfFramesResampled);

            
            posLowIncisorXResampled = interp1(timeOfFramesOrigValid, posLowIncisorX, ...
                timeOfFramesResampled);
            posLowIncisorYResampled = interp1(timeOfFramesOrigValid, posLowIncisorY, ...
                timeOfFramesResampled);
            
            posCondyleXResampled = interp1(timeOfFramesOrigValid, posCondyleX, ...
                timeOfFramesResampled);
            posCondyleYResampled = interp1(timeOfFramesOrigValid, posCondyleY, ...
                timeOfFramesResampled);
             
            
            nFramesResampled = length(timeOfFramesResampled);
            % memory allocation for creating objects
            obj.positionFrames(nFramesResampled) = PositionFrame();
            obj.forceFrames(nFramesResampled) = ForceFrame();
            for k = 1:nFramesResampled
                
                obj.positionFrames(k) = ...
                    PositionFrame(timeOfFramesResampled(k), ...
                    positionTongXResampled(k, :), positionTongYResampled(k, :));
                
                obj.forceFrames(k) = ...
                    ForceFrame(timeOfFramesResampled(k), ...
                    forceXDirResampled(k, :), forceYDirResampled(k, :));
            end
            
            
            
            % assign values that are manipulated by resampling ... 
            obj.timeOfFrames = timeOfFramesResampled;
            obj.nFrames = length(timeOfFramesResampled);
            obj.durationTotal = timeOfFramesResampled(nFramesResampled);
            
            obj.lowLipPosX = posLowLipXResampled;
            obj.lowLipPosY = posLowLipYResampled;
            
            obj.lowIncisorPosX = posLowIncisorXResampled;
            obj.lowIncisorPosY = posLowIncisorYResampled;
            
            obj.condylePosX(:, 1) = posCondyleXResampled;
            obj.condylePosY(:, 1) = posCondyleYResampled;
            
        end
        
        % returns the frame number at a given time instant, i.e. 0.180 [ms]
        function nbFrame = getFrameNumberFromTime(obj, timeInstant)
           
            if timeInstant > obj.durationTotal
                error('time instant greater than total duration of utterance ...')
            else
                [~, nbFrame] = min(abs(obj.timeOfFrames - ...
                    timeInstant*ones(1, obj.nFrames) ));
            end
            
        end
    
        val = determineJawOpeningAngle(obj, t1, t2)
        
        [] = plotSingleStructure(obj, structName, targetFrame, colorStr)
        
    end
    
        
            
    
end

