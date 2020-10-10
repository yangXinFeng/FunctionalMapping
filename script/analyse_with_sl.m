
% function sl_cluster_set = analyse_with_sl(data_set)

addpath(genpath('../lib/'));

analyse_time_window=10;%second
%the length of analyse_time_window
rate = 500;
analyse_time_window_length=ceil(analyse_time_window*rate/(2^7))*(2^7);

config.TimeDelay=5;   % lag
config.EmbDim=10;   % embedding dimension
config.w1 = 100;  % window (Theiler correction for autocorrelation)
config.w2 = 410;%analyse_time_window*500/10;  % window (used to sharpen the time resolution of synchronization measure)
config.pref= 0.05;

sl_cluster_set=[];
sl_cluster_set_number=0;

for subject_number=3:3%length(data_set)
    subject_name = data_set(subject_number).subject_name;
    disp(subject_name);
    segment = data_set(subject_number).segment;
    electrode_position = data_set(subject_number).electrode_position;
    for segment_number = 1:length(segment)
        task_name = segment(segment_number).task_name;
        disp(task_name);

        s = segment(segment_number).data;
%         s = s(:,1:analyse_time_window*rate);% Select the first 10 seconds
        [chanel,~]=size(s);
        target = get_target(task_name,electrode_position,chanel);
        disp(target);
        
        All_rex={};
        for c=1:chanel
          data = s(c,:);
          
          %window the midden of the origin signal
%           data=data(round(length(data)/2)-analyse_time_window_length/2+1:...
%               round(length(data)/2)+analyse_time_window_length/2);
          
          rex = wpt_rex(data,7,'coif3');
          All_rex(c) = {rex};


        end
        data_set(subject_number).segment(segment_number).wpt_rex = All_rex;
        
        
        for i=1:6
            All_cD=[];
            for c=1:chanel
                rex = All_rex{c};
                cD = rex(i,:);
                All_cD=[All_cD;cD];
            end
            sl = H_sl(All_cD',config);
%             Z=linkage(squareform(1-RESULT));
%             All_SL(i)={RESULT};
%     %         figure;
%     %         dendrogram(Z);%显示系统聚类树
%             T=cluster(Z,'maxclust',cluster_class);
%             
%             gamma = 1;
%             A=sl;
%             A=floor(1/max(squareform(A.*not(eye(size(A))))))*A.*not(eye(size(A)))+eye(size(A));
%             %A=squareform((1+mapminmax(squareform(A.*not(eye(size(A))))))/2)+eye(size(A));
%             k = full(sum(A));
%             twom = sum(k);
%             B = full(A - gamma*k'*k/twom);
%             [S,Q] = genlouvain(B);
%             Q = Q/twom;
%             disp(S')
%             for ii=1:length(S)
%                 m=S(ii)==S;
%                 if(sum(m)==1) 
%                     S(ii)=0;
%                 end
%             end
            S = spectralcluster(sl,2,'Distance','precomputed','LaplacianNormalization','symmetric');
            disp(['第' num2str(i) '层小波系数聚类结果：']);
            disp(S');
            
            disp(nmi(target,S'));
             
            sl_cluster_set_number = sl_cluster_set_number+1;
            sl_cluster_set(sl_cluster_set_number).subject_name = subject_name;
            sl_cluster_set(sl_cluster_set_number).task_name = task_name;
            sl_cluster_set(sl_cluster_set_number).target = target;
            sl_cluster_set(sl_cluster_set_number).level = i;
            sl_cluster_set(sl_cluster_set_number).sl = sl;
            sl_cluster_set(sl_cluster_set_number).output = S;           
            sl_cluster_set(sl_cluster_set_number).nmi = nmi(target,S');

        end
    end
    
end

% save result
% file_name = ['sl_cluster_set_' datestr(now,'yy_mm_dd')];
% save(file_name,'sl_cluster_set');