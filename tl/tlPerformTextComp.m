function tlPerformTextComp(ids)

M=length(ids);
for j=1:M

    load(['postprocess/' ids{j}],'pr');
    PR{j}=pr;
    N=length(pr);
end

for i=1:N
    fprintf('IMAGE %d\n',i);
    for j=1:M
        pr=PR{j}(i);
        Idet=find(pr.hits);
        [~,mSort]=sort(pr.iGt(Idet),'ascend');
        Idet=Idet(mSort);
        str='';
        for k=Idet
            str=sprintf('%s  %d %d%%',str, pr.iGt(k), round(100*pr.iou(k)));
        end
        str=sprintf('%s    %d/%dprec  %d/%drec', str,length(Idet),length(pr.hits),length(Idet),pr.numTruths);
        
        fprintf(' %d: %s\n',j,str);
    end
end

end