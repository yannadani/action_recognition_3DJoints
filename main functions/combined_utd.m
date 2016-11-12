function []=combined_utd(params_dataset)
%% Initialize and load params
disp('Training...');
temp_count=0;
Y_tr1=[];
count_action=0;
nSteps = 10;
addpath('Y:\projects\iisc\IISC internship\Score fusion\data\Skeleton-UTD\');
addpath('Y:\projects\iisc\IISC internship\Score fusion\subroutines\');
for a=1:27
    count_action=count_action+1;
    for s=1:2:7
        for e=1:4
            
            file=sprintf('a%1i_s%1i_t%1i_skeleton.mat',a,s,e);
            if exist(file,'file') == 0
                continue;
            end
            fp=load(file);
            temp_count=temp_count+1;
            A=fp.d_skel;
            n_frames=size(A,3);
            B=permute(A,[2 1 3]);
            
            %**************************************************************
            window_framesize=floor(n_frames/params_dataset.Window_sizeadjust);%Size of each window frame
            step_size=round(window_framesize/params_dataset.step_sizeadjust)+1;
            tmpVar = length(1:step_size:n_frames);
            n_frames_training(temp_count)=n_frames;
            %**************************************************************
            train_cov_fullbody(:,:,temp_count)=calc_cov_training(B,params_dataset.Window_sizeadjust,params_dataset.step_sizeadjust,nSteps);%covarinces of all windows of each training sample
            Y_tr1(temp_count,1)=count_action;
            %***************************************************************
            if n_frames<=params_dataset.fix_frames;
                new_A=addframes(A,n_frames_training(temp_count),params_dataset.fix_frames);
                train_cord{temp_count}=new_A(:,:,1:params_dataset.fix_frames);
                
            else
                new_A=same_frame_size(A,n_frames_training(temp_count),params_dataset.fix_frames);
                train_cord{temp_count}=new_A(:,:,1:params_dataset.fix_frames);
                
            end
            %**************************************************************
        end
    end
end

%%  generate the dictionary
disp('generating the dictionary');
addpath('Y:\projects\iisc\IISC internship\Score fusion\SPAMS');
[D,Y]=get_dictionary_soma(train_cov_fullbody,Y_tr1,nSteps);

% *************************************************************************
%% Testing
%initailize
disp('Performing testing....');
test_conc=[];
temp_count=0;
Y_test1=[];
count_action=0;
count=0;
prediction=[];

for a=1:27
    count_action=count_action+1;
    for s=2:2:8
        for e=1:4
            
            file=sprintf('a%1i_s%1i_t%1i_skeleton.mat',a,s,e);
            if exist(file,'file') == 0
                continue;
            end
            fp=load(file);
            A=fp.d_skel;
            
            temp_count=temp_count+1;
            B=permute(A,[2 1 3]);
            n_frames=size(B,3);
            
            window_framesize=floor(n_frames/params_dataset.Window_sizeadjust);%Size of each window frame
            step_size=round(window_framesize/params_dataset.step_sizeadjust)+1;
            tmpVar = length(1:step_size:n_frames);
            % *********************************************************
            % Find the reconstruction errors for the different classes
         
            test_cov = calc_cov_training(B,params_dataset.Window_sizeadjust,params_dataset.step_sizeadjust,nSteps);
     
            curr_recons_error = compute_recons_error(test_cov,D,Y);
            %eliminate the zero ones and get probability
            new_recons_error=find_nonZero(curr_recons_error);
            score_reconsError=1./new_recons_error;
            score_cov=find_normscore(score_reconsError);
            n_Windows=size(new_recons_error,1);
            
            %*********************************************************************
            %baseline difference
            if size(B,3)<=params_dataset.fix_frames;
                new_test_cord=addframes(A,n_frames,params_dataset.fix_frames);
                
            else
                new_test_cord=same_frame_size(A,n_frames,params_dataset.fix_frames);
                
            end
            baseline_cell{1}=baseline(train_cord,new_test_cord);
            
            
            min_diff{1}=minimum_diff(train_cord,new_test_cord, baseline_cell,params_dataset.fix_frames);
            
            column_cord=mat2col(min_diff,params_dataset.fix_frames);
            
            
            norm_values=normalise(column_cord,params_dataset.fix_frames);
            score_difference=get_scoreWindow(norm_values,n_Windows,params_dataset.fix_frames,params_dataset.vote_Size,Y_tr1);
            score_diff=find_normscore(score_difference);
            %*******************************************************************
            prediction(temp_count,1)=determine_class(score_diff,score_cov,params_dataset.weight_diff);
            Y_test1(temp_count,1)=count_action;
        end
    end
end
%% Predict Accuracy

count=sum(Y_test1==prediction);
recog_nn=count*100/temp_count;
fprintf('recognition for UTDallas  =%f\n',recog_nn);
ConfusionMatrix=find_normscore(confusionmat(Y_test1,prediction))


