function new_matrix=find_nonZero(old_recons_error)
n_Actions=size(old_recons_error,2);
n_windows=size(old_recons_error,1);
Zero_matrix=zeros(1,n_Actions);
new_matrix=[];
for fin=1:n_windows
    if not((sum(old_recons_error(fin,:)==Zero_matrix))==n_Actions)
        new_matrix=[new_matrix;old_recons_error(fin,:)];
    end
end
end
