% plot ar frequent
function order_set=plot_compare_EEG_frequent(data_set_cell,name_cell,samplerate)

[tlength,num_chans] = size(data_set_cell{1});
ORDER=10;NFFT=2^(floor(log2(tlength))+1);Fs=samplerate;
pxx_set={};order_set=zeros(length(data_set_cell),num_chans);
for i = 1:length(data_set_cell)
    data = data_set_cell{i};
    Pxx=[];
    for c = 1:num_chans
        x = data(:,c);
        [~,~,~,ORDER] = arburgwithcriterion( x,'AIC' );
        order_set(i,c)=ORDER;
        disp(['ar order: ' num2str(ORDER)]);
        [pxx,W]=pyulear(x,ORDER,NFFT,Fs);
        Pxx=[Pxx pxx];
    end
    pxx_set(i)={log(Pxx)};
end


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
        show_pxx = [show_pxx pxx_set{i}(:,c)];
    end
    plot(W,show_pxx);
    axis([-5,120,-5,10]);
    title(['µ¼Áª' num2str(c) 'ARÆµÆ×']);
end
legend(name_cell);



