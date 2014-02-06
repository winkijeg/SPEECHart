function [ r, center ] = triangle_circumcircle_2d ( t )

%% TRIANGLE_CIRCUMCIRCLE_2D computes the circumcircle of a triangle in 2D.
%
%  Discussion:
%
%    The circumcenter of a triangle is the center of the circumcircle, the
%    circle that passes through the three vertices of the triangle.
%
%    The circumcircle contains the triangle, but it is not necessarily the
%    smallest triangle to do so.
%
%    If all angles of the triangle are no greater than 90 degrees, then
%    the center of the circumscribed circle will lie inside the triangle.
%    Otherwise, the center will lie outside the triangle.
%
%    The circumcenter is the intersection of the perpendicular bisectors
%    of the sides of the triangle.
%
%    In geometry, the circumcenter of a triangle is often symbolized by "O".
%
%  Modified:
%
%    06 May 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real T(2,3), the triangle vertices.
%
%    Output, real R, CENTER(2), the circumradius and circumcenter
%    of the triangle.
%
  dim_num = 2;
%
%  Circumradius.
%
  a = sqrt ( ( t(1,2) - t(1,1) ).^2 + ( t(2,2) - t(2,1) ).^2 );
  b = sqrt ( ( t(1,3) - t(1,2) ).^2 + ( t(2,3) - t(2,2) ).^2 );
  c = sqrt ( ( t(1,1) - t(1,3) ).^2 + ( t(2,1) - t(2,3) ).^2 );

  bot = ( a + b + c ) * ( - a + b + c ) * (   a - b + c ) * (   a + b - c );

  if ( bot <= 0.0 )
    r = -1.0;
    center(1:2) = 0.0;
    return
  end

  r = a * b * c / sqrt ( bot );
%
%  Circumcenter.
%
  f(1) = ( t(1,2) - t(1,1) ).^2 + ( t(2,2) - t(2,1) ).^2;
  f(2) = ( t(1,3) - t(1,1) ).^2 + ( t(2,3) - t(2,1) ).^2;
  
  top(1) =    ( t(2,3) - t(2,1) ) * f(1) - ( t(2,2) - t(2,1) ) * f(2);
  top(2) =  - ( t(1,3) - t(1,1) ) * f(1) + ( t(1,2) - t(1,1) ) * f(2);

  det  =    ( t(2,3) - t(2,1) ) * ( t(1,2) - t(1,1) ) ...
          - ( t(2,2) - t(2,1) ) * ( t(1,3) - t(1,1) ) ;

  center(1:2) = t(1:2,1)' + 0.5 * top(1:2) / det;
