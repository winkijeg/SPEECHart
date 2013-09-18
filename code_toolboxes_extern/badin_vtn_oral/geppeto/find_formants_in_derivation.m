function [formOut, H_eqDiff] = find_formants_in_derivation(H_eq, Fmax, Fmin, freqPerBin)
% find formants in derivation of spectra

% written 09/2012 by RW (PILIOS)

threshold = 0.5;

nSamples = length(abs(H_eq));
H_eqDiff = [0 diff(20*log10(abs(H_eq)))];

% find zeros in derivation
formFreq = nan(nSamples, 1);
for nbSample = 2:nSamples-1-3
    
    valPrec = H_eqDiff(nbSample-1);
    valTmp = H_eqDiff(nbSample);
    valPost = H_eqDiff(nbSample+1);
    
    flagZeroCrossing = (valPrec > 0) && (valTmp < 0);
    
    flagRisingEdge = (valPrec > valTmp) && (valPost > valTmp) && ...
        (valTmp < threshold) && (valTmp >= 0);
    flagFallingEdge = (valPrec < valTmp) && (valPost < valTmp) && ...
        (valTmp > -threshold) && (valTmp <= 0);
    
    if flagRisingEdge == 1
        % find minimum in spectra derivation
        [~, indiMin] = dg_imin(H_eqDiff(nbSample-2:nbSample+2));
        formFreq(nbSample) = (nbSample-1-2+indiMin)*freqPerBin;
        disp(['flagRisingEdge at'])
    end
    if flagFallingEdge == 1
        % find maximum in spectra derivation
        [~, indiMax] = dg_imax(H_eqDiff(nbSample-3:nbSample+3));
        formFreq(nbSample) = (nbSample-1-3+indiMax)*freqPerBin;
        disp('flagFallingEdge')
    end
    if flagZeroCrossing == 1
        % find maximum in original spectra
       [~, indiMax] = dg_imax(abs(H_eq(nbSample-3:nbSample+3)));
        formFreq(nbSample) = (nbSample-1-3+indiMax)*freqPerBin;
    end
    
end

formOut(:, 1) = formFreq(~isnan(formFreq));

