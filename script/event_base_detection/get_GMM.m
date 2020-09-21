% get_GMM 
function [optimal_GMM,nlog_set] = get_GMM(initial_cluster,end_cluster,feature_set)
% initial_cluster=1;end_cluster=15;feature_set=B;
min_bic = 0;optimal_cluster = 0;
for i = initial_cluster:end_cluster
    try
        GMModel = fitgmdist(feature_set,i,'Regularize', 1e-5);

        if min_bic > GMModel.BIC || i == initial_cluster
            min_bic = GMModel.BIC;
            optimal_cluster = i;
            optimal_GMM = GMModel;
        end
    catch
        disp(['GMM build error: ',num2str(i)])
        continue;
    end
    
end
disp(['optimal cluster of GMM: ',num2str(optimal_cluster)]);

nlog_set=[];
for i=1:length(feature_set)
    [~,NLOGL]=posterior(optimal_GMM,feature_set(i,:));
    
    nlog_set = [nlog_set NLOGL];
end
    