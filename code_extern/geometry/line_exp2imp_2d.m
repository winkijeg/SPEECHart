function [ a, b, c ] = line_exp2imp_2d ( p1, p2 )

%% LINE_EXP2IMP_2D converts an explicit line to implicit form in 2D.
%
%  Discussion:
%
%    The explicit form of a line in 2D is:
%
%      ( P1, P2 ) = ( (X1,Y1), (X2,Y2) ).
%
%    The implicit form of a line in 2D is:
%
%      A * X + B * Y + C = 0
%
%  Modified:
%
%    28 February 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real P1(2), P2(2), two points on the line.
%
%    Output, real A, B, C, the implicit form of the line.
%
  dim_num = 2;
%
%  Take care of degenerate cases.
%
  if ( p1(1:dim_num) == p2(1:dim_num) )
    fprintf ( 1, '\n' );
    fprintf ( 1,  'LINE_EXP2IMP_2D - Fatal error!\n' );
    fprintf ( 1,  '  P1 = P2\n' );
    fprintf ( 1,  '  P1 = %f  %f\n', p1(1:dim_num) );
    fprintf ( 1,  '  P2 = %f  %f\n', p2(1:dim_num) );
    error ( 'LINE_EXP2IMP_2D - Fatal error!' );
  end

  a = p2(2) - p1(2);
  b = p1(1) - p2(1);
  c = p2(1) * p1(2) - p1(1) * p2(2);

  norm = a * a + b * b + c * c;

  if ( 0.0 < norm )
    a = a / norm;
    b = b / norm;
    c = c / norm;
  end

  if ( a < 0.0 )
    a = -a;
    b = -b;
    c = -c;
  end

