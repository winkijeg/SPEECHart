classdef UtterancePlan
    % keep utterance specification necessary for tongue movement simulation
    %   In order to simulate tonge movement three kind of data have to be 
    %   specified:
    %
    % delta lambda commands in mm for all phonemes of the sequence except
    % the initial rest position - These values are referenced to the value
    % at rest (negativ values == activation)
    %
    % For the jaw, the lips and the larynx the time variations are made
    % according to an undamped second order model (Bell-shaped velocity profile)

    
    properties
        
        phonemes@char           % target phonemes after initial tongue rest position
        
        durTransition@double    % duration between phonemes (incl. initial rest position)
        durHold@double          % duration for all phonemes (excdept initial rest position)

        deltaLambdaGGP@double   % delta lambda value for genioglossus posterior [mm ????]
        deltaLambdaGGA@double   % delta lambda value for genioglossus anterior [mm ????]
        deltaLambdaHYO@double   % delta lambda value for hyoglossus [mm ????]
        deltaLambdaSTY@double   % delta lambda value for styloid [mm ????]
        deltaLambdaVER@double   % delta lambda value for verticales [mm ????]
        deltaLambdaSL@double    % delta lambda value for superior longitudinalis [mm ????]
        deltaLambdaIL@double    % delta lambda value for inferior longitudinalis [mm ????]

        jawRotation@double      % successive jaw rotation angles [degrees]; positiv == opening
        % These commands are not made in reference to the position at rest but to the position for the preceding phoneme

        lipProtrusion@double    % successive horizontal lip displacement [mm]; positiv == protrusion
        % These commands are not made in reference to the position at rest but to the position for the preceding phoneme.
        
        lowLipRotation@double      % successive lip rotation angles [degrees]; positiv == opening
        % These commands are not made in reference to the position at rest but to the position for the preceding phoneme
        
        hyoid_mov@double        % successive vertical epipharynx displacement [mm]; positiv == lowering
        % These commands are not made in reference to the position at rest but to the position for the preceding phoneme

    end
    
    methods
        
        function obj = UtterancePlan(phonemes)
            % Take a phoneme string as single argument, i.e. UtterancePlan('ai')
            %   the constructor then produces an utterance specification by 
            %   itializing the properties to standard values
            %   - duration == 150 ms for each target
            %   - deltaLambda == 0 for each muscle at each target
            %   - no movement of the remaining articulators
            %
            % After the object has been constructed use set-methods to 
            % refine the specification, i.e. obj.deltaLambdaGGP = [-20 0]
            % in case of two targets.
            
            if (nargin >= 1)
                
                obj.phonemes = phonemes;
                nPhonemes = length(phonemes);
                
                % standard values for time course of the utterance
                obj.durTransition = ones(1, nPhonemes) * 0.050;
                obj.durHold = ones(1, nPhonemes) * 0.100;
                
                % standard delta muscle activations               
                obj.deltaLambdaGGP = zeros(1, nPhonemes);
                obj.deltaLambdaGGA = zeros(1, nPhonemes);
                obj.deltaLambdaHYO = zeros(1, nPhonemes);
                obj.deltaLambdaSTY = zeros(1, nPhonemes);
                obj.deltaLambdaVER = zeros(1, nPhonemes);
                obj.deltaLambdaSL = zeros(1, nPhonemes);
                obj.deltaLambdaIL = zeros(1, nPhonemes);

                % standard values for the remaining articulators
                obj.jawRotation = zeros(1, nPhonemes);
                obj.lipProtrusion = zeros(1, nPhonemes);
                obj.lowLipRotation = zeros(1, nPhonemes);
                obj.hyoid_mov = zeros(1, nPhonemes);
            
            end
            
        end
        
        
    end
    
end
