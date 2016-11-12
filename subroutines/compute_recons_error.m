% Function to compute the reconstruction error for all the classes

function [reconsError] = compute_recons_error(test_cov,D,Y)

setparams;
nSteps = length(D);
classNames = unique(Y{1});
nClass = length(classNames);
for stepNo = 1:nSteps
    currTest = test_cov(:,stepNo);
    currD = D{stepNo};
    currY = Y{stepNo};
    curr_coeff = mexLasso(currTest,currD,param);
    %keyboard;
    
    curr_coeff = full(curr_coeff);
    
    % Now reconstruct using all the classes
    for classNo = 1:nClass
        currIndex = find(currY == classNames(classNo));
        tmp1 = currD(:,currIndex);
        tmp2 = curr_coeff(currIndex);
        reconsFeat = sum(tmp1 .* repmat(tmp2', [size(tmp1,1),1]),2);
%         if(norm(reconsFeat)>0)
%             reconsFeat = reconsFeat/norm(reconsFeat);
%         end;
        reconsError(stepNo,classNo) = norm(currTest - reconsFeat);
    end;
end;

   
return;
