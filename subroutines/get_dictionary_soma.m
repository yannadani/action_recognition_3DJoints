function [D,Y]=get_dictionary_soma(train_cov,Y_tr,nSteps)

%Compute the sliding dictionary and compute corresponding alphas
Nk = 2;
for stepNo=1:nSteps
    D{stepNo} = [];
    Y{stepNo} = [];
    st_step = max(1,stepNo-Nk);
    end_step = min(nSteps,stepNo+Nk);
    for i = st_step:end_step
        currDict = squeeze(train_cov(:,i,:));
        okLoc = find(sum(currDict,1) ~= 0);
        currDict = currDict(:,okLoc);
        D{stepNo} = [D{stepNo} currDict];
        Y{stepNo} = [Y{stepNo}; Y_tr(okLoc)];
    end;
end;

return;