function  binomial_distribution( N , p )
    prob = [];
    for i = 1 : N
       prob(end + 1) = (factorial(N)/(factorial(i)*factorial(N-i)))*p^i*(1-p)^(N-i);
    end
    yyaxis left
    f1 = bar(prob);
    yyaxis right
    f2 = plot(prob);
end

