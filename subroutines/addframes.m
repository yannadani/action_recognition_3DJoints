%To add guessed frames for videos having frames lesser than the fixed value
function guess_mat=addframes(mat_cord,n_frames,fix_frames)
%If number of frames is equal to the desired number
if fix_frames==size(mat_cord,3)
    guess_mat=mat_cord;
    
else
difference=abs(n_frames-fix_frames);
ratio=fix_frames/difference;
%Index where the frames should be added
for i=1:difference
    add_frame_no(1,i)=round(ratio*i);
end
%Frame index from 1 to fixed value
for j=1:fix_frames
    fixframes_array(1,j)=j;
end
%Frame index from 1 to number of frames of the sent video
for k=1:n_frames
    nframes_array(1,k)=k;
end
%Index where the original matrix values must be copied
rem_frames=setxor(fixframes_array,add_frame_no);

m=1;
for l=1:rem_frames(end)
    %For rem_frame indices
    if fixframes_array(l)==rem_frames(m)
        temp_mat_cord(:,:,l)=mat_cord(:,:,nframes_array(m));
        m=m+1;
        %For add_frame_no indices
    else  temp_mat_cord(:,:,l)=zeros(size(mat_cord,1),size(mat_cord,2));
    end
    
end
for l=rem_frames(end)+1:fix_frames
    temp_mat_cord(:,:,l)=zeros(size(mat_cord,1),size(mat_cord,2));
end

%Difference between the corresponding frame value 
for n=1:size(rem_frames,2)-1
    diff(1,n)=rem_frames(n+1)-rem_frames(n)-1;
end
%Difference array consisting of only non zero values
diff = diff(diff ~= 0);
flag=1;
l=0;
%If add frame value starts from 1
if rem_frames(1)>1
    for l=1:rem_frames(1)-1
        guess_mat(:,:,l)=temp_mat_cord(:,:,rem_frames(1));
    end
    l=rem_frames(1)-1;
   
else
end

while(1)
l=l+1;

  if l==rem_frames(end)+1
                break;
  end
           %Guessed frame value added 
    if temp_mat_cord(:,:,l)==zeros(size(mat_cord,1),size(mat_cord,2));
               avg=(temp_mat_cord(:,:,l+diff(flag))-temp_mat_cord(:,:,l-1))/(diff(flag)+1);
        for x=1:diff(flag)
    
            guess_mat(:,:,l)= guess_mat(:,:,l-1)+avg;
            
            l=l+1;
        end
         flag=flag+1;
         l=l-1;
        
    else
        guess_mat(:,:,l)=temp_mat_cord(:,:,l);
    end
    
    
end
if rem_frames(end)~=fix_frames

%Copy the last valid value to the end
for l=rem_frames(end)+1:fix_frames
    guess_mat(:,:,l)=guess_mat(:,:,l-1);
end
else
end

end

end
