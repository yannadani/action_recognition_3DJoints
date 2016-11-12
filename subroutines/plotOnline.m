function []=plotOnline(newscore)
new_Score(1,:)=zeros(1,size(newscore,2));
new_Score(2,:)=newscore(1,:);
for window=2:size(newscore,1)
    new_Score(window+1,:)=sum(newscore(1:window,:),1);
end
n_window=0:window;
plot(n_window,new_Score(:,1),'rd-','MarkerSize',4,'MarkerFaceColor','k');hold on;grid on;
plot(n_window,new_Score(:,2),'gd-','MarkerSize',4,'MarkerFaceColor','k');
plot(n_window,new_Score(:,3),'yd-','MarkerSize',4,'MarkerFaceColor','k');
plot(n_window,new_Score(:,8),'bd-','MarkerSize',4,'MarkerFaceColor','k');hold off;
%plot(n_window,new_Score(:,3),'cd-','MarkerSize',4,'MarkerFaceColor','k');
%plot(n_window,new_Score(:,12),'md-','MarkerSize',4,'MarkerFaceColor','k');hold off;
xlabel('No. of Windows');
ylabel('Confidence level');
legend('Action 1','Action 2','Action 3','Action 4','Location','Best')
end