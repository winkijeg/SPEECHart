function obj = normalizeMidSagittSlice(obj)
% normalize midsagittal slice with regard to an intensity intervall of [0 256]

% convert image class (if necessary) to uint16
sliceTmp = uint16(obj.sliceData);

% thresholding pixel value with global mean in order to localize object
mean_global = mean(mean(sliceTmp));
labsPOI = sliceTmp >= mean_global;

% find external boundary and perform standard morphological filtering until
% only one object is found in the slice
moreThanOne = true;
while moreThanOne
    
    labsPOI = bwmorph(labsPOI, 'dilate', 1);
    labsPOI = imfill(labsPOI, 'holes');
    cc = bwconncomp(labsPOI, 8);
    
    if cc.NumObjects == 1
        moreThanOne = false;
    end
    
end

% calculate and smooth ROI-histogram
slice_dummy = sliceTmp;
slice_dummy(~labsPOI) = NaN;
stats = regionprops(labsPOI, slice_dummy, 'MaxIntensity', 'MinIntensity');

[counts, ~] = imhist(slice_dummy, 2^16);
i1 = stats.MinIntensity + 2;
i2 = stats.MaxIntensity + 1;

counts_smooth = smooth(counts(i1:i2), 13, 'moving');

% calculate threshold (5% of maximum amount of pixels per pix-val)
nPixMax = max(counts_smooth);
thresh = 7.5 * nPixMax / 100;

array_tmp = find(counts_smooth > thresh);
int_low_orig = array_tmp(1);
int_high_orig = array_tmp(length(array_tmp));

window_width = int_high_orig - int_low_orig;
window_level = int_low_orig + (window_width/2);

% re-map pixel values
intensityLowestOut = window_level - (window_width/2);
intensityHighestOut = window_level + (window_width/2);

sliceOut = imadjust(sliceTmp, ...
    [int_low_orig/2^16 int_high_orig/2^16], ...
    [intensityLowestOut/2^16 intensityHighestOut/2^16]);

% convert pixel values back to 8 bit and assign appropriate class (uint8)
sliceOut8bit = round(double(sliceOut) / intensityHighestOut * 256);
obj.sliceData = uint8(sliceOut8bit);

end
