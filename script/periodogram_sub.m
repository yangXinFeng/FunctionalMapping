%periodogram_sub
static_psd=[];
for i=1:8
    data=data_set(3).segment(9).data(i,:);%ECoG_segment.static2.data(i,:)';
    [pxx, f] = periodogram(data, [], 2^15,500);
    power_delta = bandpower(pxx, f, [1, 4], 'psd');
    power_theta = bandpower(pxx, f, [4, 8], 'psd');
    power_alpha = bandpower(pxx, f, [8, 14], 'psd');
    power_beta = bandpower(pxx, f, [14, 30], 'psd');
    power_low_gama = bandpower(pxx, f, [30, 45], 'psd');
    power_high_gama = bandpower(pxx, f, [70, 95], 'psd');
    static_psd=[static_psd;power_delta power_theta power_alpha power_beta power_low_gama power_high_gama];
end
task_psd=[];
for i=1:8
    data=data_set(3).segment(11).data(i,:);%ECoG_segment.hand2.data(i,:)';
    [pxx, f] = periodogram(data, [], 2^15,500);
    power_delta = bandpower(pxx, f, [1, 4], 'psd');
    power_theta = bandpower(pxx, f, [4, 8], 'psd');
    power_alpha = bandpower(pxx, f, [8, 14], 'psd');
    power_beta = bandpower(pxx, f, [14, 30], 'psd');
    power_low_gama = bandpower(pxx, f, [30, 45], 'psd');
    power_high_gama = bandpower(pxx, f, [70, 95], 'psd');
    task_psd=[task_psd;power_delta power_theta power_alpha power_beta power_low_gama power_high_gama];
end
% deta_psd=(name3_psd-static3_psd);
% Y=pdist(logsig(deta_psd(:,3)/100));
deta_psd=(task_psd-static_psd)./static_psd;
Y=pdist(deta_psd(:,5));
Z=linkage(Y);
figure;
dendrogram(Z);%显示系统聚类树
T=cluster(Z,'maxclust',2);
disp(T');