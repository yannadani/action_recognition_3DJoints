function normal=normalise(col_cord,fix_frames)

for o=1:size(col_cord,1)
    for f=1:fix_frames
        normal(o,f)=norm(col_cord{o,f});
    end
end

end