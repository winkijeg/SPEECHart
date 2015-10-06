function [tout, yout] = ode45plus(ypfun, t0, tf, y0, tol, storestep)
%ODE45PLUS Solve differential equation in the same fashion as
%          Matlab 4 ODE45, except that values are stored only each
%          *storestep* secs. The trace capability has been removed.
%
%          INPUT:
%          ypfun     - function handle of the problem definition
%          t0        - Initial value of t
%          tf        - Final value of t
%          y0        - Initial value column-vector
%          tol       - The desired accuracy
%          storestep - The storage timestep
%
%          See ODE45, ODEFILE,... for more precisions

    %to know which t is being stored; MZ 12/30/99
    global ttout

    % The Fehlberg coefficients
    alpha = [1/4  3/8  12/13  1  1/2]';

    beta  = [ [    1      0      0     0      0    0]/4
        [    3      9      0     0      0    0]/32
        [ 1932  -7200   7296     0      0    0]/2197
        [ 8341 -32832  29440  -845      0    0]/4104
        [-6080  41040 -28352  9295  -5643    0]/20520 ]';

    gamma = [ [902880  0  3953664  3855735  -1371249  277020]/7618050
        [ -2090  0    22528    21970    -15048  -27360]/752400 ]';

    pow = 1/5;

    t = t0;
    hmax = (tf - t) / 16;
    h = hmax / 8;
    y = y0(:);
    f = zeros(length(y),6);
    l = storestep;
    tout(1) = t;
    yout(1,:) = y.';
    forcestep = 0;
    ttout = [ttout; t];

    % here the main loop starts ...
    while (t < tf) && (t + h > t)
    
        if ((t+h) > tf)
            h = tf - t;
        end
    
        % compute the slopes
        temp = feval(ypfun,t,y);
        f(:,1) = temp(:);
        for j = 1:5
            temp = feval(ypfun, t+alpha(j)*h, y+h*f*beta(:,j));
            f(:,j+1) = temp(:);
        end
    
        % estimate the error and the acceptable error
        delta = norm(h*f*gamma(:,2), 'inf');
        tau = tol * max(norm(y, 'inf'), 1.0);
    
        % update the solution only if the error is acceptable
        if ((delta <= tau) || forcestep)
            forcestep = 0;
            t = t + h;
            y = y + (h * f * gamma(:,1));
            % problems may arise if storestep is not big enough vs. h
            % ie l may "run after t"
            if t > l
                cprintf('red', '%s ms \n', num2str(t,'%1.4f'));
                l = l + storestep ;
                tout = [tout ; t];
                yout = [yout ; y.'];
                ttout = [ttout; t];
            end
        end
    
        % update step size
        if delta ~= 0.0
            h = min(hmax, 0.8*h*(tau/delta)^pow);
            if h < 0.00001
                h = 0.00001;
                forcestep = 1;
            end
        end
    end
    
    if (t < tf)
        cprint('err', 'Singularity likely at %f ms ...\n', t)
    end

end
