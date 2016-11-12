function score_difference=get_scoreWindow(norm_values,n_windows,fix_frames,vote_size,Y_tr)

windowVec=get_windowsizes(n_windows,fix_frames);
new_norm_values=norm_values(:,2:windowVec(1));
score_difference(1,:)=min_value_vote(new_norm_values,Y_tr,fix_frames,vote_size);
    for coun=2:n_windows
      new_norm_values=norm_values(:,sum(windowVec(1:coun-1))+1:sum(windowVec(1:coun)));  
      score_difference(coun,:)=min_value_vote(new_norm_values,Y_tr,fix_frames,vote_size);
    end
end