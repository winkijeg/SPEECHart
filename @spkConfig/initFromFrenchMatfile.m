function initFromFrenchMatfile(conf, source)
%INITFROMFRENCHMATFILE read result stocke file to get speaker specific configs
try
	load(source)
	conf.source = source;
	conf.configs = CONFIGS;
	conf.confnom = CONFNOM;
	conf.files = FICHIERS;
catch err
	error('Something went wrong reading the \"result stocke\" file:\n%s', err.message);
end
end
