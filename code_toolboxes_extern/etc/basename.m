function [bname, xtent] = basename(s)
% basename.m finds out the basename and extension of a full filename
% 
% example: If a filename is speech.dat
%     then the basename is 'speech'
%     and the extention is 'dat'
%
%From analysis software package
%Changes made by Karthik 2/98


len=length(s);
for i=1:len,
	if s(i) == '.';
		break;
	end
end

bname=s(1:i-1);

if exist('i') && i == 1,
	bname='';
	xtent=s(i+1:len);
elseif exist('i') && i == len
	bname=s;
	xtent='';
else
	bname=s(1:i-1);
	xtent=s(i+1:len);
end
bname = lower(bname);
