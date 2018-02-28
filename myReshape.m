function B = myReshape( A )
    B = reshape(A , [size(A , 1)*size(A , 2) , 3]);
    B = B';
end

