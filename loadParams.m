function params_dataset=loadParams(datasetIdx)
switch datasetIdx
    case 1
    params_dataset=struct('Dataset','UTD','Window_sizeadjust',5,'step_sizeadjust',1,'fix_frames',65,'vote_Size',10,'weight_diff',0.1);
    case 2
    params_dataset=struct('Dataset','UTK','Window_sizeadjust',5,'step_sizeadjust',1,'fix_frames',22,'vote_Size',7,'weight_diff',0.15);
    case 3
    params_dataset=struct('Dataset','MSRC12','Window_sizeadjust',6,'step_sizeadjust',1,'fix_frames',30,'vote_Size',7,'weight_diff',0);
    case 4
    params_dataset=struct('Dataset','FLORENCE3D','Window_sizeadjust',5,'step_sizeadjust',2,'fix_frames',20,'vote_Size',7,'weight_diff',0.3);
    case 5
   % params_dataset=struct('Dataset','MSRACT3D','Window_sizeadjust',3,'step_sizeadjust',0.5,'fix_frames',33,'vote_Size',7,'weight_diff',0.6);
   
params_dataset=struct('Dataset','MSRACT3D','Window_sizeadjust',5,'step_sizeadjust',1,'fix_frames',30,'vote_Size',7,'weight_diff',0.6);
end
end