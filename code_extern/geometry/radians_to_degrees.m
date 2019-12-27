function degrees = radians_to_degrees ( radians )

%% RADIANS_TO_DEGREES converts an angle from radians to degrees.
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
%    Input, real RADIANS, an angle in radians.
%
%    Output, real DEGREES, the equivalent angle in degrees.
%
  degrees = ( radians / pi ) * 180.0;
