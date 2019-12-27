function p4 = line_exp_perp_2d ( p1, p2, p3 )

%% LINE_EXP_PERP_2D computes a line perpendicular to a line and through a point.
%
%  Discussion:
%
%    The explicit form of a line in 2D is:
%
%      ( P1, P2 ) = ( (X1,Y1), (X2,Y2) ).
%
%    The input point P3 should NOT lie on the line (P1,P2).  If it
%    does, then the output value P4 will equal P3.
%
%    P1-----P4-----------P2
%            |
%            |
%           P3
%
%    P4 is also the nearest point on the line (P1,P2) to the point P3.
%
%  Modified:
%
%    02 February 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real P1(2), P2(2), two points on the line.
%
%    Input, real P3(2), a point (presumably not on the 
%    line (P1,P2)), through which the perpendicular must pass.
%
%    Output, real P4(2), a point on the line (P1,P2),
%    such that the line (P3,P4) is perpendicular to the line (P1,P2).
%
  dim_num = 2;

  bot = sum ( ( p2(1:dim_num) - p1(1:dim_num) ).^2 );

  if ( bot == 0.0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'LINE_EXP_PERP_2D - Fatal error!\n' );
    fprintf ( 1, '  The points P1 and P2 are identical.\n' );
    error ( 'LINE_EXP_PERP_2D - Fatal error!' );
  end
%
%  (P3-P1) dot (P2-P1) = Norm(P3-P1) * Norm(P2-P1) * Cos(Theta).
%
%  (P3-P1) dot (P2-P1) / Norm(P3-P1)**2 = normalized coordinate T
%  of the projection of (P3-P1) onto (P2-P1).
%
  t = sum ( ( p1(1:dim_num) - p3(1:dim_num) ) .* ( p1(1:dim_num) - p2(1:dim_num) ) ) / bot;

  p4(1:dim_num) = p1(1:dim_num) + t * ( p2(1:dim_num) - p1(1:dim_num) );
