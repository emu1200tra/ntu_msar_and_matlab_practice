function myEncrypt(inputFileName, outputFileName)
    [y,Fs] = audioread(inputFileName);
    z = y;
    for i = 1:size(y)
        if y(i)>0
            z(i)=1-y(i);
        end
        if y(i)<0
            z(i)=-1-y(i);
        end
    end
    z = flipud(z);
    audiowrite(outputFileName,z,Fs);
end

