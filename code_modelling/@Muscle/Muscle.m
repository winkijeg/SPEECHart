classdef Muscle
    % represents a single muscle
    %   a muscle is represented by a number of single fibers
    
    properties
        
        nameLong = '';
        nameShort = '';
        nFibers = [];
        
        % every column represents one muscle fiber
        fiberNodeNumbers = [];
        
        fiberFixpoints = {};
        % if external insertion exists, then the array has format 2 x nFibers
        externalInsertionPointPosition = [];
        
        fiberLengthsAtRest = [];
        fiberMaxLengthAtRest = [];
        fiberLengthsRatio = [];
      
    end
    
    methods
        
        function obj = Muscle(muscleName, tongueMesh, landmarks)
            
            if nargin > 0
                
                switch muscleName

                    case 'VER&GGA'
                        obj.nameLong = 'verticales and anterior genioglossus';
                        obj.nameShort = 'VER_GGA';
                        obj.nFibers = 7;
                        obj.fiberNodeNumbers = [129 142 155 168 181 194 207];

                    case 'HYO'
                        obj.nameLong = 'hyoglossus';
                        obj.nameShort = 'HYO';
                        obj.nFibers = 3; % redundant !
                        obj.fiberFixpoints(1, :) = {'hyoA', 124, 165};
                        obj.fiberFixpoints(2, :) = {'hyoB', 113, []};
                        obj.fiberFixpoints(3, :) = {'hyoC', 89, []};

                        obj.externalInsertionPointPosition.hyoA = ...
                            landmarks.xyHyoA;
                        obj.externalInsertionPointPosition.hyoB = ...
                            landmarks.xyHyoB;
                        obj.externalInsertionPointPosition.hyoC = ...
                            landmarks.xyHyoC;

                        obj.fiberNodeNumbers = [89 113 165]; % redundant ??

                    case 'GGP'
                        obj.nameLong = 'posterior genioglossus';
                        obj.nameShort = 'GGP';
                        obj.nFibers = 7;

                        obj.fiberFixpoints(1, :) = num2cell(27:38);
                        obj.fiberFixpoints(2, :) = num2cell(40:51);
                        obj.fiberFixpoints(3, :) = num2cell(53:64);
                        obj.fiberFixpoints(4, :) = num2cell(66:77);
                        obj.fiberFixpoints(5, :) = num2cell(79:90);
                        obj.fiberFixpoints(6, :) = num2cell(92:103);
                        obj.fiberFixpoints(7, :) = num2cell(105:116);

                        obj.externalInsertionPointPosition = [];

                        obj.fiberNodeNumbers = []; % redundant ??

                    case 'GGA'
                        obj.nameLong = 'Anterior genioglossus';
                        obj.nameShort = 'GGA';
                        obj.nFibers = 6;

                        obj.fiberFixpoints(1, :) = num2cell(118:129);
                        obj.fiberFixpoints(2, :) = num2cell(131:142);
                        obj.fiberFixpoints(3, :) = num2cell(144:155);
                        obj.fiberFixpoints(4, :) = num2cell(157:168);
                        obj.fiberFixpoints(5, :) = num2cell(170:181);
                        obj.fiberFixpoints(6, :) = num2cell(183:194);

                        obj.externalInsertionPointPosition = [];

                        obj.fiberNodeNumbers = []; % redundant ??


                    case 'STY'
                        obj.nameLong = 'styloglossus';
                        obj.nameShort = 'STY';
                        obj.nFibers = 2;

                        obj.fiberFixpoints(1, :) = {'styloidProcess', 87, []};
                        obj.fiberFixpoints(2, :) = {'styloidProcess', 113, 190};

                        obj.externalInsertionPointPosition.styloidProcess = ...
                            landmarks.xyStyloidProcess;


                        %obj.fiberNodeNumbers = [87 190];

                   case 'VER'
                        obj.nameLong = 'Verticales';
                        obj.nameShort = 'VER';
                        obj.nFibers = 6;

                        obj.fiberFixpoints(1, :) = num2cell(137:142);
                        obj.fiberFixpoints(2, :) = num2cell(150:155);
                        obj.fiberFixpoints(3, :) = num2cell(163:168);
                        obj.fiberFixpoints(4, :) = num2cell(176:181);
                        obj.fiberFixpoints(5, :) = num2cell(189:194);
                        obj.fiberFixpoints(6, :) = num2cell(202:207);

                        obj.externalInsertionPointPosition = [];

                        % obj.fiberNodeNumbers = [142 155 168 181 194 207];

                    case 'IL'
                        obj.nameLong = 'Inferior longitudinales';
                        obj.nameShort = 'IL';
                        obj.nFibers = 1;

                        obj.fiberFixpoints(1, :) = {'hyoB', 109, 189, 217};

                        obj.externalInsertionPointPosition.hyoB = ...
                            landmarks.xyHyoB;


                        % obj.fiberNodeNumbers = 217;

                    case 'SL'
                        obj.nameLong = 'Superior longitudinales';
                        obj.nameShort = 'SL';
                        
                        obj.nFibers = 1;
                      
                        obj.fiberFixpoints(1, :) = num2cell(65:13:221);
                        
%                         obj.nFibers = 2;
% 
%                         obj.fiberFixpoints(1, :) = num2cell(65:13:221);
%                         obj.fiberFixpoints(2, :) = num2cell(64:13:220);

                        obj.externalInsertionPointPosition = [];

                        % obj.fiberNodeNumbers = [64 65 220 221];

                    otherwise
                        error('muscle name unknown ...')
                end
    
                % calculate details neccessary for each muscle
                obj.fiberLengthsAtRest = determineFiberLength(obj, tongueMesh);
                obj.fiberMaxLengthAtRest = max(obj.fiberLengthsAtRest);
                obj.fiberLengthsRatio = obj.fiberLengthsAtRest ./ obj.fiberMaxLengthAtRest;
    
            end
                        
        end
        
        lengths = determineFiberLength(obj, tongueMesh);

    end
    
end

