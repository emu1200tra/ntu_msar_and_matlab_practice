% �q�������Athe songs are obtained from songlist.txt
% Roger Jang, 20050328
% Modified by Pony, 20110420

% ====== �ˬd MATLAB ����
desiredVersion='7';
matlabVersion=version;
if ~strcmp(matlabVersion(1), desiredVersion)
	fprintf('��ĳ�ϥΪ����GMATLAB %s\n', desiredVersion);
end

% ====== �����Ѽ�
duration = 10;
fs = 16000;
% nbits = 8; format = 'uint8';		% 8-bit
nbits = 16; format = 'int16';		% 16-bit
waveDir = '../waveFile';

if exist(waveDir, 'dir') ~= 7,
	fprintf('Making wave directory => %s\n', waveDir);
	mkdir(waveDir);
end

validInput=0;
while ~validInput
	name=input('�п�J�z���u�Ǹ�_�m�W#�ʧO�N�X�v�]�Ҧp�G�u921510_�i���P#1�v�Ρu921511_�H�R�g#0�v�^�G', 's');
	if isempty(findstr(name, '_')), fprintf('Cannot find "_"!\n'); continue; end
	if isempty(findstr(name, '#')), fprintf('Cannot find "#"!\n'); continue; end
	items=split(name, '_'); studentId=items{1};
	if length(studentId)<6, fprintf('�Ǹ�����������H�W�Ʀr�I\n'); continue; end
	items=split(name, '#'); gender=eval(items{2});
	if gender~=0 & gender~=1, fprintf('�ʧO�N�X������0�]�k�͡^��1�]�k�͡^�I\n'); continue; end
	validInput=1;
end
userDir = [waveDir, '/', name]; 
if exist(userDir, 'dir') ~= 7,
	fprintf('Making personal wave directory => %s\n', userDir);
	mkdir(userDir);
end

% ====== ��X�w�������ɮ�
songListFile = input('�п�J�A���q��W�١]�Ҧp:101062535_songList.txt�^','s');
%songListFile = 'songList.txt';
fprintf('Reading song list from %s...\n', songListFile);
allTexts = textread(songListFile,'%s','delimiter','\n','whitespace','');
if isempty(allTexts)
    fprintf('\nŪ�� %s ���~�A�бN���Ѫ� %s �ɮ׽ƻs�쥿�T����Ƨ�\n\n', songListFile, songListFile);
    return
end
existingWaveFile = dir([waveDir, '/', name, '/*.wav']);
deleteIndex = [];
for i=1:length(existingWaveFile),
	waveFile = existingWaveFile(i).name(1:end-8);
	index = findcell(allTexts, waveFile);
	if ~isempty(index),
		deleteIndex = [deleteIndex, index(1)];
	end
end

remaining = allTexts;
remaining(deleteIndex) = [];
total = 20; % �`�@�n�����q
fileNum = total-length(deleteIndex); % �һݭn�����q���ƶq�O �`�q���� ��h �ثe�w���q����
if length(deleteIndex)>0,
	fprintf('�˷R�� %s�A�A�w�g���F %d ���q�F�I\n', name, length(deleteIndex));
end
if length(deleteIndex)<total,
	fprintf('�٦� %d ���q�n���A�[�o�I\n\n', total-length(deleteIndex));
end

% ======  Load "waverecord"
%wavrecord(0.1*fs, fs, 'uint8');

for i=1:fileNum,
    recObj = audiorecorder(fs, nbits, 1);
    recordItemName = input('\n�аݭn�����q���O���@���A�аѷөҴ��Ѫ� songList.txt �q�椤�ӿ��\n�u�n�ƻs�n�����q����T(�q���W��_�q��_�ӷ�)�K�W�Y�i\n�жK�W �q���W��_�q��_�ӷ��G','s');
    while isempty(find(strcmp(allTexts,recordItemName)))
        recordItemName = input('\n��J�q����T���~�A���ˬd�ο�ܥt�~�@���q��\n\n�аݭn�����q���O���@���A�аѷөҴ��Ѫ� songList.txt �q�椤�ӿ��\n�u�n�ƻs�n�����q����T(�q���W��_�q��_�ӷ�)�K�W�Y�i\n�жK�W �q���W��_�q��_�ӷ��G','s');
    end
	temp=split(recordItemName, '_');
	songName=temp{1}; singer = temp{2}; song_source = temp{3};
%     fromMiddle = eval(temp{3});
% 	if fromMiddle==0
% 		startPos='�Y';
% 	else
% 		startPos='����';
% 	end
% 	message = sprintf('(%g/%g) �q�W�G%s�A�q��G%s\n\t�i������G���U Enter ��A�бq�u%s�v�� %g ��\n\t���L���q�G���us�v�A�� Enter\n\t��ť���q�G���up�v�A�� Enter\n', i, fileNum, songName, singer, startPos, duration);
    %message = sprintf('(%g/%g) �q�W�G%s�A�q��G%s\n\t�i������G���U Enter ��A�а� %g ��\n\t���L���q�G���us�v�A�� Enter\n\t��ť���q�G���up�v�A�� Enter\n', i, fileNum, songName, singer, duration);
    message = sprintf('(%g/%g) �q�W�G%s�A�q��G%s\n\t�i������G���U Enter ��A�а� %g ��\n\t���L���q�G���us�v�A�� Enter\n', i, fileNum, songName, singer, duration);
	fprintf('%s', message);
	userInput = input('', 's');	% ���}���ⳡ���A�~�৹����ܯS����A�p�u�\�v�B�u�\�v���C
	skip=0;
	while ~isempty(userInput)
        switch lower(userInput)
			%{
            case 'p'
                if (strcmp(song_source,'MIRACLE'))
                        urlSongName = char(java.net.URLEncoder.encode(songName));
                        urlSinger = char(java.net.URLEncoder.encode(singer));
                        WebMidiFile=['http://140.114.88.72/miracle/code/246_miracleCore/getFlashWav.asp?song=', urlSongName, '&singer=', urlSinger];
                else
                        WebMidiFile=['http://mirlab.org/users/markfang/SongList/midi/', songName, '_', singer, '.mid'];
                end
				web(WebMidiFile,'-browser')
             %}
			case 's'
				skip=1;
				break;
        end
        fprintf('%s', message);
		userInput = input('', 's');	% ���}���ⳡ���A�~�৹����ܯS����A�p�u�\�v�B�u�\�v���C
     end
	if ~skip
		fprintf('������...  ');
		%y = wavrecord(duration*fs, fs, format);
        recordblocking(recObj, 10);
        
        %y = double(y);		% Convert from a uint8 to double array
        y = getaudiodata(recObj);
		%y = (y-mean(y))/(2^nbits/2);	% Make y zero mean and unity maximum
        %sound(y, fs);
        
        
		plot((1:length(y))/fs, y); grid on
		axis([-inf inf -1 1]);
        
        
        startPosition = '-1';
        while ~strcmp(startPosition,'0') & ~strcmp(startPosition,'1')
            startPosition = input('\n\n�аݭ�誺��ۤ��q�O�q�q�����}�Y�}�l�۰_�٬O�q�����}�l\n0) �q�Y�}�l.\n1) �q�����}�l\n�п�J 0 �� 1 ��� Enter\n','s');	% �ϥΪ̿�J�ۤv�۱o�O�q�Y�٬O�q����
        end
        
        clipType = '-1';
        while ~strcmp(clipType,'0') & ~strcmp(clipType,'1')
            clipType = input('\n\n�аݭ�誺��ۤ��q�O�H�q��(���q��)���D�A�٬O�H��۫�(�L�q��)���D\n0) �q�۬��D.\n1) ��۫߬��D\n�п�J 0 �� 1 ��� Enter\n','s');	% �ϥΪ̿�J�ۤv�۱o�O�q�Y�٬O�q����
        end
        if strcmp(clipType,'0')
            clipType = 's'; % singing
        elseif strcmp(clipType,'1')
            clipType = 'h'; % humming
        end
        
		%recordItemName = [songName, '_', singer];
		outputFile = [waveDir, '/', name, '/', recordItemName, '_', startPosition, '_', clipType, '.wav'];
		titleStr=['Wave form of "', outputFile, '"'];
		titleStr=strrep(titleStr, '_', '\_');
		%title(titleStr);
        
		audiowrite(outputFile, y, fs);
        clear recObj;
		fprintf('%s\n\n', ['���������C�]�Y�����ĪG���z�Q�A�����R���u', outputFile, '�v�Y�i�C�^']);
	end
end

fprintf('���ߡI���������I\n');