function  goPvSmoothCheck
% Check smoothness of the labeled pitch vectors
% Roger Jang, 20150416

close all; clear all;

% Add necessary toolboxes
addpath C:\Users\user\Documents\MATLAB\Add-Ons/utility
addpath C:\Users\user\Documents\MATLAB\Add-Ons/sap

% Specify the folder for audio files
pvDir='F:\下載\matlab作業錄音';

% Set up options
opt.type='singing';
opt.maxPitch=80;
opt.maxPitchDiff=5;
opt.outputDir=tempname;

% Check smoothness of pitch
pvSmoothCheck(pvDir, opt);

end

