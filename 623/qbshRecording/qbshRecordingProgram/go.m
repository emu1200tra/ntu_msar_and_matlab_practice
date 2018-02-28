% 歌曲錄音，the songs are obtained from songlist.txt
% Roger Jang, 20050328
% Modified by Pony, 20110420

% ====== 檢查 MATLAB 版本
desiredVersion='7';
matlabVersion=version;
if ~strcmp(matlabVersion(1), desiredVersion)
	fprintf('建議使用版本：MATLAB %s\n', desiredVersion);
end

% ====== 錄音參數
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
	name=input('請輸入您的「學號_姓名#性別代碼」（例如：「921510_張智星#1」或「921511_鄧麗君#0」）：', 's');
	if isempty(findstr(name, '_')), fprintf('Cannot find "_"!\n'); continue; end
	if isempty(findstr(name, '#')), fprintf('Cannot find "#"!\n'); continue; end
	items=split(name, '_'); studentId=items{1};
	if length(studentId)<6, fprintf('學號必須為六位以上數字！\n'); continue; end
	items=split(name, '#'); gender=eval(items{2});
	if gender~=0 & gender~=1, fprintf('性別代碼必須為0（女生）或1（男生）！\n'); continue; end
	validInput=1;
end
userDir = [waveDir, '/', name]; 
if exist(userDir, 'dir') ~= 7,
	fprintf('Making personal wave directory => %s\n', userDir);
	mkdir(userDir);
end

% ====== 找出已錄音的檔案
songListFile = input('請輸入你的歌單名稱（例如:101062535_songList.txt）','s');
%songListFile = 'songList.txt';
fprintf('Reading song list from %s...\n', songListFile);
allTexts = textread(songListFile,'%s','delimiter','\n','whitespace','');
if isempty(allTexts)
    fprintf('\n讀取 %s 錯誤，請將提供的 %s 檔案複製到正確的資料夾\n\n', songListFile, songListFile);
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
total = 20; % 總共要錄的歌
fileNum = total-length(deleteIndex); % 所需要錄的歌曲數量是 總歌曲數 減去 目前已錄歌曲數
if length(deleteIndex)>0,
	fprintf('親愛的 %s，你已經錄了 %d 首歌了！\n', name, length(deleteIndex));
end
if length(deleteIndex)<total,
	fprintf('還有 %d 首歌要錄，加油！\n\n', total-length(deleteIndex));
end

% ======  Load "waverecord"
%wavrecord(0.1*fs, fs, 'uint8');

for i=1:fileNum,
    recObj = audiorecorder(fs, nbits, 1);
    recordItemName = input('\n請問要錄的歌曲是哪一首，請參照所提供的 songList.txt 歌單中來選擇\n只要複製要錄的歌曲資訊(歌曲名稱_歌手_來源)貼上即可\n請貼上 歌曲名稱_歌手_來源：','s');
    while isempty(find(strcmp(allTexts,recordItemName)))
        recordItemName = input('\n輸入歌曲資訊有誤，請檢查或選擇另外一首歌曲\n\n請問要錄的歌曲是哪一首，請參照所提供的 songList.txt 歌單中來選擇\n只要複製要錄的歌曲資訊(歌曲名稱_歌手_來源)貼上即可\n請貼上 歌曲名稱_歌手_來源：','s');
    end
	temp=split(recordItemName, '_');
	songName=temp{1}; singer = temp{2}; song_source = temp{3};
%     fromMiddle = eval(temp{3});
% 	if fromMiddle==0
% 		startPos='頭';
% 	else
% 		startPos='中間';
% 	end
% 	message = sprintf('(%g/%g) 歌名：%s，歌手：%s\n\t進行錄音：按下 Enter 後，請從「%s」唱 %g 秒\n\t跳過此歌：按「s」再按 Enter\n\t試聽此歌：按「p」再按 Enter\n', i, fileNum, songName, singer, startPos, duration);
    %message = sprintf('(%g/%g) 歌名：%s，歌手：%s\n\t進行錄音：按下 Enter 後，請唱 %g 秒\n\t跳過此歌：按「s」再按 Enter\n\t試聽此歌：按「p」再按 Enter\n', i, fileNum, songName, singer, duration);
    message = sprintf('(%g/%g) 歌名：%s，歌手：%s\n\t進行錄音：按下 Enter 後，請唱 %g 秒\n\t跳過此歌：按「s」再按 Enter\n', i, fileNum, songName, singer, duration);
	fprintf('%s', message);
	userInput = input('', 's');	% 分開成兩部分，才能完整顯示特殊中文，如「淚」、「許」等。
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
		userInput = input('', 's');	% 分開成兩部分，才能完整顯示特殊中文，如「淚」、「許」等。
     end
	if ~skip
		fprintf('錄音中...  ');
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
            startPosition = input('\n\n請問剛剛的哼唱片段是從歌曲的開頭開始唱起還是從中間開始\n0) 從頭開始.\n1) 從中間開始\n請輸入 0 或 1 後按 Enter\n','s');	% 使用者輸入自己唱得是從頭還是從中間
        end
        
        clipType = '-1';
        while ~strcmp(clipType,'0') & ~strcmp(clipType,'1')
            clipType = input('\n\n請問剛剛的哼唱片段是以歌唱(有歌詞)為主，還是以哼旋律(無歌詞)為主\n0) 歌唱為主.\n1) 哼旋律為主\n請輸入 0 或 1 後按 Enter\n','s');	% 使用者輸入自己唱得是從頭還是從中間
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
		fprintf('%s\n\n', ['結束錄音。（若錄音效果不理想，直接刪除「', outputFile, '」即可。）']);
	end
end

fprintf('恭喜！錄音結束！\n');