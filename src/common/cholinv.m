function invA = cholinv(A)

% compute cholesky decomposition
n = size(A,1);
U    = chol(A);
invU = U\eye(n);
invA = invU * invU';

return

