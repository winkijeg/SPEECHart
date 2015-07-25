classdef PositionFrame
    % represents position of all nodes at a (given) time
    
    properties
        
        timeOfFrame@double
        
        xValNodes@double
        yValNodes@double
        
    end
    
    properties (Constant)
        
        nNodes = 221
        
    end
        
        
    
    methods
        
        function obj = PositionFrame(timeOfFrame, xVals, yVals)
            
            if nargin ~= 0
            
                obj.timeOfFrame = timeOfFrame;
                obj.xValNodes(1, 1:obj.nNodes) = xVals;
                obj.yValNodes(1, 1:obj.nNodes) = yVals;

            end
            
        end
        
        % method declarations .............................................
        
        h = drawMesh(obj, col, h_axes);
        h = drawNodeNumbers(obj, col);
        h = drawTongSurface(obj, col, h_axes);
        h = drawMuscleNodes(obj, muscle, col, h_axes);
        
        xyVals = getPositionOfNodeNumbers(obj, nodeNumbers);
        xyVals = getPositionOfTongSurface(obj);
         
    end
    
end
