function upvec=uptrivec(P)
%returns a column vector of the upper triangular matrix of P
upvec=[];
for k=1:size(P,1)
    upvec=[upvec P(k,k:end)];
end
upvec=upvec';
end
