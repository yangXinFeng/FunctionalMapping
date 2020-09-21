% analyse with periodogram and ERD/ERS
% % Pretreatment
%     % edf_file_name='D:\MATLAB_work\EEG\functionalMapping\testData1\1.ChenKai\chen~ kai_reduced_reduced.edf';
%     ECoG = pop_biosig(edf_file_name);
%     ECoG = pop_reref( ECoG, []);
%     ECoG = eeg_checkset( ECoG );
%     ECoG = pop_eegfiltnew(ECoG, 'locutoff',49,'hicutoff',51,'revfilt',1,'plotfreqz',1);
% %     ECoG = pop_eegfiltnew(ECoG, 'locutoff',99,'hicutoff',101,'revfilt',1,'plotfreqz',1);
% %     ECoG = pop_eegfiltnew(ECoG, 'locutoff',1,'hicutoff',128,'plotfreqz',1);
% %     ECoG = eeg_checkset( ECoG );
%     ECoG = pop_rmbase( ECoG, [],[]);
%     ECoG = eeg_checkset( ECoG );

periodogram_ERD_cluster_set=[];
cluster_set_number=0;

for subject_number=1:length(data_set)
    subject_name = data_set(subject_number).subject_name;
    disp(subject_name);
    segment = data_set(subject_number).segment;
    electrode_position = data_set(subject_number).electrode_position;
    for segment_number = 1:length(segment)
        task_name = segment(segment_number).task_name;
        disp(task_name);
        s = segment(segment_number).data;
        [chanel,~]=size(s);
        target = get_target(task_name,electrode_position,chanel);
        disp(target);
        
        task_psd=[];
        for c=1:chanel
            data = s(c,:);%ECoG_segment.hand2.data(i,:)';
            [pxx, f] = periodogram(data, [], 2^15,500);
            power_delta = bandpower(pxx, f, [1, 4], 'psd');
            power_theta = bandpower(pxx, f, [4, 8], 'psd');
            power_alpha = bandpower(pxx, f, [8, 14], 'psd');
            power_beta = bandpower(pxx, f, [14, 30], 'psd');
            power_low_gama = bandpower(pxx, f, [30, 45], 'psd');
            power_high_gama = bandpower(pxx, f, [70, 95], 'psd');
            task_psd = [task_psd;power_delta,power_theta,power_alpha,...
                power_beta,power_low_gama,power_high_gama];
        end
        
        [~,band_number] = size(task_psd);
        
        if max(target)>1
            static_psd = task_psd;
        else
            deta_psd=(task_psd-static_psd)./static_psd;
            for i=1:band_number
                Y=pdist(deta_psd(:,i));
                Z=linkage(Y);
        %         figure;
        %         dendrogram(Z);%显示系统聚类树
                T=cluster(Z,'maxclust',2);
                disp(T');
                
                cluster_set_number = cluster_set_number+1;
                periodogram_ERD_cluster_set(cluster_set_number).subject_name = subject_name;
                periodogram_ERD_cluster_set(cluster_set_number).task_name = task_name;
                periodogram_ERD_cluster_set(cluster_set_number).target = target;
                periodogram_ERD_cluster_set(cluster_set_number).level = i;
                periodogram_ERD_cluster_set(cluster_set_number).task_psd = task_psd;
                periodogram_ERD_cluster_set(cluster_set_number).output = T';           
                periodogram_ERD_cluster_set(cluster_set_number).nmi = nmi(target,T');
            end
        end
        
        
    end
end
        
        
        
        
        
        
        