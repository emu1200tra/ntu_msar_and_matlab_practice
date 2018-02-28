function test
    x = linspace(0.582 , 0.584 , 10);
    y = linspace(2 , 2.1 , 10);
    z = 50;
    tmp = 0;
    %sumgotest = struct('sum' , [] , 'lr' , [] , 'ur' , [] , 'resolute' , []);
    for i = 1 : 10
        for j = 1 : 10
            %for k = 1 : 15
                fprintf('%d,%d,%d\n' , i , j , z);
                %sumgotest(end+1).sum = goTest(x(i) , y(j) , z(k));
                tmp1 = goTest(x(i) , y(j) , z);
                if tmp1 > tmp
                    tmp = tmp1;
                    record1 = x(i);
                    record2 = y(j);
                    record3 = z;
                end
            %end
        end
    end
    fprintf('result:%g , lr:%g , ur:%g , resolution:%d\n' , tmp , record1 , record2 , record3);
end

