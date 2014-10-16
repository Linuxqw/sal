function performCurve = tlPerformCurve(positiveLists, scoreLists, truths, isTrue, truthMask, curveType)
% positiveLists -- linear cell array, where each cell represents model positives
% scoreLists -- linear cell array of vectors of corresponding scores
% truths -- linear representation of truths
% isTrue -- function of 1) model positives and 2) truths that returns a T-vector indicating the truth of the t^th positive
% numTruths -- function of truths that returns the number of truths
% curveType -- precision-recall, etc.


if ~iscell(positiveLists)
  positiveLists = {positiveLists};
  scoreLists = {scoreLists};
end

P = length(positiveLists);



% determine which positives are true
truePositiveMasks = {};
for p = 1:P
  truePositiveMasks{p} = isTrue(positiveLists{p}, truths, truthMask);
end

nt = sum(truthMask);


% determine thresholds
thresholds = [];
for p = 1:P
  thresholds = vertcat(thresholds, scoreLists{p}(:));
end
thresholds = unique(thresholds);

% calculate performance over thresholds
switch curveType
case 'precision-recall'
  X = zeros(length(thresholds),1);
  Y = zeros(length(thresholds),1);

  % loop over all thresholds
  for t = 1:length(thresholds)
    threshold = thresholds(t);

    % calculate all performance at given threshold
    recalls = zeros(length(positiveLists),1);
    precisions = zeros(length(positiveLists),1);
    for p = 1:P
       thresholdMask = (scoreLists{p} > threshold);
       np = sum(thresholdMask);
       tp = sum(thresholdMask & truePositiveMasks{p});
       recalls(p) = tp / nt;
       precisions(p) = tp / np;
    end

    % average all performance at given threshold
    X(t) = mean(recalls);
    Y(t) = mean(precisions);
  end
  
  performCurve.X = X;
  performCurve.Y = Y;
  performCurve.xlabel = 'recall';
  performCurve.ylabel = 'precision';
  performCurve.name = curveType;  

    
case 'FPR-BBHR'  % this code is intended to be the same as for P-R, except graph is vertically flipped
  X = zeros(length(thresholds),1);
  Y = zeros(length(thresholds),1);

  % loop over all thresholds
  for t = 1:length(thresholds)
    threshold = thresholds(t);

    % calculate all performance at given threshold
    BBHRs = zeros(length(positiveLists),1);
    FPRs = zeros(length(positiveLists),1);
    for p = 1:P
       thresholdMask = (scoreLists{p} > threshold);
       np = sum(thresholdMask);
       tp = sum(thresholdMask & truePositiveMasks{p});
       BBHRs(p) = tp / nt;
       FPRs(p) = 1 - tp / np;
    end

    % average all performance at given threshold
    X(t) = mean(BBHRs);
    Y(t) = mean(FPRs);
  end

  performCurve.X = X;
  performCurve.Y = Y;
  performCurve.xlabel = 'BBHR';
  performCurve.ylabel = 'FPR';
  performCurve.name = curveType;
    
  
case 'DR-FPPI'
  X = zeros(length(thresholds),1);
  Y = zeros(length(thresholds),1);

  % loop over all thresholds
  for t = 1:length(thresholds)
    threshold = thresholds(t);

    % calculate all performance at given threshold
    FPPIs = zeros(length(positiveLists),1);
    DRs = zeros(length(positiveLists),1);
    for p = 1:P
       thresholdMask = (scoreLists{p} > threshold);
       np = sum(thresholdMask);
       tp = sum(thresholdMask & truePositiveMasks{p});
       FPPIs(p) = (np - tp) / 255;
       DRs(p) = tp / nt;
    end

    % average all performance at given threshold
    X(t) = mean(FPPIs);
    Y(t) = mean(DRs);
  end
  
  performCurve.X = X;
  performCurve.Y = Y;
  performCurve.xlabel = 'FPs per image';
  performCurve.ylabel = 'detection rate';
  performCurve.name = curveType; 
  
end



end
