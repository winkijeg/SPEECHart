function [ r, pc ] = circle_exp2imp_2d ( p1, p2, p3 )

%% CIRCLE_EXP2IMP_2D converts a circle from explicit to implicit form in 2D.
%
%  Discussion:
%
%    The explicit form of a circle in 2D is:
%
%      The circle passing through points P1, P2 and P3.
%
%    Points P on an implicit circle in 2D satisfy the equation:
%
%      ( P(1) - PC(1) )**2 + ( P(2) - PC(2) )**2 = R**2
%
%    Any three points define a circle, as long as they don't lie on a straight
%    line.  (If the points do lie on a straight line, we could stretch the
%    definition of a circle to allow an infinite radius and a center at
%    some infinite point.)
%
%    The diameter of the circle can be found by solving a 2 by 2 linear system.
%    This is because the vectors P2 - P1 and P3 - P1 are secants of the circle,
%    and each forms a right triangle with the diameter.  Hence, the dot product
%    of P2 - P1 with the diameter is equal to the square of the length
%    of P2 - P1, and similarly for P3 - P1.  These two equations determine the
%    diameter vector originating at P1.
%
%    If all three points are equal, return a circle of radius 0 and
%    the obvious center.
%
%    If two points are equal, return a circle of radius half the distance
%    between the two distinct points, and center their average.
%
%  Modified:
%
%    14 March 2006
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Joseph O'Rourke,
%    Computational Geometry,
%    Cambridge University Press,
%    Second Edition, 1998, page 187.
%
%  Parameters:
%
%    Input, real P1(2), P2(2), P3(2), three points on the circle.
%
%    Output, real R, the radius of the circle.  Normally, R will
%    be positive.  R will be (meaningfully) zero if all three points are
%    equal.  If two points are equal, R is returned as the distance between
%    two nonequal points.  R is returned as -1 in the unlikely event that
%    the points are numerically collinear; philosophically speaking, R
%    should actually be "infinity" in this case.
%
%    Output, real PC(2), the center of the circle.
%
  dim_num = 2;
%
%  If all three points are equal, then the
%  circle of radius 0 and center P1 passes through the points.
%
  if ( all ( p1(1:dim_num) == p2(1:dim_num) ) & ...
       all ( p1(1:dim_num) == p3(1:dim_num) ) )
    r = 0.0;
    pc(1:dim_num) = p1(1:dim_num);
    return
  end
%
%  If exactly two points are equal, then the circle is defined as
%  having the obvious radius and center.
%
  if ( all ( p1(1:dim_num) == p2(1:dim_num) ) )

    r = 0.5 * sqrt ( sum ( ( p1(1:dim_num) - p3(1:dim_num) )^2 ) );
    pc(1:dim_num) = 0.5 * ( p1(1:dim_num) + p3(1:dim_num)  );
    return

  elseif ( all ( p1(1:dim_num) == p3(1:dim_num) ) )

    r = 0.5 * sqrt ( sum ( ( p1(1:dim_num) - p2(1:dim_num) ).^2 ) );
    pc(1:dim_num) = 0.5 * ( p1(1:dim_num) + p2(1:dim_num)  );
    return

  elseif ( all ( p2(1:dim_num) == p3(1:dim_num) ) )

    r = 0.5 * sqrt ( sum ( ( p1(1:dim_num) - p2(1:dim_num) ).^2 ) );
    pc(1:dim_num) = 0.5 * ( p1(1:dim_num) + p2(1:dim_num)  );
    return

  end
%
%  We check for collinearity.  A more useful check would compare the
%  absolute value of G to a small quantity.
%
  e = ( p2(1) - p1(1) ) * ( p1(1) + p2(1) ) ...
    + ( p2(2) - p1(2) ) * ( p1(2) + p2(2) );

  f = ( p3(1) - p1(1) ) * ( p1(1) + p3(1) ) ...
    + ( p3(2) - p1(2) ) * ( p1(2) + p3(2) );

  g = ( p2(1) - p1(1) ) * ( p3(2) - p2(2) ) ...
    - ( p2(2) - p1(2) ) * ( p3(1) - p2(1) );

  if ( g == 0.0 )
    pc(1:2) = [ 0.0, 0.0 ];
    r = -1.0;
    return
  end
%
%  The center is halfway along the diameter vector from (X1,Y1).
%
  pc(1) = 0.5 * ( ( p3(2) - p1(2) ) * e - ( p2(2) - p1(2) ) * f ) / g;
  pc(2) = 0.5 * ( ( p2(1) - p1(1) ) * f - ( p3(1) - p1(1) ) * e ) / g;
%
%  Knowing the center, the radius is now easy to compute.
%
  r = sqrt ( sum ( ( p1(1:dim_num) - pc(1:dim_num) ).^2 ) );
