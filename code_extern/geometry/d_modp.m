function value = d_modp ( x, y )

%% D_MODP returns the nonnegative remainder of real division.
%
%  Formula:
%
%    If
%      REM = D_MODP ( X, Y )
%      RMULT = ( X - REM ) / Y
%    then
%      X = Y * RMULT + REM
%    where REM is always nonnegative.
%
%  Comments:
%
%    The MOD function computes a result with the same sign as the
%    quantity being divided.  Thus, suppose you had an angle A,
%    and you wanted to ensure that it was between 0 and 360.
%    Then mod(A,360.0) would do, if A was positive, but if A
%    was negative, your result would be between -360 and 0.
%
%    On the other hand, D_MODP(A,360.0) is between 0 and 360, always.
%
%  Examples:
%
%        I         J     MOD  D_MODP   D_MODP Factorization
%
%      107        50       7       7    107 =  2 *  50 + 7
%      107       -50       7       7    107 = -2 * -50 + 7
%     -107        50      -7      43   -107 = -3 *  50 + 43
%     -107       -50      -7      43   -107 =  3 * -50 + 43
%
%  Modified:
%
%    08 January 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real X, the number to be divided.
%
%    Input, real Y, the number that divides X.
%
%    Output, real VALUE, the nonnegative remainder when X is divided by Y.
%
  if ( y == 0.0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'D_MODP - Fatal error!\n' );
    fprintf ( 1, '  D_MODP ( X, Y ) called with Y = %f\n', y );
    error ( 'D_MODP - Fatal error!' );
  end

  value = mod ( x, y );

  if ( value < 0.0 )
    value = value + abs ( y );
  end
