clc;fclose all;clear ;
datasetIdx=input('1.UTD Dataset\n2.UT Kinect dataset\n3.MSRC12 dataset\n4.Florence 3D dataset\n5.MSR Action3D Dataset\nSelect your option\n');
addpath('Y:\projects\iisc\IISCinternship\Score fusion\main functions\');
switch datasetIdx
    case 1
        params_dataset=loadParams(datasetIdx);
        combined_utd_deep(params_dataset);
        
    case 2
        params_dataset=loadParams(datasetIdx);
        combined_utk(params_dataset);
    case 3
        params_dataset=loadParams(datasetIdx);
        combined_msrc12_deep(params_dataset);
    case 4
        params_dataset=loadParams(datasetIdx);
        combined_f3d(params_dataset);
    case 5
        params_dataset=loadParams(datasetIdx);
        combined_msr(params_dataset);
    otherwise
        disp('Wrong Id');
end