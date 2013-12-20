function obj = resampleMidSagittSlice(obj, targetPixelWidth, targetPixelHeight)
% resampling means transform the picture but NOT the geometrical data
% (xdata & ydata)


% calculate enlargement factor
fac_enlarge_x = obj.sliceInfo.PixelDimensions(2) / targetPixelWidth;
fac_enlarge_y =  obj.sliceInfo.PixelDimensions(3) / targetPixelHeight;


tform = maketform('affine', [fac_enlarge_x*obj.sliceInfo.PixelDimensions(2) 0 0;...
        0 fac_enlarge_y*obj.sliceInfo.PixelDimensions(3) 0; 0 0 1]);

    
[obj.sliceData, ~, ~] = imtransform(obj.sliceData, tform, 'bicubic', ...
    'FillValues', 0, 'XYScale', 1);

end

