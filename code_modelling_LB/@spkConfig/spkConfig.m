classdef spkConfig < handle
    % represent the content of the result stocke file

properties
	source;
	configs;
end

methods
	function conf = spkConfig(source, type)
		
        if (nargin == 1)
			type = 'frenchmat';
        end
        
		if (strcmp(type, 'frenchmat'))
			conf.initFromFrenchMatfile(source);
		end
	end

	initFromFrenchMatfile(conf, source);
end

end