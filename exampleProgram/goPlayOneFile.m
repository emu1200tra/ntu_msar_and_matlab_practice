% BT over a given wave/mp3 file
close all; clear all;
%% Beat tracking
auFile='../shortClip4btTraining/037.wav';
btOpt=myBtOptSet;
au=myAudioRead(auFile);
cBeat=myBt(au, btOpt, 1);
gtBeatFile=strrep(auFile, '.wav', '.beat');	% Read GT beats
au.gtBeat=load(gtBeatFile);
%% Play the song with computed beats
tempWaveFile=[tempname, '.wav']; tickAdd(au, cBeat, tempWaveFile); dos(['start ', tempWaveFile]);
%% Play the song with GT beats
fprintf('Hit return to hear the GT beats...\n'); pause; fprintf('\n');
tempWaveFile=[tempname, '.wav']; tickAdd(au, au.gtBeat, tempWaveFile); dos(['start ', tempWaveFile]);