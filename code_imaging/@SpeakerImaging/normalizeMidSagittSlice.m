function obj = normalizeMidSagittSlice(obj)
% normalizes slice to intensity intervall of [0 256] (patented)

    % make sure, that image class is correct
    sliceTmp = uint16(obj.sliceData);

    % 1. determine coil type (surface vs. surrounding coils)
    mean_global = mean(mean(sliceTmp));
    mean_row = mean(sliceTmp, 1);
    mean_col = mean(sliceTmp, 2);

    rmd = max(abs(mean_row - mean_global));
    cmd = max(abs(mean_col - mean_global));

    if cmd > 2*rmd
        coil_type = 'surface coil';
    else
        if rmd > 2*cmd
            coil_type = 'surface coil';
        else
            coil_type = 'surrounding coil';
        end
    end

    % ---------------------------------------------------------------------

    % determine ROI 
    % thresholding pixel value with global mean in order to localize object
    labs_POI = sliceTmp >= mean_global;

    % find external boundary and perform standard morphological filtering until
    % only one object is found in the slice
    moreThanOne = 1;
    while moreThanOne
        labs_POI = bwmorph(labs_POI, 'dilate', 1);
        labs_POI = imfill(labs_POI, 'holes');
        cc = bwconncomp(labs_POI, 8);
        if cc.NumObjects == 1
            moreThanOne = 0;
        end 
    end

    % calculate and smooth ROI-histogram
    slice_dummy = sliceTmp;
    slice_dummy(~labs_POI) = NaN;

    stats = regionprops(labs_POI, slice_dummy, 'MaxIntensity', 'MinIntensity');

    [counts, ~] = imhist(slice_dummy, 2^16);
    i1 = stats.MinIntensity + 2;
    i2 = stats.MaxIntensity + 1;

    counts_smooth = smooth(counts(i1:i2), 13, 'moving');

    % calculate threshold (5% of maximum amount of pixels per pix-val)
    nPix_max = max(counts_smooth);
    thresh = 7.5 * nPix_max / 100;

    array_tmp = find(counts_smooth > thresh);
    int_low_orig = array_tmp(1);
    int_high_orig = array_tmp(length(array_tmp));

    window_width = int_high_orig - int_low_orig;
    window_level = int_low_orig + (window_width/2);

    % re-map values
    int_low_out = window_level - (window_width/2);
    int_high_out = window_level + (window_width/2);

    sliceOut = imadjust(sliceTmp, ...
        [int_low_orig/2^16 int_high_orig/2^16], ...
        [int_low_out/2^16 int_high_out/2^16]);

    % convert back to 8 bit
    sliceOut8bit = round(double(sliceOut) / int_high_out * 256);
    obj.sliceData = uint8(sliceOut8bit);

end
