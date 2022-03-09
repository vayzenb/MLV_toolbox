function [vecLD,lengthsHistogram,bins] = getLengthStats(vecLD,numBins,minLength,maxLength)
% [lengthHistogram,bins,vecLD] = getLengthStats(vecLD,numBins,minLength,maxLength)
%   computes the length histogram with logarithmiccally scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minLength - the minimum length: used as the lower bound of the histogram
%               (default: minimum across the contours of this image)
%   maxLength - the maximum length: used as the upper bound of the histogram
%               (default: maximum across the contours of this image)
%
% Output:
%   vecLD: the line drawing strcuture with length histogram added
%   lengthHistogram: the histogram of length of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers

if ~isfield(vecLD, 'lengths')
    vecLD = computeLength(vecLD);
end

if nargin < 4
    maxLength = max(vecLD.contourLengths);
end
if nargin < 3
    minLength = min(vecLD.contourLengths);
end
if nargin < 2
    numBins = 8;
end

logMin = log10(minLength + 1);
logMax = log10(maxLength + 1);
binWidth = (logMax-logMin) / numBins; %the range of the original length is from max to min length value
binBoundary = [logMin : binWidth : logMax];
bins = 10.^(binBoundary(2:end) - binWidth/2) - 1;
logLengths = log10(vecLD.contourLengths + 1);

lengthsHistogram = zeros(1,numBins);
for c = 1:vecLD.numContours
    for b = 1:numBins
        if logLengths(c) < binBoundary(b+1) || (b == numBins)
            lengthsHistogram(b) = lengthsHistogram(b) + vecLD.contourLengths(c);
            break
        end
    end
end

vecLD.lengthsHistogram = lengthsHistogram;
vecLD.lengthsHistogramBins = bins;
