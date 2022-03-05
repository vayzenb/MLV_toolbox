function [curvatureHistogram,bins,vecLD] = getCurvatureStats(vecLD,numBins,minCurvature,maxCurvature)
% [lengthHistogram,bins,vecLD] = getCurvatureStats(vecLD,numBins,minLength,maxLength)
%   computes the curvature histogram with logarithmiccally scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minCurvature - the minimum curvature: used as the lower bound of the histogram
%                  (default: minimum across the contours of this image)
%   maxCurvature - the maximum curvature: used as the upper bound of the histogram
%                 (default: maximum across the contours of this image)
%
% Output:
%   curvatureHistogram: the histogram of length of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers
%   vecLD: the line drawing stucture with curvature histogram added for
%   each contour

if ~isfield(vecLD, 'curvatures')
    vecLD = computeCurvature(vecLD);
end
if nargin < 4
    maxCurvature = max([vecLD.curvatures{:}]);
end
if nargin < 3
    minCurvature = min([vecLD.curvatures{:}]);
end
if nargin < 2
    numBins = 8;
end

logMin = log10(minCurvature + 1);
logMax = log10(maxCurvature + 1);
binWidth = (logMax-logMin) / numBins; %the range of the original length is from max to min length value
binBoundary = [logMin : binWidth : logMax];
bins = 10.^(binBoundary(2:end) - binWidth/2) - 1;
logLengths = log10(vecLD.contourLengths + 1);

vecLD.curvatureHistograms = zeros(vecLD.numContours,numBins);
for c = 1:vecLD.numContours
    logCurvatures = log10(vecLD.curvatures{c}+1);
    for s = 1:numel(logCurvatures)
        for b = 1:numBins
            if logCurvatures(s) < binBoundary(b+1) || (b == numBins)
                vecLD.curvatureHistograms(c,b) = vecLD.curvatureHistograms(c,b) + vecLD.lengths{c}(s);
            end
        end
    end
end

vecLD.sumCurvatureHistogram = sum(vecLD.curvatureHistograms,1);
vecLD.curvatureBins = bins;
curvatureHistogram = vecLD.sumCurvatureHistogram;
