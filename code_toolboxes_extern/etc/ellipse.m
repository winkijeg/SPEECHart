function ellipse(center, width, height, theta, color)
 
% function ellipse(center, width, height, theta, color)
%
% render an ellipse centered at "center", with given width and height,
% rotated by angle "theta".  color is optional; default is 'r'  (red)
% (see "help plot" for more possible colors)
%
% For plotting a Gaussian, use the arguments as follows:
%
%    center: mean of the Gaussian
%    width: sqrt(dominant (larger) eigenvalue of the covariance) * scale factor
%    height: sqrt(smaller eigenvalue of the covariance) * scale factor
%    theta: angle between dominant eigenvector and x-axis
 
  if ~exist('color','var')
    color  = 'r';
  end
 
  alpha = 0:.01:2*pi;
 
  x = width*cos(alpha);
  y = height*sin(alpha);
 
  xp = x*cos(theta) + y*sin(theta);
  yp = x*sin(theta) - y*cos(theta);
 
  plot(center(1)+xp, center(2)+yp, color, 'Linewidth', 2); 