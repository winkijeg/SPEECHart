% fast_rotate Demo.
% The function imrotate(I,ang,'crop') does the same as fast_rotate(I,ang),
% but alot faster.
%
% Tested on Windows XP and Ubuntu 7 with Matlab 7, VC6 and gcc++.
%

myImg = imread('circuit.tif');


tic
for (ii = 1:10)
    b = fast_rotate(myImg,ii);
end
disp(['fast_rotate - ' num2str(toc/ii) ' seconds per picture']);

figure
imshow(b);

