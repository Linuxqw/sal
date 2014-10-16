function superimpose(iFig, idOut, inPath, srcIds, labels, lineStrs, colours)

if isempty(colours)
    colours = lines(length(srcIds));
end

if isempty(labels)
    labels = srcIds;
end

load([inPath srcIds{1}],'curve');
curves = curve;
curves.label = labels{1};
curves.colour = colours(1,:);
if ~isempty(lineStrs)
    curves.lineStr = lineStrs{1};
end

for i=2:length(srcIds)
    
    load([inPath srcIds{i}],'curve');
    curves(i) = curve;
    curves(i).label = labels{i};
    curves(i).colour = colours(i,:);
    if ~isempty(lineStrs)
        curves(i).lineStr = lineStrs{i};
    end
end

tlPerformPlotCurves(iFig,curves);
axis([0 1 0 .3]);