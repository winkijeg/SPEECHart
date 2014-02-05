classdef spkConfig < handle
% SPKCONFIG class representing the ocntents of the obscure result stocke file

properties
	source;
	configs;
end

methods
	function conf = spkConfig(source, type)
		%SPKCONFIG construct rge SPKCONFIG object usually by reading the contents of the result stocke (??) file
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