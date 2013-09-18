function ptPhysio = read_fiducialList(fn_in)
% reads fiducial list (slicer 3d, RAS) ti be used in MatLab (LPS) 
%

% written 09/2011 by RW (SPRECHart)

fid = fopen(fn_in);

% read data points (number of lines equals number of fiducial points)
fContent = textscan(fid, '%s %f %f %f %f %f',...
    'HeaderLines', 18, 'delimiter', ',');

fclose(fid);

attributesTmp = fContent{1};
xyzTmp(:,1:3) = [fContent{2} fContent{3} fContent{4}];

nAttributes = size(attributesTmp, 1);
for k = 1:nAttributes
    ptTmp(1, 1:3) = ras2lps(xyzTmp(k, 1:3)');
    ptPhysio.(attributesTmp{k}) = ptTmp;
end

