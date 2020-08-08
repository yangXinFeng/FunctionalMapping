% EEGLAB history file generated on the 01-Jul-2020
% ------------------------------------------------

EEG.etc.eeglabvers = '2019.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data','D:\\MATLAB_work\\EEG\\functionalMapping\\daiyou_static1.mat','srate',500,'pnts',0,'xmin',0);
EEG.setname='daiyou';
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 'locutoff',2,'hicutoff',95,'plotfreqz',1);
EEG = pop_eegfiltnew(EEG, 'locutoff',49,'hicutoff',51,'revfilt',1,'plotfreqz',1);
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [],[]);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
% plot_frequent(EEG.data(1,:),500,100)
