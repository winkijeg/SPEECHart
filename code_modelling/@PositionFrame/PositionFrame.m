classdef PositionFrame
    % represent position of all nodes at a (given) time frame
    
    properties
        
        timeOfFrame@double  % time of the frame
        
        xValNodes@double    % 221 x values
        yValNodes@double    % 221 y values
        
    end
    
    properties (Constant)
        
        nNodes = 221        % number of nodes 
        
    end
        
        
    
    methods
        
        function obj = PositionFrame(timeOfFrame, xVals, yVals)
            % construct an object based on position data
            
            if nargin ~= 0
            
                obj.timeOfFrame = timeOfFrame;
                obj.xValNodes(1, 1:obj.nNodes) = xVals;
                obj.yValNodes(1, 1:obj.nNodes) = yVals;

            end
            
        end
        
        h = drawMesh(obj, col, h_axes);
        h = drawNodeNumbers(obj, col);
        h = drawTongSurface(obj, col, h_axes);
        h = drawMuscleFibers(obj, muscle, colStr, h_axes)
        
        xyVals = getPositionOfNodeNumbers(obj, nodeNumbers);
        xyVals = getPositionOfTongSurface(obj);
         
    end
    
end
