function []=combined_utk(params_dataset)
%% Initialize Parameters and load dataset
disp('Initiailze and loading data...');
temp_count=0;
Y_tr1=[];
count_action=0;
load('Y:\projects\iisc\IISC internship\Score fusion\data\UTK\skeletal_data.mat');
addpath('Y:\projects\iisc\IISC internship\Score fusion\subroutines\');
nSteps=10;
%% Training
disp('Performing Training...');
for a=1:10 %action
    count_action=count_action+1;
    for s=1:2:9 %subject
        for e=1:2 %episode
            
            if(skeletal_data_validity(a,s,e)==1)
                
                B=skeletal_data{a,s,e}.original_skeletal_data;%Obtain 3d action matrix
                temp_count=temp_count+1;
                n_frames=size(B,3);%number of frames
                A=permute(B,[2 1 3]);
                
                %**********************************************************
                %determine window size and number of windows
                window_framesize=floor(n_frames/params_dataset.Window_sizeadjust);%Size of each window frame
                step_size=round(window_framesize/params_dataset.step_sizeadjust)+1;
                tmpVar = length(1:step_size:n_frames);
                n_frames_training(temp_count)=n_frames;
                
                %**********************************************************
                
                %Get covariances of all windows
                
               
                train_cov_fullbody(:,:,temp_count)=calc_cov_training(B,params_dataset.Window_sizeadjust,params_dataset.step_sizeadjust,nSteps);%covarinces of all windows of each training sample
                
                Y_tr1(temp_count,1)=count_action;     %Store action labels
                %**********************************************************
                %select/add frames from each training sample for baseline
                %difference
                if n_frames<=params_dataset.fix_frames;
                    new_A=addframes(A,n_frames_training(temp_count),params_dataset.fix_frames);%perform linear interpolation if number of selected frames is more than total number of frames for video
                    train_cord{temp_count}=new_A(:,:,1:params_dataset.fix_frames);
                    
                else
                    new_A=same_frame_size(A,n_frames_training(temp_count),params_dataset.fix_frames);%downsamle if number of selected frames is less than total number of frames for video
                    train_cord{temp_count}=new_A(:,:,1:params_dataset.fix_frames);
                    
                end
            end
        end
    end
end
% *************************************************************************
%% Generate the dictionary
disp('generate the dictionary');
addpath('Y:\projects\iisc\IISC internship\Score fusion\SPAMS');
[D,Y]=get_dictionary_soma(train_cov_fullbody,Y_tr1,nSteps);

% *************************************************************************
%% Testing
disp('Testing..');
%initialize
test_conc=[];
temp_count=0;
Y_test1=[];
count_action=0;
count=0;
prediction=[];

for a=1:10
    count_action=count_action+1;
    for s=2:2:10
        for e=1:2
            
            if(skeletal_data_validity(a,s,e)==1)
                tic
                B=skeletal_data{a,s,e}.original_skeletal_data;
                temp_count=temp_count+1;
                A=permute(B,[2 1 3]);
                n_frames=size(B,3);
                %**********************************************************
                window_framesize=floor(n_frames/params_dataset.Window_sizeadjust);%Size of each window frame
                step_size=round(window_framesize/params_dataset.step_sizeadjust)+1;
                tmpVar = length(1:step_size:n_frames);
                %**********************************************************
                % Find the reconstruction errors for the different classes
                test_cov = calc_cov_training(B,params_dataset.Window_sizeadjust,params_dataset.step_sizeadjust,nSteps);
            
                curr_recons_error = compute_recons_error(test_cov,D,Y);
                
                new_recons_error=find_nonZero(curr_recons_error);%eliminate the zero ones
                
                score_reconsError=1./new_recons_error;
                score_cov=find_normscore(score_reconsError);%Get probability for each class
                n_Windows=size( new_recons_error,1);
                
                %**********************************************************
                %perform baseline difference and vote for mininmum norm
                if size(B,3)<=params_dataset.fix_frames;
                    new_test_cord=addframes(A,n_frames,params_dataset.fix_frames);
                    
                else
                    new_test_cord=same_frame_size(A,n_frames,params_dataset.fix_frames);
                    
                end
                baseline_cell{1}=baseline(train_cord,new_test_cord);
                
                
                min_diff{1}=minimum_diff(train_cord,new_test_cord, baseline_cell,params_dataset.fix_frames);
                
                column_cord=mat2col(min_diff,params_dataset.fix_frames);
                
                
                norm_values=normalise(column_cord,params_dataset.fix_frames);
                score_difference=get_scoreWindow(norm_values,n_Windows,params_dataset.fix_frames,params_dataset.vote_Size,Y_tr1);%voting
                score_diff=find_normscore(score_difference);%get probability for each class
                %**********************************************************
                
                prediction(temp_count,1)=determine_class(score_diff,score_cov,params_dataset.weight_diff);%detrmine class
                toc
                %**********************************************************
                Y_test1(temp_count,1)=count_action;%store test labels to test accuracy during later stage
                %**********************************************************
            end
        end
    end
end
%% Test accuracy

count=sum(prediction==Y_test1);
recog_nn=count*100/temp_count;
fprintf('recognition for UTK=%f\n',recog_nn)
ConfusionMatrix=find_normscore(confusionmat(Y_test1,prediction)).*100


