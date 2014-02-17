function b = tmat_scale ( a, s )

%% TMAT_SCALE applies a scaling to the geometric transformation matrix.
%
%  Modified:
%
%    21 February 2005
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Foley, van Dam, Feiner, Hughes,
%    Computer Graphics, Principles and Practice,
%    Addison Wesley, Second Edition, 1990.
%
%  Parameters:
%
%    Input, real A(4,4), the current geometric transformation
%    matrix.
%
%    Input, real S(3), the scalings to be applied to the 
%    X, Y and Z coordinates.
%
%    Output, real B(4,4), the modified geometric transformation
%    matrix.  A and B may share the same memory.
%
  c = tmat_init ( 'DUMMY' );

  c(1,1) = s(1);
  c(2,2) = s(2);
  c(3,3) = s(3);

  b(1:4,1:4) = c(1:4,1:4) * a(1:4,1:4);
