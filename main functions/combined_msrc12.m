function []=combined_msrc12(params_dataset)
%Training
disp('Training...');
train_cord=[];
temp_count=0;
Y_tr1=[];
count_action=0;
train_cord=cell(temp_count,1);
addpath('Y:\projects\iisc\IISC internship\Score fusion\data\msrc12');
addpath('Y:\projects\iisc\IISC internship\Score fusion\subroutines\');
nSteps=12;

for a=1:12
    count_action=count_action+1;
    for s=1:2:29
        for e1=1:3
            for e2=1:2
                for t=1:30
                    for ch=1:2
                        
                        file=sprintf('A%d_S%d_e1%d_e2%d_ins%d_%d.mat',a,s,e1,e2,t,ch);
                        
                        if exist(file,'file')
                            load(file);
                            
                            temp_count=temp_count+1;
                            B=Action_skel;
                            A=permute(B,[2 1 3]);
                            disp(file);
                            n_frames=size(A,3);
                            %***********************************************
                            window_framesize=floor(n_frames/params_dataset.Window_sizeadjust);%Size of each window frame
                            step_size=round(window_framesize/params_dataset.step_sizeadjust)+1;
                            tmpVar = length(1:step_size:n_frames);
                            n_frames_training(temp_count)=n_frames;
                            %**********************************************
                            train_cov_fullbody(:,:,temp_count)=calc_cov_training(B,params_dataset.Window_sizeadjust,params_dataset.step_sizeadjust,nSteps);
                            Y_tr1(temp_count,1)=count_action;
                            %**********************************************
                            if n_frames<=params_dataset.fix_frames;
                                new_A=addframes(A,n_frames_training(temp_count),params_dataset.fix_frames);
                                train_cord{temp_count}=new_A(:,:,1:params_dataset.fix_frames);
                                
                            else
                                new_A=same_frame_size(A,n_frames_training(temp_count),params_dataset.fix_frames);
                                train_cord{temp_count}=new_A(:,:,1:params_dataset.fix_frames);
                                
                            end
                        end
                    end
                end
                
                
            end
        end
    end
end

% *************************************************************************

% generate the dictionary
disp('Generating the dictionary');
addpath('Y:\projects\iisc\IISC internship\Score fusion\SPAMS');
[D,Y]=get_dictionary_soma(train_cov_fullbody,Y_tr1,nSteps);

% *************************************************************************
%Testing
disp('Testing....');
test_conc=[];
temp_count=0;
Y_test1=[];
count_action=0;
count=0;
prediction=[];

for a=1:12
    count_action=count_action+1;
    for s=2:2:30
        for e1=1:3
            for e2=1:2
                for t=1:30
                    for ch=1:2
                        file=sprintf('A%d_S%d_e1%d_e2%d_ins%d_%d.mat',a,s,e1,e2,t,ch);
                        if exist(file,'file')
                            load(file);
                            temp_count=temp_count+1;
                            B=Action_skel;
                            A=permute(B,[2 1 3]);
                            disp(file);
                            n_frames=size(B,3);
                            %*************************************************
                            window_framesize=floor(n_frames/params_dataset.Window_sizeadjust);%Size of each window frame
                            step_size=round(window_framesize/params_dataset.step_sizeadjust)+1;
                            tmpVar = length(1:step_size:n_frames);
                            test_cov = calc_cov_training(B,params_dataset.Window_sizeadjust,params_dataset.step_sizeadjust,nSteps);
                            %*************************************************
                            curr_recons_error = compute_recons_error(test_cov,D,Y);
                            new_recons_error=find_nonZero(curr_recons_error);
                            score_reconsError=1./new_recons_error;
                            score_cov=find_normscore(score_reconsError);
                            n_Windows=size( new_recons_error,1);
                            %*************************************************
                            
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
                            
                            prediction(temp_count,1)=determine_class(score_diff,score_cov,params_dataset.weight_diff);
                            
                            Y_test1(temp_count,1)=count_action;
                            
                        end
                    end
                end
            end
        end
    end
end
%**************************
%Determine accuracy
count=sum(Y_test1==prediction);
recog_nn=count*100/temp_count;
fprintf('recognition for MSR Action3D  =%f\n',recog_nn);
ConfusionMatrix=confusionmat(Y_test1,prediction);









