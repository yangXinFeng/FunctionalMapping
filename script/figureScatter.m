x=chenkai_ECoG_segment.static.energy_ratio;
[coef,score,latent,t2] = princomp(x);
latent=100*latent/sum(latent)%将latent总和同一为100，便于调查供献率
figure
pareto(latent);%调用matla画图
B=x*coef(:,1:3);
x=B(:,1);y=B(:,2);z=B(:,3);
figure
scatter3(x,y,z,'r');
L={ECoG.chanlocs.labels};
text(x,y,z,L);
figure(gcf);

Y=pdist(x);
SF=squareform(Y);
Z=linkage(Y,'single');
figure;
dendrogram(Z);%显示系统聚类树
T=cluster(Z,'maxclust',2)