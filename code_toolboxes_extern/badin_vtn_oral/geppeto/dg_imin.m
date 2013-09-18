function [z,I] = dg_imin(x,varargin)
%IMIN    Minimum interpolated value.
%   Works as MIN except that interpolations are performed on three
%   consecutive points to provide a (likely) more realistic minimum.
%
%   For vectors, IMIN(X) is the smallest interpolated element in X. For
%   matrices, IMIN(X) is a row vector containing the interpolated minimum
%   element from each column. For N-D arrays, IMIN(X) operates along the
%   first non-singleton dimension.
%
%   [Y,I] = IMIN(X) returns the locations of the interpolated minimum
%   values in a floating-point array I. For example, I = 1.5 means that the
%   interpolated minimum is located at the middle of the [1 2] segment. If
%   the values along the first non-singleton dimension contain more than
%   one interpolated minimal element, the index of the first one is
%   returned. 
%
%   [Y,I] = IMIN(X,[],DIM) operates along the dimension DIM. 
%
%   IMIN(X,Y) does not interpolate and makes the same as MIN(X,Y). It
%   returns an array the same size as X and Y with the smallest elements
%   taken from X or Y. Either one can be a scalar.
%
%   When X is complex, IMIN does not interpolate and makes the same as MIN.
%   The minimum is computed using the magnitude MIN(ABS(X)). In the case of
%   equal magnitude elements, then the phase angle MIN(ANGLE(X)) is used.
%
%   NaN's are ignored when computing the interpolated minimum. When all
%   elements in X are NaN's, then the first one is returned as the
%   interpolated minimum.
%
%   Note:
%   ----
%   The interpolations are performed using parabolas on 3 consecutive
%   points.
%   
%   Example:
%   -------
%   x = [2 8 4;7 3 9];
%   imin(x,[],2)  % returns [2;2.95]
%
%   x = [100 36 4 4 36 100];
%   % compare MIN and IMIN
%   [z,I] = min(x)  % returns 4 and 3
%   [z,I] = imin(x) % returns 0 and 3.5
%
%   See also MIN, IMAX
%
%   -- Damien Garcia -- 2007/11

if nargin==2
    y = varargin{1};
elseif nargin==3;
    y = varargin{1};
    dim = varargin{2};
end

%% Use MIN if nargin=2 or if X is complex
if nargin==2 || ~isreal(x)
    try
        if nargout<2
            z = max(x,varargin{:});
        else
            [z,I] = max(x,varargin{:});
        end
        return
    catch
        rethrow(disp_err)
    end        
end

%% Shift dimension in order to work on rows
perm = []; nshifts = 0;
if nargin == 3 % imin(y,[],dim)
    if ~isempty(y)
        try
            % create an error...
            min(x,y,dim)
        catch
            % ...and display it
            rethrow(disp_err)
        end
    end
    y = x; clear x
    perm = [dim:max(ndims(y),dim) 1:dim-1];
    y = permute(y,perm);
else % imin(y)
    y = x; clear x
    [y,nshifts] = shiftdim(y);
end

%% Y must be a floating point array
if ~isfloat(y)
    error('Y must be a single or double array.')
end

%% Special case if Y is empty
if isempty(perm) && isequal(y,[])
  [z,I] = min(y);
  return;
end

%% Seek the extrema of the fitting parabolas
warn0 = warning('query','MATLAB:divideByZero');
warning('off','MATLAB:divideByZero')

y0 = y;
% Seek the extrema of the parabola P(x) defined by 3 consecutive points
% so that P([-1 0 1]) = [y1 y2 y3]
y1 = y(1:end-2,:);
y2 = y(2:end-1,:);
y3 = y(3:end,:);
y(2:end-1,:) = -(y3-y1).^2/8./(y1+y3-2*y2)+y2;

% ... and their corresponding normalized locations
I = zeros(size(y));
I(2:end-1,:) = (y1-y3)./(2*y1+2*y3-4*y2);

warning(warn0.state,'MATLAB:divideByZero')

%% Interpolated minima...
% if locations are not within [-1,1], calculated extrema are ignored
test = I<=-1|I>=1|isnan(y);
y(test) = y0(test);
try
    [z,I0] = min(y);
catch
    rethrow(disp_err)
end

% ...and their corresponding location
siz = size(y);
I = I(sub2ind(siz,I0(:)',1:length(I0)))+I0(:)';

%% Resizing
siz(1) = 1;
z = reshape(z,[ones(1,nshifts),siz]);
if ~isempty(perm), z = ipermute(z,perm); end

I = reshape(I,size(z));

%% Replace the standard error messages from MIN
function err = disp_err
err = lasterror;
err.message = regexprep(err.message,'min','imin','preservecase');

