chanel = 8;
config.TimeDelay=10;   % lag
config.EmbDim=10;   % embedding dimension
config.w1 = 100;  % window (Theiler correction for autocorrelation)
config.w2 = 410;%analyse_time_window*500/10;  % window (used to sharpen the time resolution of synchronization measure)
config.pref= 0.05;

All_rex = data_set(3).segment(10).wpt_rex;

for i=1:6
    All_cD=[];
    for c=1:chanel
        rex = All_rex{c};
        cD = rex(i,:);
        All_cD=[All_cD;cD];
    end
    RESULT=H_sl(All_cD',config);
%             Z=linkage(squareform(1-RESULT));
%             All_SL(i)={RESULT};
%     %         figure;
%     %         dendrogram(Z);%显示系统聚类树
%             T=cluster(Z,'maxclust',cluster_class);

    gamma = 1;
    A=RESULT;k = full(sum(A));
    twom = sum(k);
    B = full(A - gamma*k'*k/twom);
    [S,Q] = genlouvain(B);
%     Q = Q/twom;
%     for ii=1:length(S)
%         m=S(ii)==S;
%         if(sum(m)==1) 
%             S(ii)=0;
%         end
%     end
% 
%     disp(['第' num2str(i) '层小波系数聚类结果：']);
%     disp(S');
% 
%     disp(nmi(target,S'));
    
end