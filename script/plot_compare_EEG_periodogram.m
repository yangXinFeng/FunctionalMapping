function plot_compare_EEG_periodogram(data_set_cell,name_cell,samplerate)

[tlength,num_chans] = size(data_set_cell{1});
ORDER=10;NFFT=2^(floor(log2(tlength))+1);

start = fix(sqrt(num_chans));
factor = num_chans / start;
while rem(factor,1)
    start = start+1;
    factor = num_chans / start;
end
figure;
for c = 1:num_chans
   
    subplot(start,factor,c);
    show_pxx=[];
    for i = 1:length(data_set_cell)
        show_pxx = [show_pxx data_set_cell{i}(1:tlength,c)];
    end
%     periodogram(show_pxx,[],NFFT,samplerate);
    pyulear(double(show_pxx),25,NFFT,samplerate);
    axis([-5,120,-20,20]);
    title(['µ¼Áª' num2str(c) 'ARÆµÆ×']);
end
legend(name_cell);