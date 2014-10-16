function tlPerformPlotCurves(figureIdx, tlCurves, option)

if ~exist('option', 'var')
    option = 'default';
end

numPlots = size(tlCurves, 1);
numCurves = size(tlCurves, 2);

pl = tlSetupPlots(figureIdx, numPlots);

for i = 1:numPlots
    pl = tlNextPlot(pl);
    hold on;
    
    clear h s;
    for j = 1:numCurves
        if isempty(tlCurves(i,j))
            continue;
        end
        if isempty(tlCurves(i,j).X)
            continue;
        end
        
        h(j) = plot(tlCurves(i,j).X, tlCurves(i,j).Y, tlCurves(i,j).lineStr, 'LineWidth', 1, 'Color', tlCurves(i,j).colour);
        s{j} = num2str(tlCurves(i,j).label);
                
    end
    
    if ~strcmp(option, 'minimal') && exist('h', 'var')
%         legend(h,s);
        legend(h,s,'Fontsize',14);
        if isfield(tlCurves, 'xlabel')
            xlabel(tlCurves(i,1).xlabel);
        end
        if isfield(tlCurves, 'ylabel')
            ylabel(tlCurves(i,1).ylabel);
        end
        if isfield(tlCurves, 'title')
            title(tlCurves(i,1).title);
        end
    end
    
%     axis([max([0 1],xlim) max([0 1],ylim)]);
    axis([0 1 0 1]);
end

end