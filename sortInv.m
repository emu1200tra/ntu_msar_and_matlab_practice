function x = sortInv( x2 , index )
    [index2 , x3] = sort(index);
    x = x2(x3(index2)); 
end

