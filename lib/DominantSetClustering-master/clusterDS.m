function [clusters charVectors prototypeIndices payoffs nCluster] = clusterDS(A, criterion, parameter, epsilon, iter_thresh)
% function [clusters charVectors prototypeIndices payoffs nCluster] = clusterDS(A, criterion, parameter)
% Inputs:   A - affinity matrix (n x n)
%           criterion - 'MaxClust' or 'Coherence'
%                       'MaxClust':  return MaxClust number of dominant sets after
%                                    the extracted dominant sets are sorted in descending
%                                    order with respect to their internal coherency
%                       'Coherence': return the dominant sets whose internal coherency is
%                                    higher than Coherence
%           epsilon     - end threshold for two successive iteration of
%                         optimization
%
%           iter_thresh - max number of iteration of optimization
%
%
% Outputs:  clusters    - cluster assignment based on the given criteria (0 if not assigned)
%           charVectors - the characteristic vectors of extracted clusters
%           prototypeIndices - prototype indices of each extracted cluster
%           payoffs     - internal coherencies
%           nCluster    - total number of extracted clusters
%
% implementation by Aykut Erdem, 15.12.2010
% deeply edited by Eren Golge,2014

if ~exist('epsilon','var')
    epsilon = 0.001;
end

if ~exist('iter_thresh','var')
    iter_thresh = 1e+4;
end

if strcmp(criterion,'MaxClust')
    maxCluster  = parameter;
elseif strcmp(criterion,'Coherence')
    coherCutoff = parameter;
end

A = A-diag(diag(A));

nPts = size(A,1);
remaining= 1:nPts;
nSets = 0;
dominantSets = zeros(1,nPts);
X = zeros(1,nPts);
P = zeros(1,nPts);
currentA = A;
%A_norm = bsxfun(@rdivide,A,sum(A,2));
% find dominant sets unless no data remain
counter = 1;
while ~isempty(remaining)
    %x = A_norm(remaining(randi(numel(remaining))),remaining)'; % random
    %init 
    x = ones(size(currentA,1),1);
    x = x / sum(x);% Start from barycenter of the simplex
    
    % replicator dynamics optimization
    [x, iterno] = replicator_dynamics_optimization(x,currentA,iter_thresh, epsilon);
    nSets = nSets+1;
    %cut_off_val = median(x);
    cut_off_val = eps;
    dominantSets(remaining(x>cut_off_val)) = nSets;
    X(nSets, remaining)          = x;
    P(nSets)                     = x'*currentA*x; % Internal coherency (average payoff)
    
    remaining = remaining(x<cut_off_val);
    currentA  = A(remaining,remaining); % Peeling-off strategy
    counter = counter + 1;
end
% disp(sprintf('A total of %d dominant sets are extracted', nSets));

if strcmp(criterion,'MaxClust') && maxCluster<nSets
    nCluster = maxCluster;
elseif strcmp(criterion,'Coherence')
    nCluster = length(P(P>=coherCutoff));
else
    nCluster = nSets;
end
% disp(sprintf('Total number of extracted clusters is %d', nCluster));

[~, indices]     = sort(P,'descend');
clusters         = zeros(1,nPts);
charVectors      = zeros(nCluster,nPts);
prototypeIndices = zeros(nCluster,1);
payoffs = zeros(nCluster,1);
for i=1:nCluster
    clusters(dominantSets==indices(i)) = i;
    charVectors(i,:)                   = X(indices(i),:);
    [~, prototypeIndices(i)]           = max(charVectors(i,:));
    payoffs(i)                            = P(indices(i));
end

return;
