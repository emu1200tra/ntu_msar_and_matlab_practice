function [distVec, minIndexVec] = myQbsh(songDb, pitch, qbshOpt)
%myQbsh: Match a given pitch vector for QBSH [��@�ӨϥΪ̿�J�������V�q�i�� QBSH]
%
%	Usage:
%		[distVec, minIndexVec, scoreVec] = myQbsh(songDb, pitch, qbshOpt)
%
%	Description:
%		[distVec, minIndexVec, scoreVec] = myQbsh(songDb, pitch, qbshOpt)
%			songDb: song collection
%			pitch: input pitch vector
%			qbshOpt: MR parameters

%	Roger Jang, 20130122

if any(isnan(pitch)), error('The given pitch cannot contain NaN!'); end
if sum(pitch)==0, error('The given pitch is all zero!'); end

pitch=pitch(:)';					% Change to a row vector [�אּ�C�V�q]
pitch=pvRestHandle(pitch, qbshOpt.useRest);		% Handle rests [�B�z����]
pitch=pitch-mean(pitch);				% Shift the pitch to have zero mean [�����쥭���Ȭ��s]
pitchLen = length(pitch);				% Length of the pitch vector [�����V�q���ס]�I�ơ^]
songNum=length(songDb);
distVec=zeros(1, songNum);
minIndexVec=zeros(1, songNum);

switch qbshOpt.method
	case 'ls'
		% ====== Create scaled version of the input query pitch
		[scaledVecSet, scaledVecLen]=scaledVecCreate(pitch, qbshOpt.lowerRatio, qbshOpt.upperRatio, qbshOpt.resolution);
		for i=1:length(songDb)	% Compare pitch to each song
		%	fprintf('\t%d/%d: songName=%s\n', i, length(songDb), songDb(i).songName);
		%	songDb(i).anchorPvIndex=1;
			anchorNum=length(songDb(i).anchorPvIndex);
			distVecInSong=zeros(anchorNum, 1);
			minIndexInSong=zeros(anchorNum, 1);
			for j=1:anchorNum
			%	fprintf('\t\t%d/%d:\n', j, anchorNum); pause;
			%	song=songDb(i).pv(songDb(i).noteStartIndex(j):end);		% A song from the note start index
				song=songDb(i).pv(songDb(i).anchorPvIndex(j):end);		% A song from the anchor index
				% ====== Compute LS (�p�� LS) at each anchor point
				[distVecInSong(j), minIndexInSong(j)]=linScaling2Mex(scaledVecSet, scaledVecLen, song, qbshOpt.lsDistanceType);
			end
			[distVec(i), minIndex]=min(distVecInSong);	% distVec(i): distance to song i. minIndex: anchor index
			minIndexVec(i)=minIndexInSong(minIndex);	% 
		end
	case 'dtw1'
		for i=1:length(songDb),
			song=songDb(i).pv;
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			songMean=mean(song(1:min(pitchLen, length(song))));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			song=song-songMean;					% Shift to mean [�����쥭����]
			distVec(i)=dtw4qbsh(pitch, song, qbshOpt);
		end
	case 'dtw2'
		for i=1:length(songDb),
			song=songDb(i).pv;
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			songMean=mean(song(1:min(pitchLen, length(song))));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			song=song-songMean;					% Shift to mean [�����쥭����]
			distVec(i)=dtw4qbsh(pitch, song, qbshOpt);
		end
	otherwise
		error('Unknown method!');
end