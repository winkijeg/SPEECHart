classdef ForceFrame
    % represents forces acting on all nodes at a (given) time 
    %   Detailed explanation goes here
    
    properties
        
        timeOfFrame = [];
        
    end
    
    properties (SetAccess = private)
        
        forceNodes = ForceNode;
        
    end
    
    methods
        
        function obj = ForceFrame(timeOfFrame, xVals, yVals)
            if nargin < 3
                timeOfFrame = 0;
                xVals = NaN;
                yVals = NaN;
            end
            
            obj.timeOfFrame = timeOfFrame;
            nNodes = size(xVals, 2);
            obj.forceNodes(nNodes) = ForceNode; % memory allocation
            
            for k = 1:nNodes
                obj.forceNodes(k) = ForceNode(xVals(k), yVals(k));
            end
            
        end
        
        function patchID = drawForceMesh(obj, posFrame)
            
            NLAYERS = 13;
            
            nNodes = length(obj.forceNodes);
            nNodesPerLayer = nNodes / NLAYERS;
            
            verts = [[posFrame.positionNodes(:).positionX]' ...
                [posFrame.positionNodes(:).positionY]'];
            
            nElements = (nNodesPerLayer-1) * (NLAYERS-1);
            faces = zeros(nElements, 1); % memory allocation 
            
            cntNodes = 1;
            cntLineIndex = 1;
            for k = 1:nNodes-NLAYERS
                
                if ~(rem(k, 13) == 0)
                    c1 = cntNodes;
                    c2 = cntNodes + 1;
                    c3 = cntNodes + 13 + 1;
                    c4 = cntNodes + 13;
                    
                    faces(cntLineIndex, 1:4) = [c1 c2 c3 c4];
                    cntLineIndex = cntLineIndex + 1;
                    
                else
                    % skip calculation, 
                end
                
                cntNodes = cntNodes + 1;
               
            end
            
            vertexForceVals = [obj.forceNodes(:).resultingForce]';
            maxForcePerVertex = max(vertexForceVals);
            cdata =  repmat(1-(vertexForceVals / maxForcePerVertex), 1, 3);
            
            patchID = patch('Faces',faces, 'Vertices', verts);
            set(patchID, 'FaceColor', 'interp', 'FaceVertexCData', cdata, ...
                'EdgeColor','k', 'LineWidth', 1)
        end
        
        % get force acting on one muscle at one frame
        function forceMagnitude = getForceOneMuscle(obj, muscle)
            
            nodeNumbers = muscle.nodeNumbers;
            forceMagnitude = getForceOnMultipleNodes(obj, nodeNumbers);
            
        end
        
        % get force acting on every muscles of a collection at one frame
        function forceMagnitude = getForceMuscleCollection(obj, muscColl)
            
            forceMagnitude = ones(1, muscColl.nMuscles);
            for k = 1:muscColl.nMuscles
                
                nodeNumbers = muscColl.muscles(k).nodeNumbers;
                forceMagnitude(1, k) = getForceOnMultipleNodes(obj, ...
                    nodeNumbers);
            
            end
            
        end
        
        % get total force acting on a muscle collection at one frame
        function forceTotal = getForceTotalMuscleCollection(obj, muscColl)
        % total force is defined (so far) as the sum of the single forces
            
            forceMag = getForceMuscleCollection(obj, muscColl);
            forceTotal = sum(forceMag);
            
        end
        
    end
    
    
    methods (Access = private)
        
        % forces acting on a set of nodes (norm) after vector addition
        function  forceMagOut = getForceOnMultipleNodes(obj, nodeNumbers)
            % This function calculate resulting force for multiple nodes of one Muscle.
            % Note, that points have to be dependent in some way to get meaningful 
            % results.
            % Do not use this for calculation of total force. In GEPPETO total force is
            % defined as sum (plain summation) of the force magnitude of each muscle!
            
            xForceVec = [obj.forceNodes(nodeNumbers).forceInXDir];
            yForceVec = [obj.forceNodes(nodeNumbers).forceInYDir];
            
            xForceVecOut = sum(xForceVec, 2);
            yForceVecOut = sum(yForceVec, 2);

            forceMagOut = norm([xForceVecOut yForceVecOut]);
            
        end
    end
    
end
