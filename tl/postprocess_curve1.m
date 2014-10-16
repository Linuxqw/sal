function [ curve ] = postprocess_curve1( pr )
%POSTPROCESS_CURVE1 Summary of this function goes here
%   Detailed explanation goes here

    numTruths = sum(cell2mat({pr.numTruths}));
    scores = cell2mat({pr.scores});
    hits = cell2mat({pr.hits});
    curve = compPerformCurve({scores}, {hits}, numTruths, 'precision-recall');
    curve.lineStr = '-';
    curve.label = 'test';
    curve.title = 'P/R 1';
    curve.colour = [0 0 1];

end

