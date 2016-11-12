%Convert 20*3 matrix into a 60*1 column matrix
function col_cord=mat2col(minimum_diff,fix_frames)
frame_size=size(minimum_diff{1,1}{1,1},1);
for o=1:size(minimum_diff{1,1},1)
    
    for f=1:fix_frames
        col_cord{o,f}=reshape(minimum_diff{1,1}{o,f},3*frame_size,1);
    end
end
end