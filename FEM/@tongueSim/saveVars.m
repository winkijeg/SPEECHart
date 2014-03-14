function command = saveVars(fileName, varargin)
	%SAVEVARS save variables with given names to file 
	nVar = length(varargin);
	if (mod(nVar, 2) ~= 0)
		error('Bad input arguments'); 
	end

	names = varargin(1:2:nVar);
	values = varargin(2:2:nVar);

	for i = 1:length(names)
		assignin('caller', names{i}, values{i});
	end

	command = ['save ' fileName ' ' strjoin(names, ' ')];
end
