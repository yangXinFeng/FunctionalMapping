x=chenkai_ECoG_segment.static.energy_ratio;
[coef,score,latent,t2] = princomp(x);
latent=100*latent/sum(latent)%��latent�ܺ�ͬһΪ100�����ڵ��鹩����
figure
pareto(latent);%����matla��ͼ
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
dendrogram(Z);%��ʾϵͳ������
T=cluster(Z,'maxclust',2)