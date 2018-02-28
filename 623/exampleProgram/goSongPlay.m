% This program demonstrates how to play songs in the database in either MIDI or PV formats.
% ���{���i�ܦp�󼽩�зǵ��ת��q��

%% ====== Play note sequence
songDb=songDbRead('childSongEnglish');
i=42;
noteNum=20;
%fprintf('����Ἵ�� "%s" ���e %d �ӭ��� ...\n', songDb(i).midiName, noteNum); pause
fprintf('Hit return to play the first %d notes of %s...\n', noteNum, songDb(i).midiName); pause
note=songDb(i).track(1:noteNum*2);
notePlay(note, 1/64);
%% ====== Play PV
%fprintf('����Ἵ���ন pv �榡�����ָ�� ...\n'); pause
frameRate=8000/256;
fprintf('Hit return to play the song in PV format...\n'); pause
%pv = note2pv(note, frameRate, 9, [], 1);
pv=asciiRead('twinkle_twinkle_little_star.pv');
method=2;
pvPlay(pv, frameRate, method);