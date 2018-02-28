function [ result ] = QM( vari_num , m , d )
    inputstring = char([]);
    result = char([]);
    sign = 0;
    for i = 0 : 2^vari_num - 1
       for j = 1 : size(m , 2)
           if m(j) == i
               
               inputstring(end+1) = '1';
               sign = 1;
           end
       end
       for j = 1 : size(d , 2)
           if d(j) == i
               inputstring(end+1) = '-';
               sign = 1;
           end
       end
       if sign == 0
            inputstring(end+1) = '0';
       end
       if sign == 1
           sign = 0;
       end
    end
    %fprintf('%s\n' , inputstring);
    [Bins,inps,Nums,ott] = minTruthtable(inputstring);
    
    for i = 1 : size(Bins , 1)
        for j = 1 : size(Bins , 2)
            if Bins(i , j) == '0'
                result(end+1) = 'A'+ j - 1;
                result(end+1) = '"';
            end
            if Bins(i , j) == '1'
                result(end+1) = 'A'+ j - 1;
            end
        end
        if i ~= size(Bins , 1)
            result(end+1) = '+';
        end
    end
end

