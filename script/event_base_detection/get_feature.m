% get_feature
function feature_set = get_feature(trial_set,Fs)
feature_set=[];
freq_band_tags = [1 4 8 14 30 45 70 120];
% freq_band_tags = 70:4:120;
% auto determine ar order
% [arcoefs,E,K] = aryule(x,30);
% conf = sqrt(2)*erfinv(0.95)/sqrt(length(x));
% diff(abs(K)-conf)
[trial_point, trial_number] = size(trial_set);
% ar frequent analyse
ORDER=10;NFFT=2^(round(log2(trial_point))+1);
for N = 1:trial_number
    x = trial_set(:,N);
    [pxx,f]=pyulear(x,ORDER,NFFT,Fs);
%     [pxx, f] = periodogram(x, [], NFFT,Fs);
    for n=1:length(freq_band_tags)
        [~,i]=sort(abs(f-freq_band_tags(n)));
        index(n)=i(1);
    end
     % energy ratio feature
    all_matrix=[];   
    for level=1:6
        if level == 6 
            all_matrix(1,level)=sum(pxx(index(level+1):index(level+2),:));
        else
            all_matrix(1,level)=sum(pxx(index(level):index(level+1),:));
        end

    end
    feature_set=[feature_set;all_matrix/sum(all_matrix)];

    % 4hz bin in range of 70-120hz frequent feature   
%     feature_set = [feature_set;pxx(index)'];
    
end