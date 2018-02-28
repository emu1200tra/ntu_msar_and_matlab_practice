function outputSignal = mySine(duration, freq)
    fs=16000;
    time=(0:duration*fs-1)/fs;
    m = (freq(2)-freq(1))/(time(end)-time(1));
    %syms t;
    %f = m*t + freq(1);
    %int(f , t , time(1) , time(end))
    f = [m , freq(1)];
    k = 0;
    q = polyint(f , k);
    fvector = [];
    for i = 1 : duration*fs
        fvector(end+1) = q(1)*(time(i)^2) + q(2)*(time(i)) + q(3);
    end
    y=sin(2*pi*fvector);
    plot(time, y);
    sound(y, fs);
    outputSignal = y;
end

