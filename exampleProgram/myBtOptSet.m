function btOpt=myBtOptSet(bpmmax , bpmmin , ratio)
% Options for my beat tracking

%% Add necessary toolboxes to the search path
addpath C:\Users\user\Documents\MATLAB\Add-Ons\utility
addpath C:\Users\user\Documents\MATLAB\Add-Ons\machineLearning
addpath C:\Users\user\Documents\MATLAB\Add-Ons\sap
%% Define options for BT
%btOpt.bpmMax=bpmmax;	%250	% max value of BPM (beats per minute)
btOpt.bpmMax=230;
%btOpt.bpmMin=bpmmin;	%50 	% min value of BPM (beats per minute)
btOpt.bpmMin=67.3684;
btOpt.trialNum=8;		% No. of trials for beat position identification (used in periodicMarkId.m)
btOpt.wingRatio=0.08;	%0.08   % One-side tolerance for beat position identification via forward/forward search (used in periodicMarkId.m)
%btOpt.wingRatio=0.08;
btOpt.acfMethod=4;		% Method for computing OSC's ACF
btOpt.oscOpt=wave2osc('defaultOpt');	% Options for onset strength curve
%% Do not change anything below this line
btOpt.btFcn='myBt';		% Main function for beat tracking
btOpt.tolerance=0.07;		% For computing F-measure