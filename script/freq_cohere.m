freq_band_tags=[2 4 8 14 30 45 65 95];
freq_cohere_metrix=[];
data=ECoG_segment.hand1.data';
for c=1:min(size(data))
    [Cxy,F] = mscohere(data(:,c),data,[],[],2^13,500);  
    for n=1:length(freq_band_tags)
        [~,i]=sort(abs(F-freq_band_tags(n)));
        index(n)=i(1);
    end
    freq_cohere_metrix(c,:)=mean(Cxy(index(3):index(4),:));
end
Y=pdist(squareform(1-freq_cohere_metrix)');Z=linkage(Y);
figure;
dendrogram(Z);%显示系统聚类树
T=cluster(Z,'maxclust',2);
disp(T');
[freq_cohere_metrix_r,freq_cohere_metrix_c]=find(tril(true(size(freq_cohere_metrix,2)),-1));
if(length(find(T==1))<length(T)/2)
    dominant_set_label=1;
else
    dominant_set_label=2;
end
 dominant_set=unique([freq_cohere_metrix_r(T==dominant_set_label)',...
     freq_cohere_metrix_c(T==dominant_set_label)']);
 cluster_label=[];
 for c=1:8
     if find(dominant_set==c)
         cluster_label=[cluster_label,1];
     else
         cluster_label=[cluster_label,2];
     end
 end

gamma = 1;
A=freq_cohere_metrix;k = full(sum(A));
twom = sum(k);
B = full(A - gamma*k'*k/twom);
[S,Q] = genlouvain(B);
Q = Q/twom;
for i=1:8
    m=i==S;
    if(sum(m)==1) 
        S(i)=0;
    end
end
 