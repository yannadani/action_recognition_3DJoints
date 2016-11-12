function predict=determine_class(score_diff,score_cov,weight_diff)
new_score=weight_diff*score_diff+(1-weight_diff)*score_cov;
%plotOnline(new_score);

n_window=size(score_diff,1);
score=ones(size(score_diff,2),1);
%count=1;

for win=1:n_window
for class=1:size(score_diff,2)
    score(class)=score(class)*exp(new_score(win,class));
  
end
 %count=count+1;
end
%plot(0:n_window,score(1,:),'ro-','MarkerSize',4);hold on;
%plot(0:n_window,score(2,:),'bo-','MarkerSize',4);grid on;
%plot(0:n_window,score(3,:),'go-','MarkerSize',4);
%plot(0:n_window,score(8,:),'ko-','MarkerSize',4);hold off;
[~,predict]=max(score);
%predict=1;
end
