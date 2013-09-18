function a = jerkinterpN(zi,zf,N);
%Author: Brad Story
%

for n=1:N
    b = n/N;
    b3 = b .* b .* b;
    b4 = b3 .* b;
    b5 = b4 .* b;
    
    foo = zf - zi;
    a(n) = zi + foo*(10*b3 - 15*b4 + 6*b5);
end

a = a';