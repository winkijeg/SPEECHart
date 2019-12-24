%
% demonstrate tasks related to a simulated tongue movement / utterance
%

clear *

modelName = 'm1';


% read / create the SpeakerModel which PRODUCED the simulation file
matSpeakerModel = xml_read(['./' modelName '_model.xml']);
mySpeakerModel = SpeakerModel(matSpeakerModel);

% read / create the movement simulation / Utterance
matUtterance = load(['./' modelName '_test_v01.mat']);
myUtterance = Utterance(matUtterance);

% open a canvas to draw in
h_axes1 = mySpeakerModel.initPlotFigure(false);

% the logig is: draw an utterance into the speaker model (canvas)
myUtterance.plot_movement(mySpeakerModel, 'k', 0.25, h_axes1);

% open a new canvas to draw in and render the avi
h_axes2 = mySpeakerModel.initPlotFigure(false);
myUtterance.plot_movement_mp4(mySpeakerModel, 'g', [modelName '_test_v1'], h_axes2)
