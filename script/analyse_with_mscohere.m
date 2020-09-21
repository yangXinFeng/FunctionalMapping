% analyse with mscohere
freq_band_tags = [2 4 8 14 30 45 65 95];
mscohere_set = [];
mscohere_set_number = 0;

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
        
        data=s';
        all_matrix={};
        for c=1:chanel
            [Cxy,F] = mscohere(data(:,c),data,[],[],2^13,500);  
            for n=1:length(freq_band_tags)
                [~,i]=sort(abs(F-freq_band_tags(n)));
                index(n)=i(1);
            end
            for level=1:6
                if level == 6 
                    all_matrix{level}(c,:)=mean(Cxy(index(level+1):index(level+2),:));
                else
                    all_matrix{level}(c,:)=mean(Cxy(index(level):index(level+1),:));
                end
                
            end
        end
        
        for level=1:6
            gamma = 1;
            A=double(all_matrix{level});
            A=floor(1/max(squareform(A.*not(eye(size(A))))))*A.*not(eye(size(A)))+eye(size(A));
            k = full(sum(A));
            twom = sum(k);
            B = full(A - gamma*k'*k/twom);
            [S,Q] = genlouvain(B);
            Q = Q/twom;
            for ii=1:length(S)
                m=S(ii)==S;
                if(sum(m)==1) 
                    S(ii)=0;
                end
            end
            disp(S');

            mscohere_set_number = mscohere_set_number+1;
            mscohere_set(mscohere_set_number).subject_name = subject_name;
            mscohere_set(mscohere_set_number).task_name = task_name;
            mscohere_set(mscohere_set_number).target = target;
            mscohere_set(mscohere_set_number).level = level;
            mscohere_set(mscohere_set_number).freq_cohere_metrix = all_matrix{level};
            mscohere_set(mscohere_set_number).output = S';           
            mscohere_set(mscohere_set_number).nmi = single(nmi(target,S')); 
        end
    end
end

% save result
% file_name = ['mscohere_set_' datestr(now,'yy_mm_dd')];
% save(file_name,'mscohere_set');