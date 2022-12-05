function scoreMap = renderContoursByStatsModel(vecLD,Mdl,backgroundValue)
% scoreMap = renderContoursByStatsModel(vecLD,Mdl)
%   Writes the predictions of Mdl for each contour into a one-channel map.
%
% Input:
%   vecLD - vectorized line drawing to be split. The structure should
%           already contain all relevant feature histograms. 
%           See also: getContourPropertiesStats
%
%   Mdl - the pretrained regression model that should be applied to contour
%         features in order to split the drawing. For instancem this could
%         be a linear regression model created with fitlm:
%         https://www.mathworks.com/help/stats/fitlm.html
%         or a random forest model created with fitrensemble:
%         https://www.mathworks.com/help/stats/fitrensemble.html
%   backgroundValue - the map value for non-contour pixels (default: 0)
%
% Return:
%   scoreMap - one-channel map with the prediciton scores from Mdl written 
%              into the contour pixels, with all non-contour pixels zero

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 3
    backgroundValue = 0;
end

% construct properties table
numVar = length(Mdl.PredictorNames);
propTable = table('Size',[vecLD.numContours,numVar],'VariableTypes',repmat({'double'},1,numVar),'VariableNames',Mdl.PredictorNames);

% Now fill the table with the actual values
shortNames = {'par','mir','sep','len','ori','curv','juncType'};
histNames = {'parallelismNormHistograms','mirrorNormHistograms','separationNormHistograms',...
             'normLengthHistograms','normOrientationHistograms','normCurvatureHistograms',...
             'normJunctionContourHistograms'};
predictors = Mdl.PredictorNames;
propTable = table();
for h = 1:length(histNames)
    if ~isempty(strmatch(shortNames{h},predictors))
        if strcmp(shortNames{h},'juncType')
            propTable = [propTable,histogramToTable(vecLD.normJunctionContourHistograms, 'juncType', vecLD.junctionTypeBins)];
        else
            propTable = [propTable,histogramToTable(getfield(vecLD,histNames{h}),shortNames{h})];
        end
    end
end

% Now get the predictions from the stats model
scores = predict(Mdl,propTable);

% write the predictions into the contour locations
scoreMap = zeros(vecLD.imsize([2,1])) + backgroundValue;
for c = 1:vecLD.numContours
    thisContMap = zeros(vecLD.imsize(2),vecLD.imsize(1),3);
    for s = 1:size(vecLD.contours{c},1)
        thisContMap = insertShape(thisContMap,'Line',vecLD.contours{c}(s,:),'Color',[1,0,0],'LineWidth',1,'Opacity',1,'SmoothEdges',false);
    end
    thisContMap = thisContMap(:,:,1);
    scoreMap(thisContMap > 0) = scores(c);
end
