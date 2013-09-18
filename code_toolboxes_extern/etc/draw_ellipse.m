function draw_ellipse(ax, targetLab, ellipseString, colStr)
% draws an ellipse according to a target label
%
% draws an ellipse according to an target label ('targetLab') and an
% specification which formants should be used ('F1F2' or 'F2F3').
%
% The latter one is only used for testing during development ...

% written 09/2012 by RW (PILIOS)

[meansOut, sdsOut, sdsRotatedOut, thetaOut] = get_formantSpec_from_definition(targetLab);

switch ellipseString
    case 'F1F2'
        center = [meansOut(2) meansOut(1)]; % format [x y]
        a_parallel = sdsOut(2);  % format [x y]
        b_parallel = sdsOut(1); % format [x y]
        a_rotated = sdsRotatedOut(2);
        b_rotated = sdsRotatedOut(1);
        theta = thetaOut(1);
        thetaRadians = degrees_to_radians(theta);
        
        axes(ax)
        ellipse(center, a_rotated, b_rotated, thetaRadians, colStr);
%         hold on
%         ellipse(center, a_parallel, b_parallel, 0, 'k--');
%         rectangle('Position', [meansOut(2)-a_parallel ...
%             meansOut(1)-b_parallel 2*a_parallel 2*b_parallel])
        
    case 'F2F3'
        
        center = [meansOut(2) meansOut(3)]; % format [x y]
        a_parallel = sdsOut(2);  % format [x y]
        b_parallel = sdsOut(3); % format [x y]
        a_rotated = sdsRotatedOut(3);
        b_rotated = sdsRotatedOut(4);
        
        theta = thetaOut(2);
        thetaRadians = degrees_to_radians(theta);
        
        axes(ax)
        ellipse(center, a_rotated, b_rotated, thetaRadians, colStr);
%         hold on
%         ellipse(center, a_parallel, b_parallel, 0, 'k--');
%         rectangle('Position', [meansOut(2)-a_parallel ...
%             meansOut(3)-b_parallel 2*a_parallel 2*b_parallel])
        
    otherwise
        disp ([ellipseString ' unknown ...'])
        return;
end

end