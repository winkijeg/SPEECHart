function format_figure_acoustics(ax, formantStr)
% formats a figure (axes limits, etc.) for formant plots (F1/F2 or F2/F3)
%
% this function should be used either to format the plot in the F1/F2-plane
% (formantStr = 'F1F2') or format the F2/F3-plane (formantStr = 'F2F3').

% written 03/2012 by RW (SPRECHart); modified 09/2012 by RW (PILIOS)

axes(ax);
grid off
hold on
%legend (tractVersion)
%title ([date])

switch formantStr
    case 'F1F2'
        set (gca, 'XDir', 'reverse')
        set (gca, 'YDir', 'reverse')
        set (gca, 'XLim', [500 2500], 'YLim', [150 900])
        xlabel ('F2 [Hz] (reversed)')
        ylabel ('F1 [Hz] (reversed)')
    case 'F2F3'
        set (gca, 'XDir', 'reverse')
        set (gca, 'XLim', [500 2500], 'YLim', [1500 4500])
        xlabel ('F2 [Hz] (reversed)')
        ylabel ('F3 [Hz]')
    otherwise
        disp(['formantStr ' formantStr ' unknown ...'])
        return;
end
