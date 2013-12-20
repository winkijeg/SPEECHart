classdef PositionNode
    % represents position of one node of the tongue mesh
    %   Detailed explanation goes here
    
    properties
        
        positionX = NaN;
        positionY = NaN;

    end
    
    methods
        
        function obj = PositionNode(posX, posY)
            if nargin < 2
                posX = NaN;
                posY = NaN;
            end
            obj.positionX = posX;
            obj.positionY = posY;
        end
        
    end
    
end
