function [ performCurve ] = compPerformCurve(detectionRunsScores, detectionRunsHits, numTruths, curveType)
%COMPPERFORMCURVE Summary of this function goes here
%   Detailed explanation goes here


% detectionRunsScores: cell array indexed by p
%   pth cell is a real vector of detection scores from the pth run
% detectionRunsHits: cell array indexed by p
%   pth cell is a logical vector of detection truths from the pth run


nRuns = length(detectionRunsScores);

% determine thresholds
thresholds = [];
for p = 1:nRuns
  thresholds = vertcat(thresholds, detectionRunsScores{p}(:));
end
thresholds = sort(unique(thresholds),'descend');
thresholds = [inf; thresholds; -inf];

nt = numTruths;


% calculate performance over thresholds
switch curveType
case 'precision-recall'
  X = zeros(length(thresholds)+1,1);
  Y = zeros(length(thresholds)+1,1);

  % calculate curve points indexed by threshold value
  for t = 1:length(thresholds)
    threshold = thresholds(t);

    % calculate curve point
    recalls = zeros(nRuns,1);
    precisions = zeros(nRuns,1);
    for p = 1:nRuns
       thresholdMask = (detectionRunsScores{p} > threshold);
       np = sum(thresholdMask);
       tp = sum(thresholdMask & detectionRunsHits{p});
       if np > 0
           recalls(p) = tp / nt;
           precisions(p) = tp / np;
       else
           recalls(p) = 0;
           precisions(p) = 1;  % no detections is perfect precision
       end
    end

    % average all performance at given threshold
    X(t) = mean(recalls);
    Y(t) = mean(precisions);
  end
  
  % add curve point to project the last point to the axis
  X(end) = X(end-1);
  Y(end) = 0;
  
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
    BBHRs = zeros(nRuns,1);
    FPRs = zeros(nRuns,1);
    for p = 1:nRuns
       thresholdMask = (detectionRunsScores{p} > threshold);
       np = sum(thresholdMask);
       tp = sum(thresholdMask & detectionRunsHits{p});
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
    for p = 1:nRuns
       thresholdMask = (detectionRunsScores{p} > threshold);
       np = sum(thresholdMask);
       tp = sum(thresholdMask & detectionRunsHits{p});
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

