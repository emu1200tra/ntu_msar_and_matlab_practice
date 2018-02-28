function answer = fibo( n )
    answer = 0;
    a1 = 0;
    a2 = 1;
    for x = 3:n
        answer = a1 + a2;
        a1 = a2;
        a2 = answer;
    end
    if n == 1
        answer = 0;
    end
    if n ==2
        answer = 1;
    end
end

