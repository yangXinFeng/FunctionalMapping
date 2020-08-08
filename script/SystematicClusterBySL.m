data = chenkai_ECoG_segment.static.data';

config.TimeDelay=10;   % lag
config.EmbDim=10;   % embedding dimension
config.w1 = 100;  % window (Theiler correction for autocorrelation)
config.w2 = length(data)/10;  % window (used to sharpen the time resolution of synchronization measure)
config.pref= 0.05;

RESULT=H_sl(data,config);

Z=linkage(squareform(1-RESULT));
figure;
dendrogram(Z);%显示系统聚类树
T=cluster(Z,'maxclust',3)