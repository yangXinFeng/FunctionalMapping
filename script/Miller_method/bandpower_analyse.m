clc;clear;
addpath(genpath('../'));
% data_set=get_ECoG_data([70 120],1);
load('data_set_20_10_07.mat')
threshold_std=2;
% band=[70 120];%band=[70 120];%band=[76 200];
samplerate=500;
% pre_data=[data_set(3).segment(1).data(:,end-samplerate*floor(length(data_set(3).segment(1).data)/samplerate)+1:end)';...
%     data_set(3).segment(8).data(:,end-samplerate*floor(length(data_set(3).segment(8).data)/samplerate)+1:end)';...
%     data_set(3).segment(9).data(:,end-samplerate*floor(length(data_set(3).segment(9).data)/samplerate)+1:end)'];
pre_data=data_set(3).segment(9).data';
post_data=data_set(3).segment(12).data';
[~,num_chans]=size(pre_data);
% window_second=60;
% f=@(data,window) data((round(length(data)/2)-window/2+1):(round(length(data)/2)+window/2),:);
% pre_data=f(pre_data,window_second*samplerate);
% post_data=f(post_data,window_second*samplerate);
sample_block=.2*samplerate;
%% calculate power in band_sig
    disp(strcat(['calculating power in ',num2str(2*sample_block), ' sample window, stepping by ',num2str(2*sample_block),' samples each time']))
%     [bf_b,bf_a] = getButterFilter(band, samplerate); %band pass
%     pre_band_sig=zeros(size(pre_data));
%     post_band_sig=zeros(size(post_data));
%      for k=1:num_chans
%         if mod(k,5)==0,disp(strcat(num2str(k),'/',num2str(num_chans))),end %this is to tell us our progress as the program runs
%         pre_band_sig(:,k)=filtfilt(bf_b, bf_a, pre_data(:,k)); %band pass
%         post_band_sig(:,k)=filtfilt(bf_b, bf_a, post_data(:,k)); %band pass
%     end

%     pre_data_power=get_band_power(pre_data,sample_block);
%     post_data_power=get_band_power(post_data,sample_block);
% 
    wavelet_level=7;wavelet_name='coif3';need_level=2;
    pre_data=get_require_level_of_DWT(pre_data,wavelet_level,wavelet_name,need_level);
    post_data=get_require_level_of_DWT(post_data,wavelet_level,wavelet_name,need_level);
% 
%     pre_window=get_band_power(pre_data,sample_block)./pre_data_power;
%     post_window=get_band_power(post_data,sample_block)./post_data_power;
    
    pre_window=get_band_power(pre_data,sample_block);
    post_window=get_band_power(post_data,sample_block);

%% calculate mean and standard deviation in a pre-stimulus window, and check with post-stimulus window 
%     pre_window=band_power(1:floor(prewindow_size/sample_block),:); %prewindow
%     post_window=band_power((size(band_power,1)+1-(floor(postwindow_size/sample_block))):(size(band_power,1)),:); %postwindow
    prew_mean=mean(pre_window,1); %pre activity window mean
    prew_std=std(pre_window,1); %pre activity window standard deviation
    postw_mean=mean(post_window,1); %post activity window mean
    postw_std=std(post_window,1); %post activity window standard deviation
%     bb_mean=mean([pre_window; post_window],1);  %baseline mean from both pre and post
%     bb_std=std([pre_window; post_window],1);  %baseline std from both pre and post
    % plot pre and post -- quality control
    figure
    subplot(2,1,1)
    errorbar(1:num_chans,prew_mean,prew_std,prew_std,'bo'), hold on, errorbar(1:num_chans,postw_mean,postw_std,postw_std,'ko'),
    legend('pre-activity','post-activity','Location','NorthEastOutside'),xlabel('channel'),ylabel('power')
    title(' pre- and post- mean and variance')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % normalize by baseline, then threshold: subtract pre-activity mean and divide by pre-activity std.  Then threshold by 2std devs
    for k=1:num_chans
        bp_temp(:,k)=(post_window(:,k)-prew_mean(k))/prew_std(k); % subtract off preactivity mean, divide to put in units of std.
    %     bp_temp(:,k)=bp_temp(:,k).*(bp_temp(:,k)>threshold_std); %threshold, discarding changes less than threshold_std    
    end
%     band_power=bp_temp;
    bp_temp=(abs(bp_temp)>threshold_std); %threshold, discarding changes less than threshold_std
    lang_cum=cumsum(bp_temp,1);
    %clear leftovers (some of these are now legacy)
    clear  f n runnr bf_a n_a  bf_b n_b samplenr bnum_int n* num_chans Running dpts post_window SelectedStimulus SourceTime tlength postwindow_size StimulusTime i pre_window StimulusType indices prew_mean trialnr act_bl_size itxt prew_std k prewindow_size 
%% %%%%%%%%%%%%%%%%%%%
    subplot(2,1,2)
    imagesc(sample_block/samplerate*[1:size(lang_cum,1)],[1:size(lang_cum,2)],(lang_cum./(repmat(max(lang_cum,[],2),1,size(lang_cum,2))))'), xlabel('Time (s)'), ylabel('Channel')
%     exportfig(gcf, ['figs/',fname,'_prepost_tdev.eps'], 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);    
%% normalize, reject noise stuff, etc
    % subtract off expected >2sd 
        a=(lang_cum-.023*((([1:size(lang_cum,1)])')*ones(1,size(lang_cum,2))));
    % normalize by time
        a=a./((([1:size(lang_cum,1)])')*ones(1,size(lang_cum,2)));
    % threshold above zero (due to subtraction of expected noise
    a(a<=0)=0;
    %
    lang_cum=a;
%% plot raster of cumulative activity
    subplot(2,1,2)
    imagesc(sample_block/samplerate*[1:size(lang_cum,1)],[1:size(lang_cum,2)],(lang_cum./(repmat(max(lang_cum,[],2),1,size(lang_cum,2))))'), xlabel('Time (s)'), ylabel('Channel')
%     exportfig(gcf, ['figs/',fname,'_prepost_tdev.eps'], 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);    

%% overlap stuff
    for k = 2:(floor(size(a,1)/(samplerate/sample_block*3))-4) % every 3 seconds
        % overlap conditions - 1 last spot (3 sec ago)
        sp_overlap(k) = corr(a(samplerate/sample_block*3*k,:)',a(samplerate/sample_block*3*(k-1),:)');    
        % overlap conditions - 3 spots ahead (9 sec ahead)
        sp_overlap(k) = sp_overlap(k).*corr(a(samplerate/sample_block*3*k,:)',a(samplerate/sample_block*3*(k+3),:)');
    end
    sp_overlap=sp_overlap.^.5;
    tt=3*[1:k];
%% plot overlap as a fxn of time
    figure, plot(tt,sp_overlap), xlabel('time (s)'), ylabel('overlap correlation')
%     exportfig(gcf, ['figs/',fname,'_overlapcorr.eps'], 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);

%% plot activity with stimulation    
    % calculate appropriate weights, etc
    sp_overlap(sp_overlap==0)=NaN;
    ctmp=find((sp_overlap>=.99)&(([0 sp_overlap(1:(end-1))])<.99));
    if numel(ctmp)==0, disp(' is over'), 
        ctmp=floor(size(lang_cum,1)/(samplerate/sample_block*3)); 
        sp=zeros(ctmp,1); 
        sp(1:length(sp_overlap))=sp_overlap;
        sp_overlap=sp;
    end
    ta_99=ctmp(1);
    t_thresh=samplerate/sample_block*3*ta_99;
    lang_cum(t_thresh,:)