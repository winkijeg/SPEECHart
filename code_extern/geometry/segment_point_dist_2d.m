function dist = segment_point_dist_2d ( p1, p2, p )

%% SEGMENT_POINT_DIST_2D: distance ( line segment, point ) in 2D.
%
%  Discussion:
%
%    A line segment is the finite portion of a line that lies between
%    two points.
%
%    The nearest point will satisfy the condition
%
%      PN = (1-T) * P1 + T * P2.
%
%    T will always be between 0 and 1.
%
%  Modified:
%
%    03 May 2006
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real P1(2), P2(2), the endpoints of the line segment.
%
%    Input, real P(2), the point whose nearest neighbor on the line
%    segment is to be determined.
%
%    Output, real DIST, the distance from the point to the line segment.
%
  dim_num = 2;
%
%  If the line segment is actually a point, then the answer is easy.
%
  if ( p1(1:dim_num) == p2(1:dim_num) )

    t = 0.0;

  else

    bot = sum ( ( p2(1:dim_num) - p1(1:dim_num) ).^2 );

    t = ( p(1:dim_num) - p1(1:dim_num) ) ...
      * ( p2(1:dim_num) - p1(1:dim_num) )' / bot;

    t = max ( t, 0.0 );
    t = min ( t, 1.0 );

  end

  pn(1:dim_num) = p1(1:dim_num) + t * ( p2(1:dim_num) - p1(1:dim_num) );

  dist = sqrt ( sum ( ( pn(1:dim_num) - p(1:dim_num) ).^2 ) );
