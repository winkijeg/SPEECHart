classdef restPos < handle
%RESTPOS A representation of the tongue in rest position
%   Restpositions are typically loaded from a file which includes a
%   representation of the the tongue in terms of a 9x7 grid. 
%   PLEASE CHECK THIS:
%   First row represents 'hyoid border', last row represents sublingual
%   surface, first column represents tongue surface, last column represents
%   'mandibular symphysis border'.

    properties
       source;
       X_rest; % X components/coordinates of the 9x7 grid
       Y_rest; % Y components/coordinates of the 9x7 grid
       % Proportionality factor between the lambdas of fibres of the
       % same muscle
       fac_GGA;   % Proportionality factor genioglossus anterior
       fac_GGP;   % Proportionality factor genioglossus posterior
       fac_Hyo;   % Proportionality factor hyoglossus
       fac_IL;    % Proportionality factor longitudinalis inferior
       fac_SL;    % Proportionality factor longitudinalis superior
       fac_Stylo; % Proportionality factor styloglossus
       fac_Vert;  % Proportionality factor vertical genioglossus fibers
       % maximum fibre lengths at rest
       max_restLength_GGA; % maximum length at rest for GGA
       max_restLength_GGP; % maximum length at rest for GGP
       max_restLength_Hyo; % maximum length at rest for Hyo
       max_restLength_IL; % maximum length at rest for IL
       max_restLength_SL; % maximum length at rest for SL
       max_restLength_Stylo; % maximum length at rest for Stylo
       max_restLength_Vert; % maximum length at rest for Vert
       % scaling and collapsing
       fact = -1; % Scaling factor, to be passed to method interpolate
       X0   = []; % Upscaled/interpolated X_rest
       Y0   = []; % Upscaled/interpolated Y_rest
       XY   = []; % collapsed [X0; Y0]'
       NN; MM;

    end
    methods
        function rp = restPos(source, type)
           %RESTPOS Construct restposition object
           %   RP = RESTPOS(SOURCE,TYPE)
           %   A rest position object is created from the data in SOURCE.
           %   SOURCE is specified by TYPE. Currently only one type is
           %   supported: 'frenchmat', i.e. the path to a mat file in the
           %   format provided with the original test suite
           %   Lasse Bombien (Oct 21 2013)
           if (nargin == 1)
               type = 'frenchmat';
           end
           if strcmp(type, 'frenchmat')
               rp = rp.initFromFrenchMatfile(source);
           else
               error('Unknown restPos constructor type');
           end
        end
        
        rp = initFromFrenchMatfile(rp, source);
        rp = interpolate(rp, fact);
        
        function plot(rp)
            oldHold = ishold();
            if (~oldHold) % set hold on if not already
                hold('on');
            end
            % use interpolated values if present
            if (isempty(rp.X0) || isempty(rp.Y0))
                xx = 'X_rest'; yy = 'Y_rest';
            else
                xx = 'X0'; yy = 'Y0';
            end
            for m=1:size(rp.(xx),1)
                plot(rp.(xx)(m,:), rp.(yy)(m,:));
            end
            for n=1:size(rp.(xx),2)
                plot(rp.(xx)(:,n), rp.(yy)(:,n));
            end
            if (~oldHold) % set hold off if necessary
                hold('off');
            end
        end
    end
end