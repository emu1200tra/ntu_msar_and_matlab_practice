function epdOpt=myEpdOptSet

% myEpdOptSet: Returns the options (parameters) for EPD

%auDir='C:\Users\user\Documents\MATLAB\2012-MSAR';
%auDir='/users/jang/temp/epdTrain';
%fprintf('Reading wave files from "%s"...\n', auDir);
%auSet=epdAuSetRead(auDir);
%fprintf('ausetread complete\n');
%epdOpt=myEpdOptSet;
epdOpt = endPointDetect('defaultOpt');
%epdOpt.volumeRatio = 0.0947368;
%epdOpt.volRatio = 0.0947368;
%epdOpt.frameSize = 128;
%epdOpt.overlap = 0.002;
%epdOpt.volRatio2 = 0.05;
%{
volumeRatio=linspace(eps, 0.9, 10000);
recogRate=volumeRatio;
for i=1:length(volumeRatio)
	epdOpt.volRatio=volumeRatio(i);
	recogRate(i)=epdPerfEval(auSet, epdOpt);
	%fprintf('%d/%d: Volume ratio = %g, Recog. rate = %.2f%%.\n', i, length(volumeRatio), epdOpt.volumeRatio, recogRate(i)*100);
end

[maxRecogRate, index]=max(recogRate);
fprintf('Best volume ratio = %g, best RR = %g%%\n', volumeRatio(index), maxRecogRate*100);
epdOpt.volRatio = volumeRatio(index);
%}
%epdOpt.frameSize = 256;
%epdOpt.overlap = 0;
end