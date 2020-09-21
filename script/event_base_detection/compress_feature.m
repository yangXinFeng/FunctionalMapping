% use pca to compress the feature
function B = compress_feature(feature_set)
[~,score,latent] = pca(feature_set);
latent=100*latent/sum(latent);
disp('latent:');disp(latent);
B=score(:,1:2);
% figure
% scatter(B(:,1),B(:,2));