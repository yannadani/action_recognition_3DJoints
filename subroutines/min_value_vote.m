function [scores,predict]=min_value_vote(nom,Y_train1,fix_frames,v_size)
%scores=zeros(action size,1)
scores=zeros(length(unique(Y_train1)),1);
%Voting for each frame from 2nd to last frame
n_framesWindow=size(nom,2);
for i=1:n_framesWindow
    %Sort in descending order column wise
    [Y,I] = sort(nom(:,i),1,'descend');
    %Add scores to the last 7 values
    %Last value will get the highest value
    for j=1:v_size
        scores(Y_train1(I(size(nom,1)-v_size+j)))=scores(Y_train1(I(size(nom,1)-v_size+j)))+j;
    end
    
end
%Send the index of action having the maximum score
[~,predict]=max(scores);
end