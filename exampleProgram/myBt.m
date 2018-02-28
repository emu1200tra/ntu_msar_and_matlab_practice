function [cBeat, fMeasure, cBeatSet]=myBt(au, btOpt, showPlot)
%myBt: Beat tracking
%
%	Usage:
%		cBeat=myBt(au, btOpt, showPlot)
%
%	Example:
%		waveFile='song01s5.wav';
%		au=waveFile2obj(waveFile);
%		btOpt=myBtOptSet;
%		showPlot=1;			% 1 for plotting intermdiate results, 0 for not plotting
%		cBeat=myBt(au, btOpt, showPlot);
%		tempWaveFile=[tempname, '.wav'];
%		tickAdd(au, cBeat, tempWaveFile);
%		dos(['start ', tempWaveFile]);

%	Roger Jang, 20120410

if nargin<1, selfdemo; return; end
if nargin<2, btOpt=btOptSet; end
if nargin<3, showPlot=0; end
showPlot = 0;
if isstr(au), au=myAudioRead(au); end
if ~isfield(au, 'signal')
	temp=myAudioRead(au.path);
	% Copy fields of temp to au
	au.signal=temp.signal;
	au.fs=temp.fs;
	au.nbits=temp.nbits;
	au.file=temp.file;
end

au.signal=mean(au.signal, 2);	% Stereo ==> Mono
% ====== Read GT beat positions (if the GT file exists)
if ~isfield(au, 'gtBeat')
	gtBeatFile=strrep(au.file, '.wav', '.beat');
	if exist(gtBeatFile, 'file'), au.gtBeat=load(gtBeatFile); end
end
if ~isfield(au, 'osc')	% If it's computed, take it directly
	au.osc=wave2osc(au, btOpt.oscOpt, showPlot);	% Return the onset strength curve (novelty curve)
end
if ~isfield(au, 'acf')	% If it's computed, take it directly
	au.acf=frame2acf(au.osc.signal, length(au.osc.signal), btOpt.acfMethod);
end
%% Here we assume the tempo is constant
frame=au.osc.signal;
timeStep=au.osc.time(2)-au.osc.time(1);
n1=round(60/btOpt.bpmMax/timeStep)+1;
n2=round(60/btOpt.bpmMin/timeStep)+1;
acf2=au.acf;
acf2(1:n1)=-inf;
acf2(n2:end)=-inf;
[maxFirst, bp]=max(acf2);	% First maximum
bp=bp-1;	% Beat period
bpm=60/(bp*timeStep);
opt.trialNum=btOpt.trialNum;
opt.wingRatio=btOpt.wingRatio;
cBeatSet=periodicMarkId(frame, bp, opt, showPlot);	% Find candidate sets of beat positions
[~, maxIndex]=max([cBeatSet.weight]);
beatPos=cBeatSet(maxIndex).position;
cBeat=beatPos*timeStep;
globalMaxIndex=cBeatSet(maxIndex).globalMaxIndex;

if showPlot
	subplot(311);
	[y,f,t,p] = spectrogram(au.signal, 256, 0, 1024);
	surf(t,f,10*log10(abs(p)),'EdgeColor','none');   
	axis xy; axis tight; colormap(jet); view(0,90);
	xlabel('Time');
	ylabel('Frequency (Hz)');
	subplot(312); plot(frame); set(gca, 'xlim', [-inf inf]);
	line(globalMaxIndex, frame(globalMaxIndex), 'marker', 'square', 'color', 'k');
	line(beatPos, frame(beatPos), 'marker', '.', 'color', 'm', 'linestyle', 'none');
	if isfield(au, 'gtBeat')		% Plot the GT beat
		axisLimit=axis;
		for i=1:length(au.gtBeat)
			line(au.gtBeat(i)/timeStep*[1 1], axisLimit(3:4), 'color', 'r'); 
		end
	end
	title('Novelty curve with computed beat positions');
	subplot(313); plot(au.acf); set(gca, 'xlim', [-inf inf]);
	axisLimit=axis;
	line(n1*[1 1], axisLimit(3:4), 'color', 'r');
	line(n2*[1 1], axisLimit(3:4), 'color', 'r');
	line(bp+1, au.acf(bp+1), 'marker', 'square', 'color', 'k');
	title('Auto-correlation of the novelty curve');
end

fMeasure=[];
if isfield(au, 'gtBeat')
	fMeasure=simSequence(cBeat, au.gtBeat, btOpt.tolerance);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
