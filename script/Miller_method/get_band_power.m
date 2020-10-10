function band_power = get_band_power(band_sig,sample_block)
    bnum_int=2;
    [tlength,num_chans]=size(band_sig);
    band_power=zeros(floor(tlength/sample_block)-1,num_chans);
    band_sig=band_sig.^2; %this way we square each index at the start, rather than doing it redundantly later,, can put it inside loop
    for k=bnum_int:floor(tlength/sample_block) 
        band_power(k-1,:)=log(sum(band_sig((sample_block*k-(bnum_int*sample_block-1)):(sample_block*k),:),1));
    end
    clear band_sig %to save space, memory

end