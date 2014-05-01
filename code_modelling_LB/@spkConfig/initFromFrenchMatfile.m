function initFromFrenchMatfile(conf, source)
% read result stocke file to get speaker specific configs

try
	load(source)
	conf.source = source;
	conf.configs = CONFIGS;

catch err

    error('Something went wrong reading the \"result stocke\" file:\n%s', err.message);
end

end
