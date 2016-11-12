function window_vec=get_windowsizes(n_window,fix_frames)
n_default=floor(fix_frames/n_window);
remain=rem(fix_frames,n_window);
window_vec(1:n_window)=n_default;
if remain<(n_window/2)
window_vec(1:2:2*remain-1)=window_vec(1:2:2*remain-1)+1;
else
    window_vec(1:remain)=window_vec(1:remain)+1;
end
end