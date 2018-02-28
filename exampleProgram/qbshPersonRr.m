function qbshPersonRr(auSet)
% qbshPersonRr: List of RR of each person
%
%	Usage:
%		qbshPersonRr(auSet)

allSinger={auSet.singer};
uniqSinger=unique(allSinger);
recogRate=zeros(1, length(uniqSinger));
songCount=zeros(1, length(uniqSinger));
for i=1:length(uniqSinger)
	singer=uniqSinger{i};
	index=find(strcmp(allSinger, singer));
	rank=[auSet(index).rank];
	recogRate(i)=length(find(rank==1))/length(rank);
	songCount(i)=length(index);
end
fprintf('Recognition rate of each person:\n');
[junk, index]=sort(recogRate);
for i=1:length(index)
	fprintf('%s: song count=%d, recog. rate=%.2f%%\n', uniqSinger{index(i)}, songCount(index(i)), 100*recogRate(index(i)));
end