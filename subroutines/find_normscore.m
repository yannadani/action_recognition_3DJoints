function norm_score=find_normscore(unnormed)
for nw=1:size(unnormed,1)
    tot=sum(unnormed(nw,:));
    norm_score(nw,:)=unnormed(nw,:)./tot;
end
end
