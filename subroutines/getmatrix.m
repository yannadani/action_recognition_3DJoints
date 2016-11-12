function mod_matrix= getmatrix(unmod_matrix)

l=size(unmod_matrix,1)/4;
unmod_matrix=reshape(unmod_matrix,4,l);
mod_matrix=reshape(unmod_matrix,4,20,l/20);
mod_matrix=mod_matrix(1:3,:,:);
end
