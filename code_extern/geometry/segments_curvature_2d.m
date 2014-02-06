function curvature = segments_curvature_2d ( p1, p2, p3 )
% SEGMENTS_CURVATURE_2D computes the curvature of two line segments in 2D.
%
%  Discussion:
%
%    We assume that the segments [P1,P2] and [P2,P3] are given.
%
%    We compute the circle that passes through P1, P2 and P3.
%
%    The inverse of the radius of this circle is the local "curvature".
%
%    If curvature is 0, the two line segments have the same slope,
%    and the three points are collinear.
%
%  Modified:
%
%    14 March 2006
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real P1(2), P2(2), P3(2), the points.
%
%    Output, real CURVATURE, the local curvature.
%
[ r, pc ] = circle_exp2imp_2d ( p1, p2, p3 );

if ( 0.0 < r )
  curvature = 1.0 / r;
else
  curvature = 0.0;
end
