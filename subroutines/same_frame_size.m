%To reduce videos of excess frames to desired frame size
function [new_mat_cord]=same_frame_size(mat_cord,n_frames,fix_frames)
%Algorithm to find which frames to delete
fixed_frame_size=fix_frames;
frame_n_diff=n_frames-fixed_frame_size;
frame_n_ratio=frame_n_diff/n_frames;
fratio_reci=1/frame_n_ratio;
d=0;
%Array of frames numbers to delete
for i=1:frame_n_diff
    d=d+fratio_reci;
    del_frames_n(1,i)=round(d);
end
%Array consisting of all frames numbers from 1 to mat_cord frame size
for i=1:n_frames
    all_frames(1,i)=i;
end
%Array consisting of valid frames numbers to retain
for i=1:fix_frames
    valid_frames=setxor(all_frames,del_frames_n);
    
end
%New matrix consisting of only valid frames
for i=1:fix_frames
    new_mat_cord(:,:,i)=mat_cord(:,:,valid_frames(i));
end
end











