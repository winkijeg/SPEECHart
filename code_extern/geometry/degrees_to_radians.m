function radians = degrees_to_radians ( degrees )

%% DEGREES_TO_RADIANS converts an angle from degrees to radians.
%
%  Modified:
%
%    13 June 2004
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real DEGREES, an angle in degrees.
%
%    Output, real RADIANS, the equivalent angle in radians.
%
  radians = ( degrees / 180.0 ) * pi;
