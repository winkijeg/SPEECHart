classdef vtcontour
    %VTCONTOUR Representation of vocal tract contours
    %   The properties of instances are typically read from mat files
    
    properties
        source % Name of the data source (e.g. mat file name)
        X1; X2; X3; X_condyle;
        Y1; Y2; Y3; YS; Y_condyle;
        meanx_deviation; % used to be ecarts_meanx
        meany_deviation; % used to be ecarts_meany
        lar_ar; % ???
        lowerteeth; % used to be dents_inf
        lowerlip; % contour of the lower lip, used to be lowlip
        upperlip; % contour of upper lip
        palate; % contour of the palate, incl upper teeth
        velum; % contour of the velum
        pharynx; % contour of pharyngeal wall
        tongue_lar; % tongue contour from tip to larynx       
    end
    
    methods
        function cnt = vtcontour(source, type)
            %VTCONTOUR construct a vocal tract contour object
            %   CNT = VTCONTOUR(SOURCE, TYPE)
            %   A vocal tract contour object is constructed from the data
            %   given by SOURCE. TYPE specifies the type of source.
            %   Currently, the only supported type is 'frenchmat', i.e. a
            %   mat file as supplied to the author with the original test
            %   case (spec_pp_FF1/data_palais_repos_pp_FF1.mat).
            %   'frenchmat' is currently the default and need not be
            %   specified.
            %   Lasse Bombien (Oct 21 2013)
            if (nargin == 1)
                type = 'frenchmat';
            end
            
            if (strcmp(type,'frenchmat'))
                cnt = cnt.initFromFrenchMatfile(source);
            else
                error('Unknown contour contructor type');
            end
        end
        
        cnt = initFromFrenchMatfile(cnt, source);
        
        function plot(cnt)
            % PLOT plot a vtcontour object
            cntNames = properties(cnt); % get names of all properties
            oldHold = ishold();
            if (~oldHold) % set hold on if not already
                hold('on');
            end
            for i=1:numel(cntNames) % loop through properties
                cur=cntNames{i};
                if (size(cnt.(cur),1)~=2)
                    continue;
                end;
                plot(cnt.(cur)(1,:), cnt.(cur)(2,:));
            end
            plot(cnt.X1, cnt.Y1, 'o', 'MarkerSize', 10);
            plot(cnt.X2, cnt.Y2, 'o', 'MarkerSize', 10);
            plot(cnt.X3, cnt.Y3, 'o', 'MarkerSize', 10);
            plot(cnt.X_condyle, cnt.Y_condyle, 'o', 'MarkerSize', 10);
            if (~oldHold) % set hold off if necessary
                hold('off');
            end
        end
    end
    
end

