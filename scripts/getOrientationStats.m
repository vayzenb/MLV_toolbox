function [oriHistogram,bins,vecLD] = getOrientationStats(vecLD,numBins)
% [oriHistogram,bins,vecLD] = getOrientationStats(vecLD)
%   computes the orientation histogram, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%
% Output:
%   oriHistogram: the histogram of orientations of line segmetns, weighted
%                 by their lengths
%   bins: a vector with the bin centers
%   vecLD: the line drawing strcuture with individual contour histograms
%   added

if nargin < 2
    numBins = 8;
end

if ~isfield(vecLD, 'orientations')
    vecLD = computeOrientation(vecLD);
end
if ~isfield(vecLD, 'lengths')
    vecLD = computeLength(vecLD);
end

bwidth = 180 / numBins;
bins = [0:bwidth:180-bwidth];
binEdges = bins + bwidth/2;
vecLD.orientationHistograms = NaN(vecLD.numContours,numBins);

for c = 1:vecLD.numContours
    thisHist = zeros(1,numBins);
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    for s = 1:numSegments
        thisOri = mod(vecLD.orientations{c}(s)+bwidth/2,180)-bwidth/2;
        for b = 1:numBins
            if thisOri < binEdges(b)
                thisHist(b) = thisHist(b) + vecLD.lengths{c}(s);
                break;
            end
        end
    end
    vecLD.orientationHistograms(c,:) = thisHist;
end
vecLD.sumOrientionHistogram = sum(vecLD.orientationHistograms,1);
oriHistogram = vecLD.sumOrientionHistogram;
vecLD.orientationBins = bins;




