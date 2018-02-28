function Hypergeometric_Distribution( N1 , N2 , n )
    prob = [];
    for i = 1 : n
        prob(end+1) = (factorial(N2)*factorial(N1)*factorial(n)*factorial(N1+N2-n))/(factorial(i)*factorial(N1-i)*factorial(N2+i-n)*factorial(n-i)*factorial(N1+N2));
    end
    yyaxis left
    f1 = bar(prob);
    yyaxis right
    f2 = plot(prob);
end

