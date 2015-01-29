function val1 = determineJawOpeningAngle(obj, frameNr1, frameNr2)
% determine jaw opening angle (in degrees) between two time points

    % identify relevant condyle positions
    ptCondyle_t1 = [obj.condylePosX(frameNr1); obj.condylePosY(frameNr1)];
    ptCondyle_t2 = [obj.condylePosX(frameNr2); obj.condylePosY(frameNr2)];
    
    % identify relevant teeth-point positions
    ptTeeth_t1 = [obj.lowIncisorPosX(frameNr1, 7);
        obj.lowIncisorPosY(frameNr1, 7)];
    
     ptTeeth_t2 = [obj.lowIncisorPosX(frameNr2, 7);
        obj.lowIncisorPosY(frameNr2, 7)];
    
    % translate the second line onto origin of line 2
    offsetOfOrigins = ptCondyle_t2 - ptCondyle_t1;
    
    p1 = ptTeeth_t2 + offsetOfOrigins;
    p2 = ptCondyle_t1;
    p3 = ptTeeth_t1;
    
    % calculate angle between the two lines
    val1 = angle_deg_2d(p1, p2, p3);
    val2_rad = lines_exp_angle_nd (2, ptCondyle_t1', ptTeeth_t1', ptCondyle_t2', ptTeeth_t2');
    val2 = radians_to_degrees(val2_rad);
    
    
    % plotting stuff
    line([ptCondyle_t1(1) ptTeeth_t1(1)], [ptCondyle_t1(2) ptTeeth_t1(2)], ...
        'LineStyle', '-', 'LineWidth', 2, 'Color', 'k')
    line([ptCondyle_t2(1) ptTeeth_t2(1)], [ptCondyle_t2(2) ptTeeth_t2(2)], ...
        'LineStyle', '-', 'LineWidth', 2, 'Color', 'k')
    
    % calculating length
    len_jaw_t1 = points_dist_nd(2, ptCondyle_t1, ptTeeth_t1);
    len_jaw_t2 = points_dist_nd(2, ptCondyle_t2, ptTeeth_t2);
   
    disp(['distance condyle - teeth ->' num2str(len_jaw_t1, 4) ' mm'])
    disp(['X-displacement -> ' num2str(ptTeeth_t1(1) - ptTeeth_t2(1), 2) ' mm'])
    disp(['jaw opening -> ' num2str(val2, 2) ' degrees'])
    
end

