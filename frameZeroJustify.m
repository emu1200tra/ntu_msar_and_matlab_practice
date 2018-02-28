function frameMat2=frameZeroJustify(frameMat, polyOrder)
    x = (1:size(frameMat(: , 1) , 1));
    x2 = (1:size(frameMat(: , 1) , 1));
    frameMat2 = [];
    x = x(:) - mean(x(:));
    x = x(:)/std(x(:));
    x2 = x2(:) - x(:);
    %plot(frameMat , x2 , 'o');
    for i=1:size(frameMat(1,:),2)
        p = polyfit(x2 , frameMat(: , i) , polyOrder);
        frameMat2(: , i) = frameMat(: , i) - polyval(p , x2); 
    end
    %plot(frameMat2 , x2 , 'x'); 
end

