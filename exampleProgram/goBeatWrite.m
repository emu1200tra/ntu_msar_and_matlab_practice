% Main program for writing the beat files for evaluation.
% To distinguish from GT, these beat files have extension of "beat2".
% Roger Jang, 20170604

close all; clear all
%% Define the audio directory to be tested, and the output directory 
auDir='C:\Users\user\Documents\MATLAB\btTest';			% Replace this with the recordings of this year, which contains audio files without PV files
outputBeatDir='b04902028_beat2';	% All the generated beat files are put here, so you can compress the folder for upload. Please follow the convention of "studentID_beat2".
%% Collect the audio files to test
btOpt=myBtOptSet;
auSet=recursiveFileList(auDir, 'wav');	% Collect all audio files
auNum=length(auSet);
fprintf('Collected %d wave files,\n', auNum);
if isempty(auSet), error('Cannot read any wave files from the given directory "%s"!\n', auDir); end
%% Perform beat tracking for each file
for i=1:auNum
	fprintf('%d/%d: auFile=%s, ', i, auNum, auSet(i).path); myTic=tic;
	auSet(i).cBeat=myBt(auSet(i).path, btOpt);	% Perform beat tracking
	fprintf('time=%g sec\n', toc(myTic));
end
%% Write beat files to output folder
if ~exist(outputBeatDir, 'dir')
	fprintf('Creating output directory: %s\n', outputBeatDir);
	[status, message, messageid]=mkdir('.', outputBeatDir);
end
for i=1:length(auSet)	% D:\users\jang\temp\ptPredict_noGt/b00902024/descendants of the dragon_Jian-Fu Li_0.wav
	[parentPath, mainName, extName]=fileparts(auSet(i).path);	% parentPath='D:\users\jang\temp\ptPredict_noGt/b00902024'
	beatFile=fullfile(outputBeatDir, filesep, [mainName, '.beat2']);
%	fprintf('%d/%d: Writing %s...\n', i, length(auSet), pvFile);
	asciiWrite(auSet(i).cBeat, beatFile, '%f');
end
fprintf('\nPlease compress the folder "%s" and upload it for evaluation!\n\n', outputBeatDir);
