function goPitchLabel
% Label pitch of wave files in a given directory
% Roger Jang, 20150416

close all; clear all;

% ====== Add necessary toolboxes to the search path
toolboxDir='C:\Users\user\Documents\MATLAB\Add-Ons\';
addpath([toolboxDir, 'utility']);
addpath([toolboxDir, 'sap']);
addpath([toolboxDir, 'sap/labelingProgram/pitchLabelingProgram']);

% ====== Directory of the wave files
auDir='F:\下載\matlab作業錄音';
auDir=strrep(auDir, '\', '/');
auSet=recursiveFileList(auDir, 'wav');
auNum=length(auSet);
fprintf('Read %d wave files from "%S"\n', auNum, auDir);

% ====== Label each file
for i=1:auNum
	waveFile=auSet(i).path;
	fprintf('%d/%d: Check the pitch of %s...\n', i, auNum, waveFile);
	au=myAudioRead(waveFile);
	targetPitchFile=[waveFile(1:end-3), 'pv'];
	if exist(targetPitchFile)
		au.tPitch=load(targetPitchFile);
	end
	pitchLabel(au);
	fprintf('\tHit any key to check next wav file...\n'); pause
	pitchSave;
	close all
end


end

