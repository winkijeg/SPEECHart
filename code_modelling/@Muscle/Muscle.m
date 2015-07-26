classdef Muscle
    % represents a single muscle
    %   a muscle is represented by a number of single fibers
    
    properties
        
        nameLong = '';
        nameShort = '';
        nFibers = [];
        
        fiberFixpoints = {};
        % if external insertion exists, then the array has format 2 x nFibers
        externalInsertionPointPosition = [];
        
        % maximal / total lambda variation
        expectedLambdaVariation@double
        
        fiberLengthsAtRest = [];
        fiberMaxLengthAtRest = [];
        fiberLengthsRatio = [];
        
        % minimum length of each muscle fiber
        fiberMinLength
        
        % It is assumed that each muscle fiber provides the same force.
        % the value of rho ist proportional to the cross section area of
        % the fiber
        fiberCrossSectionalArea@double
        rho
      
    end
    
    properties (Constant)
        
        K_m = 0.22;    % in N/mm2, value obtained from Van Lunteren & al. 1990 
        
    end
    
    
    methods
        
        function obj = Muscle(muscleName, tongueMesh, landmarks)
            
            if nargin > 0
                
                switch muscleName

%                     case 'VER&GGA'
%                         obj.nameLong = 'verticales and anterior genioglossus';
%                         obj.nameShort = 'VER_GGA';
%                         obj.nFibers = 7;
%                         obj.fiberNodeNumbers = [129 142 155 168 181 194 207];

                    case 'HYO'
                        obj.nameLong = 'Hyoglossus';
                        obj.nameShort = 'HYO';
                        obj.nFibers = 3; % redundant !
                        obj.expectedLambdaVariation = 2*20;
                        obj.fiberCrossSectionalArea = 98.7;
                        
                        obj.fiberFixpoints(1, :) = {'hyoA', 124, 165};
                        obj.fiberFixpoints(2, :) = {'hyoB', 113, []};
                        obj.fiberFixpoints(3, :) = {'hyoC', 89, []};

                        obj.externalInsertionPointPosition.hyoA = ...
                            landmarks.xyHyoA;
                        obj.externalInsertionPointPosition.hyoB = ...
                            landmarks.xyHyoB;
                        obj.externalInsertionPointPosition.hyoC = ...
                            landmarks.xyHyoC;

                    case 'GGP'
                        obj.nameLong = 'Genioglossus posterior';
                        obj.nameShort = 'GGP';
                        obj.nFibers = 7;
                        obj.expectedLambdaVariation = 2*20;
                        obj.fiberCrossSectionalArea = 23.7;

                        obj.fiberFixpoints(1, :) = num2cell(27:38);
                        obj.fiberFixpoints(2, :) = num2cell(40:51);
                        obj.fiberFixpoints(3, :) = num2cell(53:64);
                        obj.fiberFixpoints(4, :) = num2cell(66:77);
                        obj.fiberFixpoints(5, :) = num2cell(79:90);
                        obj.fiberFixpoints(6, :) = num2cell(92:103);
                        obj.fiberFixpoints(7, :) = num2cell(105:116);

                        obj.externalInsertionPointPosition = [];

                    case 'GGA'
                        obj.nameLong = 'Genioglossus anterior';
                        obj.nameShort = 'GGA';
                        obj.nFibers = 6;
                        obj.expectedLambdaVariation = 2*20;
                        obj.fiberCrossSectionalArea = 23.7;

                        obj.fiberFixpoints(1, :) = num2cell(118:129);
                        obj.fiberFixpoints(2, :) = num2cell(131:142);
                        obj.fiberFixpoints(3, :) = num2cell(144:155);
                        obj.fiberFixpoints(4, :) = num2cell(157:168);
                        obj.fiberFixpoints(5, :) = num2cell(170:181);
                        obj.fiberFixpoints(6, :) = num2cell(183:194);

                        obj.externalInsertionPointPosition = [];


                    case 'STY'
                        obj.nameLong = 'Styloglossus';
                        obj.nameShort = 'STY';
                        obj.nFibers = 2;
                        obj.expectedLambdaVariation = 2*20;
                        obj.fiberCrossSectionalArea = 20.0;

                        obj.fiberFixpoints(1, :) = {'styloidProcess', 87, []};
                        obj.fiberFixpoints(2, :) = {'styloidProcess', 113, 190};

                        obj.externalInsertionPointPosition.styloidProcess = ...
                            landmarks.xyStyloidProcess;

                   case 'VER'
                        obj.nameLong = 'Vertical';
                        obj.nameShort = 'VER';
                        obj.nFibers = 6;
                        obj.expectedLambdaVariation = 2*10;
                        obj.fiberCrossSectionalArea = 11.0;

                        obj.fiberFixpoints(1, :) = num2cell(137:142);
                        obj.fiberFixpoints(2, :) = num2cell(150:155);
                        obj.fiberFixpoints(3, :) = num2cell(163:168);
                        obj.fiberFixpoints(4, :) = num2cell(176:181);
                        obj.fiberFixpoints(5, :) = num2cell(189:194);
                        obj.fiberFixpoints(6, :) = num2cell(202:207);

                        obj.externalInsertionPointPosition = [];

                    case 'SL'
                        obj.nameLong = 'Superior longitudinal';
                        obj.nameShort = 'SL';
                        
                        obj.nFibers = 1;
                        obj.expectedLambdaVariation = 2*20;
                        obj.fiberCrossSectionalArea = 65.0;
                      
                        obj.fiberFixpoints(1, :) = num2cell(65:13:221);
                        %obj.fiberFixpoints(2, :) = num2cell(64:13:220);

                        obj.externalInsertionPointPosition = [];

                    case 'IL'
                        obj.nameLong = 'Inferior longitudinal';
                        obj.nameShort = 'IL';
                        obj.nFibers = 1;
                        obj.expectedLambdaVariation = 2*20;
                        obj.fiberCrossSectionalArea = 88.0;

                        obj.fiberFixpoints(1, :) = {'hyoB', 109, 189, 217};

                        obj.externalInsertionPointPosition.hyoB = ...
                            landmarks.xyHyoB;

                    otherwise
                        error('muscle name unknown ...')
                end
    
                % calculate details neccessary for each muscle
                obj.fiberLengthsAtRest = determineFiberLength(obj, tongueMesh);
                obj.fiberMaxLengthAtRest = max(obj.fiberLengthsAtRest);
                obj.fiberLengthsRatio = obj.fiberLengthsAtRest ./ obj.fiberMaxLengthAtRest;
                obj.fiberMinLength = ...
                    (obj.fiberMaxLengthAtRest - obj.expectedLambdaVariation / 2) ...
                    * obj.fiberLengthsRatio;
                
                obj.rho = obj.fiberCrossSectionalArea * obj.K_m;
    
            end
                        
        end
        
        lengths = determineFiberLength(obj, tongueMesh);

    end
    
end

