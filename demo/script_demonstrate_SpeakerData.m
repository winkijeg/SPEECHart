% 
% demonstrate actions related to the class SpeakerData
%
%

clear *

speakerName = 'cs';

% read specification (xml) and contruct an object 
matSpeakerData = xml_read(['./' speakerName '_MRI.xml']);
mySpeakerData = SpeakerData(matSpeakerData);

% plot the SpeakerData - nite, that everything is in MRI coordinates 
h_axes = mySpeakerData.initPlotFigure(false);

% plot full semipolar grid (or just a few gridlines)
mySpeakerData.plot_grid([0.7 0.7 0.7], [], h_axes);
mySpeakerData.plot_grid('r', 3:6, h_axes);

% plot the landmarks / again, either ALL or A FEW landmarks
mySpeakerData.plot_landmarks({}, 'b', h_axes);
mySpeakerData.plot_landmarks({'ANS', 'PNS'}, 'r', h_axes);

% plot landmarks that are drived internally / not directly passed to the model
mySpeakerData.plot_landmarks_derived('c', h_axes);

% plot the two contours (inner trace as well as outer trace
mySpeakerData.plot_contours('m', h_axes);

% plot the parts of the contours that are actually passed to models design
mySpeakerData.plot_contours_modelParts('b', 3, h_axes);
