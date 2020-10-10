% get require level of Discrete wavelet coefficients from EEG dataset
function band_sig=get_require_level_of_DWT(data,wavelet_level,wavelet_name,need_level)
    band_sig=[];
    for c = 1:size(data,2)
        signal=data(:,c);
        [C,L]=wavedec(signal,wavelet_level,wavelet_name);
        band_sig=[band_sig wrcoef('d',C,L,wavelet_name,need_level)];
    end
end
