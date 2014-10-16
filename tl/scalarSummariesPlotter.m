function ss = scalarSummariesPlotter(iFig, idOut, inPath, srcIds, labels)


for i = 1:length(srcIds)
   
    load([inPath srcIds{i}],'curve');
    
    % compute AveP given p(r) := curve.{X,Y}
    % http://en.wikipedia.org/wiki/Information_retrieval#Average_precision
    
    Prec = curve.Y;
    Rec = curve.X;
    
    K = 11;
    R = [0:1/(K-1):1];
    
    for k=1:K
        p_interp = max(Prec(Rec > R(k)));
        if isempty(p_interp)
            p_interp = 0;
        end
        P_interp(k) = p_interp;
    end
    
    auc = sum(P_interp) / K;
    
    ss(i) = auc;
end

figure(iFig);clf;
bar(ss);
xlabel('curve list index');
ylabel('auc');
%legend(names)
%plot(iFig,ss);