function [ out1,out2 ] = mySongStats( songObj )
    out = struct('name' , [] , 'songCount' , []);
    out3 = struct('chinese' , [] , 'taiwanese' , [] , 'else' , []);
    sign = 0;
    tmpout2 = string([]);
    out2 = string([]);
    start = 0;
    for n=1:size(songObj,1)
        if strcmp(songObj(n).artist , '¤£¸Ô') ~= 1 && strcmp(songObj(n).artist , 'unknown') ~= 1 && strcmp(songObj(n).artist , '¦Ñºq') ~= 1
            for m=1:size(out,2)
                if strcmp(out(m).name , songObj(n).artist) == 1
                    out(m).songCount = out(m).songCount + 1;
                    sign = 1;
                    if out3(m).chinese == 1 && strcmp(songObj(n).language , 'Taiwanese') == 1
                        tmpout2(end+1) = songObj(n).artist;
                        out3(m).chinese = 0;
                    end
                    if out3(m).taiwanese == 1 && strcmp(songObj(n).language , 'Chinese') == 1
                        tmpout2(end+1) = songObj(n).artist;
                        out3(m).taiwanese = 0;
                    end
                end
            end
            if sign == 0
                if start == 0
                    out(end) = struct('name' , {songObj(n).artist} , 'songCount' , {1});
                    if strcmp(songObj(n).language , 'Chinese') == 1
                        out3(end) = struct('chinese' , 1 , 'taiwanese' , 0 , 'else' , 0);
                    end
                    if strcmp(songObj(n).language , 'Taiwanese') == 1
                        out3(end) = struct('chinese' , 0 , 'taiwanese' , 1 , 'else' , 0);
                    end
                    if strcmp(songObj(n).language , 'Chinese') == 0 && strcmp(songObj(n).language , 'Taiwanese') == 0
                        out3(end) = struct('chinese' , 0 , 'taiwanese' , 0 , 'else' , 1);
                    end
                    start = 1;
                end
                out(end+1) = struct('name' , {songObj(n).artist} , 'songCount' , {1});
                if strcmp(songObj(n).language , 'Chinese') == 1
                    out3(end+1) = struct('chinese' , 1 , 'taiwanese' , 0 , 'else' , 0);
                end
                if strcmp(songObj(n).language , 'Taiwanese') == 1
                    out3(end+1) = struct('chinese' , 0 , 'taiwanese' , 1 , 'else' , 0);
                end
                if strcmp(songObj(n).language , 'Chinese') == 0 && strcmp(songObj(n).language , 'Taiwanese') == 0
                    out3(end+1) = struct('chinese' , 0 , 'taiwanese' , 0 , 'else' , 1);
                end
            end
            if sign == 1
                sign = 0;
            end
        end
    end
    [tmp , tmp] = sort([out.songCount] , 2 , 'descend');
    tmpout1 = out(tmp);
    out1 = tmpout1(1:10);
    out2 = sort(tmpout2);
    out2 = cellstr(out2);
end

