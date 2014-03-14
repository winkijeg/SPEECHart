function cnt = initFromFrenchMatfile (cnt, source)
% INITFROMFRENCHMATFILE Initializes the contour object from 'original
% French mat files
try
    load(source)
    cnt.source = fullfile(pwd, source);
    cnt.X1 = X1;
    cnt.X2 = X2;
    cnt.X3 = X3;
    cnt.XS = XS;
    cnt.X_condyle = XS;
    cnt.Y1 = Y1;
    cnt.Y2 = Y2;
    cnt.Y3 = Y3;
    cnt.YS = YS;
    cnt.Y_condyle = XS + 8; %center of the jaw movement -- condyle point
    cnt.lowerteeth = dents_inf;
    cnt.lar_ar = lar_ar; % ???
    cnt.lowerteeth = dents_inf; % used to be dents_inf
    cnt.lowerlip = lowlip; % contour of the lower lip, used to be lowlip
    cnt.upperlip = upperlip; % contour of upper lip
    cnt.palate = palate; % contour of the palate, incl upper teeth
    cnt.upperteeth = palate(:, 1:7);
    cnt.velum = velum; % contour of the velum
    cnt.pharynx = pharynx; % contour of pharyngeal wall
    cnt.tongue_lar = tongue_lar;
catch err
    error('Contour file maybe incomplete/corrupt:\n%s',...
        err.message);
end