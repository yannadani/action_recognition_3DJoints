function [tr_cov,count_end]=calc_cov_training(A_tr,Window_sizeadjust,step_sizeadjust,nSteps,count_action,count_begin,train)

n_frames=size(A_tr,3);

window_framesize=floor(n_frames/Window_sizeadjust);%Size of each window frame
step_size=round(window_framesize/step_sizeadjust)+1;

tr_cov=[];
count_win=0;

 for window_begin=1: step_size:n_frames
 S_tr_x=[];
 S_tr_y=[];
 S_tr_z=[];
count_begin=count_begin+2;
% S_trx=reshape(A_tr(1,:,:),[20 n_frames]);
% S_try=reshape(A_tr(2,:,:),[20 n_frames]);
% S_trz=reshape(A_tr(3,:,:),[20 n_frames]);
     if window_begin > n_frames-window_framesize
         for c=window_begin:n_frames
           S_tr_x=[S_tr_x;A_tr(1,:,c)];
           S_tr_y=[S_tr_y;A_tr(2,:,c)];
           S_tr_z=[S_tr_z;A_tr(3,:,c)];
           end
     
     else
           for c= window_begin : window_begin+window_framesize %Form a 2D matrix to calcluate covariance
           S_tr_x=[S_tr_x;A_tr(1,:,c)];
           S_tr_y=[S_tr_y;A_tr(2,:,c)];
           S_tr_z=[S_tr_z;A_tr(3,:,c)];
           end
     end
%       count_begin=count_begin+1;
%     if train
%   
 %tr_cov_x=createUnitVector(uptrivec(covar(S_trx)));
 %tr_cov_y=createUnitVector(uptrivec(covar(S_try)));
 %tr_cov_z=createUnitVector(uptrivec(covar(S_trz)));%To Calculate covariance,take the upper traingular matrix,and normalize it%tr_cov_x=struct('cov',tr_cov_x,'label',count_action);
% tr_cov_y=struct('cov',tr_cov_y,'label',count_action);
% tr_cov_z=struct('cov',tr_cov_z,'label',count_action);
if size(S_tr_x,1)>1
  avte_x=mean(S_tr_x);
  avte_y=mean(S_tr_y);
  avte_z=mean(S_tr_z);
else 
     avte_x=(S_tr_x);
  avte_y=(S_tr_y);
  avte_z=(S_tr_z);
end
  %  avte_y=struct('av',avte_y,'label',count_action);
%  avte_z=struct('av',avte_z,'label',count_action);
%  avte_x=struct('av',avte_x,'label',count_action);
% % 

tempfile=sprintf('Y:/projects/iisc/msrc/trainavxFiles/%d.mat',count_begin);
  save(tempfile,'avte_x');
  tempfile=sprintf('Y:/projects/iisc/msrc/trainavyFiles/%d',count_begin);
  save(tempfile,'avte_y');
  tempfile=sprintf('Y:/projects/iisc/msrc/trainavzFiles/%d',count_begin);
 save(tempfile,'avte_z');
% 
%  tempfile=sprintf('Y:/projects/iisc/msrc/trainfullcovx/%d.mat',count_begin);
%   save(tempfile,'tr_cov_x');
%   tempfile=sprintf('Y:/projects/iisc/msrc/trainfullcovy/%d.mat',count_begin);
%   save(tempfile,'tr_cov_y');
%   tempfile=sprintf('Y:/projects/iisc/msrc/trainfullcovy/%d.mat',count_begin);
%  save(tempfile,'tr_cov_z');
% 
%     else 
%          avte_x=mean(S_tr_x);
%  avte_y=mean(S_tr_y);
%  avte_z=mean(S_tr_z);
%  avte_y=struct('av',avte_y,'label',count_action);
%  avte_z=struct('av',avte_z,'label',count_action);
%  avte_x=struct('av',avte_x,'label',count_action);
% % 
%  tempfile=sprintf('Y:/projects/iisc/msrc/testavxFiles/%d.mat',count_begin);
%  save(tempfile,'avte_x');
%  tempfile=sprintf('Y:/projects/iisc/msrc/testavyFiles/%d',count_begin);
%  save(tempfile,'avte_y');
%  tempfile=sprintf('Y:/projects/iisc/msrc/testavzFiles/%d',count_begin);
% save(tempfile,'avte_z');
%     end
% %_cov(:,count_win)=createUnitVector(uptrivec(covar(S_tr')));  
% %To Calculate covariance,take the upper traingular matrix,and normalize it
% %for window_begin=1: step_size:n_frames
%  %   count_begin=count_begin+1;
%   %  count_win=count_win+1;
%   %  tr_cov(:,count_win)=(A_tr(count_begin,:)./norm(A_tr(count_begin,:)))';
% %end
 end

count_end=count_begin;
%tr_cov(:,count_win+1:nSteps)=zeros(size(tr_cov,1),nSteps-count_win); 
return;

