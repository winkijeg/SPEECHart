function [tout, yout] = ode45plus(ypfun, t0, tf, y0, tol, storestep)
%ODE45PLUS Solve differential equation in the same fashion as
%          Matlab 4 ODE45, except that values are stored only each
%          *storestep* secs. The trace capability has been removed.
%
%          INPUT:
%          ypfun     - String containing the name of the problem definition
%          t0        - Initial value of t
%          tf        - Final value of t
%          y0        - Initial value column-vector
%          tol       - The desired accuracy
%          storestep - The storage timestep
%
%          See ODE45, ODEFILE,... for more precisions

global ttout; % to know which t is being stored; MZ 12/30/99


% The Fehlberg coefficients:
alpha = [1/4  3/8  12/13  1  1/2]';
beta  = [ [    1      0      0     0      0    0]/4
  [    3      9      0     0      0    0]/32
  [ 1932  -7200   7296     0      0    0]/2197
  [ 8341 -32832  29440  -845      0    0]/4104
  [-6080  41040 -28352  9295  -5643    0]/20520 ]';
gamma = [ [902880  0  3953664  3855735  -1371249  277020]/7618050
  [ -2090  0    22528    21970    -15048  -27360]/752400 ]';
pow = 1/5;

if nargin < 5, tol = 1.e-6; end
if nargin < 6, storestep = 0.1; end

% Initialization
t = t0;
hmax = (tf - t)/16;
h = hmax/8;
y = y0(:);
f = zeros(length(y),6);
l = storestep;
tout(1) = t;
yout(1,:) = y.';
forcestep = 0;
ttout=[ttout; t];

% here the main loop starts ...

global kkk % RW 01/2011
global contactRW; % RW 01/2011
contactRW = 0; % RW 01/2011
global kkk_max_flag % RW 01/2011
kkk_max_flag = 0; % RW 01/2011
kkk_max = 10000; % RW 01/2011

while (t < tf) && (t + h > t) && (~contactRW) && (~kkk_max_flag) % The main loop
    
    %[h t]
    if t + h > tf
        h = tf - t
    end
  
    % Compute the slopes
    temp = feval(ypfun,t,y);
    f(:,1) = temp(:);
    for j = 1:5
        temp = feval(ypfun, t+alpha(j)*h, y+h*f*beta(:,j));
        f(:,j+1) = temp(:);
    end
  
%     t_RW01 = t;
%     t_RW02 = t;
%     
%     disp ([num2str(t_RW01) ':' num2str(t_RW02)])
%     

    % Estimate the error and the acceptable error
    delta = norm(h*f*gamma(:,2),'inf');
    tau = tol*max(norm(y,'inf'),1.0);
  
    % Update the solution only if the error is acceptable
    if ((delta <= tau) || forcestep )
        forcestep = 0;
        t = t + h;
        y = y + h*f*gamma(:,1);
        % Problems may arise if storestep is not big enough vs. h
        % ie l may "run after t" 
        if t > l
            disp ([num2str(t) 'ms'])
            l = l + storestep ;
            tout = [tout ; t];
            yout = [yout ; y.'];
            ttout=[ttout; t];
        end
    end
  
    % Update the step size
    if delta ~= 0.0
        h = min(hmax, 0.8*h*(tau/delta)^pow);
        if h < 1.0e-5
            h = 1.0e-5;
            forcestep = 1;
        end
    end
    
    kkk_max_flag = (kkk >= kkk_max); % RW 01/2011
    
end % end main loop % RW 01/2011


if (t < tf)
  disp('Singularity likely.')
  t
end

% Well, well, well... Let's try it !
 
