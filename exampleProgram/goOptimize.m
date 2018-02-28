% Wing ratio tuning for constant-tempo beat tracking

clear all; close all;
%% Set the parameter values for evaluation
prmName='wingRatio'; prm=linspace(0.01, 0.2, 20);		% wingRatio
caseNum=length(prm);
perf=zeros(1, caseNum);
btOpt=myBtOptSet;
%% Prepare the audio files
if ~exist('auSet.mat', 'file')
	% Collect audio files
	auDir='../shortClip4btTraining';
	auSet=recursiveFileList(auDir, 'wav');	% Collect all audio files
	fprintf('Collected %d wave files...\n', length(auSet));
	if isempty(auSet), error('Cannot read any wave files from the given directory "%s"!\n', auDir); end
	% Read the corresponing GT beat files, do preprocessing to save time
	fprintf('Perform preprocessing...\n');
	for i=1:length(auSet)
		gtBeatFile=strrep(auSet(i).path, '.wav', '.beat');	% Read GT beats
		auSet(i).gtBeat=load(gtBeatFile);
		auSet(i).osc=wave2osc(auSet(i).path, btOpt.oscOpt);	% Preprocessing
		auSet(i).acf=frame2acf(auSet(i).osc.signal, length(auSet(i).osc.signal), btOpt.acfMethod);	% Preprocessing
	end
	fprintf('Saving auSet.mat...\n');
	save auSet auSet
else
	fprintf('Loading auSet.mat...\n');
	load auSet.mat
end
%% Performance evaluation based on the given parameter
for i=1:caseNum
	btOpt.(prmName)=prm(i);
	for j=1:length(auSet)
		auSet(j).cBeat=myBt(auSet(j), btOpt);	% Perform beat tracking
		auSet(j).fMeasure=simSequence(auSet(j).cBeat, auSet(j).gtBeat, btOpt.tolerance);	% Compute f-measure
	end
	perf(i)=mean([auSet.fMeasure]);
	fprintf('%d/%d: %s=%f, F-measure=%f\n', i, caseNum, prmName, prm(i), perf(i));
end
%% Plot the result
[maxValue, maxIndex]=max(perf);
plot(prm, perf, '.-'); grid on
line(prm(maxIndex), maxValue, 'marker', 'o', 'color', 'r');
title(sprintf('Max f-measure=%f when %s=%f', maxValue, prmName, prm(maxIndex)));
xlabel(prmName);
ylabel('F-measure');