classdef Utterance
    % represents trajectories over a whole utterance 
    %   Detailed explanation goes here
    
    properties
        
        nNodes = [];
        timeOfFrames = [];
        nFrames = [];
        durationTotal = NaN;

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
            x0 = reshape(matFile.X0', 1, obj.nNodes);
            y0 = reshape(matFile.Y0', 1, obj.nNodes);

            nFramesOriginal = length(matFile.t);
            
            % invalid first frames are the consequence of the way synthesis
            % has been programmed ...
            nFramesInvalid = sum(matFile.t == 0);
            timeOfFramesOrigValid = ...
                matFile.t(nFramesInvalid+1:nFramesOriginal)
            nFramesOrigValid = nFramesOriginal - nFramesInvalid
            
            % extract first half of points/ secon half contains ...
            % velocity of nodes
            positionsTmp = matFile.U(nFramesInvalid+1:nFramesOriginal, ...
                1:2*obj.nNodes);
            
            posDevX = positionsTmp(:, 1:2:2*obj.nNodes);
            posDevY = positionsTmp(:, 2:2:2*obj.nNodes);
                
            % add neutral and deviation
            positionX = repmat(x0, nFramesOrigValid, 1) + posDevX;
            positionY = repmat(y0, nFramesOrigValid, 1) + posDevY;

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
            
            % now resampling takes place ...
            frameDuration = 1/fs;
            endTimeOfLastFrame = max(matFile.t);

            % Sample time points for the new frames
            timeOfFramesResampled = frameDuration:frameDuration: ...
                endTimeOfLastFrame;
                  
            % resample position data
            positionXResampled = ...
                interp1(timeOfFramesOrigValid, positionX, ...
                timeOfFramesResampled);
            positionYResampled = ...
                interp1(timeOfFramesOrigValid, positionY, ...
                timeOfFramesResampled);
            
            % resample force data
            forceXDirResampled = ...
                interp1(timeOfFramesOrigValid, forceValsXDirNewton, ...
                timeOfFramesResampled);
            forceYDirResampled = ...
                interp1(timeOfFramesOrigValid, forceValsYDirNewton, ...
                timeOfFramesResampled);
      
            nFramesResampled = length(timeOfFramesResampled);
        
            % memory allocation
            obj.positionFrames(nFramesResampled) = PositionFrame();
            obj.forceFrames(nFramesResampled) = ForceFrame();
            for k = 1:nFramesResampled
                
                obj.positionFrames(k) = ...
                    PositionFrame(timeOfFramesResampled(k), ...
                    positionXResampled(k, :), positionYResampled(k, :));
                
                obj.forceFrames(k) = ...
                    ForceFrame(timeOfFramesResampled(k), ...
                    forceXDirResampled(k, :), forceYDirResampled(k, :));
            end
            
            % assign values that are manipulated by resampling ... 
            obj.timeOfFrames = timeOfFramesResampled;
            obj.nFrames = length(timeOfFramesResampled);
            obj.durationTotal = timeOfFramesResampled(nFramesResampled);
            
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
    
        
    end
    
        
            
    
end

