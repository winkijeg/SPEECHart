classdef ForceNode
    % represents force value of one node of the tongue mesh
    %   Detailed explanation goes here
    
    properties
        
        resultingForce = NaN;
        
    end
    
    properties (SetAccess = private)
        
        forceInXDir = NaN;
        forceInYDir = NaN;

    end
    
    methods
        
        function obj = ForceNode(valXDir, valYDir)
            if nargin < 2
                valXDir = NaN;
                valYDir = NaN;
            end
            obj.forceInXDir = valXDir;
            obj.forceInYDir = valYDir;
            obj.resultingForce = norm([valXDir valYDir]); % vector norm
        end
        
    end
    
end
