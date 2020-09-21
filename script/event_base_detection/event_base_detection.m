% base on event relate, analyse with GMM and aryule
% input; 
% baseline -- base ECoG activity using to build GMM
% eventline -- use to predit which chanel of event ECoG activity is
% significant.
% output: 
% GMM -- build from baseline
% distance_matrix -- likelihood measurement of event activity similar with 
% baseline
% peformace --
% author:yang xinfeng
% create date: 20200902
%% set up a baseline GMM
% split each 1s segment 
static_index=[1 8 9];
baseline=[];
srate = 500;
trial_period = 1;%second
trial_number = 0;
for baseline_num = 1:length(static_index)
    static = ECoG_segment(static_index(baseline_num)).data;
    [chanel,point] = size(static);
    trial_number = trial_number+floor(point/srate/trial_period);
    static = static(:,1:floor(point/srate/trial_period)*srate);
    baseline = [baseline static];
end
nlog_set = [];
for c = 1:chanel
    % get special trial_set(srate*trial_period,trial_number);
    trial_set = reshape(baseline(c,:),srate*trial_period,trial_number);
    % get feature
    feature_set = get_feature(trial_set,srate);
    baseline_feature_set(c) = {feature_set};
    % use pca to compress the feature
%     B = compress_feature(feature_set);
%     B = feature_set(:,5:6);
    
end

%% detect the event activity
static_index=[2 7 10];
eventline=[];
srate = 500;
trial_period = 1;%second
trial_number = 0;
for baseline_num = 1:length(static_index)
    event = ECoG_segment(static_index(baseline_num)).data;
    [chanel,point] = size(event);
    trial_number = trial_number+floor(point/srate/trial_period);
    event = event(:,1:floor(point/srate/trial_period)*srate);
    eventline = [eventline event];
end
distance_matrix = [];
for c = 1:chanel
    %trial_set(srate*trial_period,trial_number);
    trial_set = reshape(eventline(c,:),srate*trial_period,trial_number);
    feature_set = get_feature(trial_set,srate);
    
    % mormalize
    Feature_set = mapminmax([feature_set' baseline_feature_set{c}']);
    Feature_set = Feature_set';
    feature_set = Feature_set(1:trial_number,:); 
    eventline_feature_set(c) = {feature_set};
    baseline_feature_set(c) = {Feature_set(1+trial_number:end,:)}; 
%     B = compress_feature(feature_set);
%     B = feature_set(:,5:6);

    % build GMM
    [GMM,nlog] = get_GMM(1,20,baseline_feature_set{c});
    nlog_set = [nlog_set;nlog];
    GMM_set(c)={GMM};

    distance=[];
    for i = 1:trial_number
        [~,NLOGL] = posterior(GMM_set{c},feature_set(i,:));
        distance = [distance;NLOGL];
    end
    distance_matrix = [distance_matrix,distance];
end

%% BCI trasistion and performance caculation
significant = [];
for c = 1:chanel
    h = ttest2(baseline_feature_set{c},eventline_feature_set{c});
    significant = [significant;h];
end

figure;
for c = 1:chanel
    subplot(2,4,c);
    B = compress_feature([baseline_feature_set{c};eventline_feature_set{c}]);
%     B = [baseline_feature_set{c};eventline_feature_set{c}];
    y = [zeros(length(baseline_feature_set{c}),1);ones(length(eventline_feature_set{c}),1)];
    h=gscatter(B(:,1),B(:,2),y);
%     baseline_feature=baseline_feature_set{c};eventline_feature=eventline_feature_set{c};
%     h=gscatter([baseline_feature(:,5);eventline_feature(:,5)],[baseline_feature(:,6);eventline_feature(:,6)],y);
    title(['Chanel ' num2str(c) ' Scatter Plot']);
    legend(h,'baseline','eventline');
end

predict_label=[];
for c = 1:chanel 
    train_X = [distance_matrix(:,c);nlog_set(c,:)'];
    train_Y = [ones(length(distance_matrix(:,c)),1);zeros(length(nlog_set(c,:)'),1)];
    bayes_mdl = fitcnb(train_X,train_Y);  
    predict_label = [predict_label predict( bayes_mdl,distance_matrix(:,c))];
end

mean(predict_label,1)