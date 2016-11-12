function [cov_S]=covar(patch)
%Function which takes a matrix and calculates Covariance matrix Cov_S(which
%is symmetric) by calculating the mean and then covariance
    n_window=size(patch,2);
    M1=size(patch,1);
    mean_S=sum(patch)./M1;
    for k=1:n_window
    patch(:,k)=patch(:,k)-mean_S(k);
end

cov_S=(patch*patch')./(n_window);

end