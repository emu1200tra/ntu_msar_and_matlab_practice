% Main program for testing the accuracy of pitch tracking

% ====== Add necessary toolboxes to the search path
toolboxDir='C:\Users\user\Documents\MATLAB\Add-Ons\';
addpath([toolboxDir, 'utility']);
addpath([toolboxDir, 'sap']);
addpath([toolboxDir, 'sap/labelingProgram/pitchLabelingProgram']);	% For ptFileCheck.m

% ====== Define the directory of the wave files to be tested
auDir='E:\MATLAB\Add-Ons\exampleProgram\waveFile';	% Audio files with groundtruth of PV files

% ====== Read wave files and the corresponding PV information
fprintf('Read wave files and PV info from "%s"...\n', auDir);
auSet=ptAuSetRead(auDir);
fprintf('Collected %d wave files,\n', length(auSet));
if isempty(auSet), error('Cannot read any wave files from the given directory "%s"!\n', auDir); end

% ====== Performance evaluation
ptOpt=myPtOptSet;
[recogRate, auSet, time]=ptPerfEval(auSet, ptOpt);
fprintf('Overall recognition rate = %.2f%%\n', recogRate*100);
fprintf('Overall time for %d files = %g sec\n', length(auSet), time);
fprintf('Average time per file = %g sec\n', mean([auSet.time]));

% ====== Error analysis
ptPersonRr(auSet);			% Recognition rate for each person
%ptFileCheck(auSet);		% Check bad files
%ptFileCheck(auSet, '09608050PETR');	% Check bad files of a given speaker