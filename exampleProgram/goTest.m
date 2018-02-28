function gotest = goTest(bpmmax , bpmmin , ratio)

% Read audio files for BT

%close all; clear all;
%% Define the audio directory
auDir='C:\Users\user\Documents\MATLAB\shortClip4btTraining';
%% Set options for beat tracking
btOpt=myBtOptSet(bpmmax , bpmmin , ratio);
%btOpt.wingRatio=0.08;	% Overwrite the default parameter, based on the result of goOptimize.m
%% Collect the audio files
auSet=recursiveFileList(auDir, 'wav');	% Collect all audio files
auNum=length(auSet);
fprintf('Collected %d wave files,\n', auNum);
if isempty(auSet), error('Cannot read any wave files from the given directory "%s"!\n', auDir); end
%% Read the corresponing GT beat files
for i=1:auNum
	gtBeatFile=strrep(auSet(i).path, '.wav', '.beat');	% Read GT beats
	auSet(i).gtBeat=load(gtBeatFile);
end
%% Perform beat tracking for each file
for i=1:auNum
	fprintf('%d/%d: auFile=%s, ', i, auNum, auSet(i).path); myTic=tic;
	auSet(i).cBeat=myBt(auSet(i).path, btOpt);	% Perform beat tracking
	fprintf('time=%g sec\n', toc(myTic));
	auSet(i).fMeasure=simSequence(auSet(i).cBeat, auSet(i).gtBeat, btOpt.tolerance);	% Compute f-measure
end
%% List files based on performance
[sortedValue, sortedIndex]=sort([auSet.fMeasure]);
for i=1:auNum
	index=sortedIndex(i);
	fprintf('%d/%d: audioFile=%s, F-measure=%.2f\n', i, auNum, auSet(index).name, auSet(index).fMeasure);
end
fprintf('Mean F-measure=%f\n', mean([auSet.fMeasure]));
gotest = mean([auSet.fMeasure]);
%% Plot the beat time for each file, starting from the file with the worst performance
%{
for i=1:auNum
	index=sortedIndex(i);
	clf; simSequence(auSet(index).cBeat, auSet(index).gtBeat, btOpt.tolerance, 1);
	title(strPurify(auSet(index).name));
	fprintf('%d/%d: audioFile=%s, F-measure=%.2f\n', i, auNum, auSet(index).name, auSet(index).fMeasure);
	fprintf('Press any key to contiune...'); pause; fprintf('\n');
end
%}
end