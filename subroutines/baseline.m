%Creates a Baseline cell for the first frame
function baseline_diff=baseline(cord,n_test_cord)
for i=1:size(cord,2)
    cords=cord{i};
    baseline_diff{i}=n_test_cord(:,:,1)-cords(:,:,1);
end
end