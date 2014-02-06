function spline(n,order)

% function spline(n,order)
%
% Plots the B-slpine-curve of n control-points.
% The control points can be chosen by clicking
% with the mouse on the figure.
%
% COMMAND:  spline(n,order)
% INPUT:    n     Number of Control-Points
%           order Order ob B-Splines
%                 Argnument is arbitrary
%                 default: order = 4
%
% Date:     2007-11-28
% Author:   Stefan Hüeber

close all;
if (nargin ~= 2)
	order = 4;
end


if (n < order)
	display([' !!! Error: Choose n >= order=',num2str(order),' !!!']);
	return;
end

figure(1);
set(gca, 'XLim', [0 10])
hold on; box on;
set(gca,'Fontsize',16);

for i = 1:n	
	title(['Choose ',num2str(i),' th. control point']);
	p(i, :) = ginput(1);
	hold off;
	plot(p(:,1),p(:,2),'k-','LineWidth',2);
	axis([0 1 0 1]);
	hold on; box on;
    
	if (i  >= order) 
		T = linspace(0, 1, i-order+2);
		y = linspace(0, 1, 1000);
		
        p_spl = deboor_tuned(T, p, y, order);
        
		plot(p_spl(:,1), p_spl(:,2), 'b.', 'LineWidth', 2);
    end
    
    plot(p(:,1),p(:,2),'ro','MarkerSize',5,'MarkerFaceColor','r');

end
