%
% demonstrate how to simulate tongue movement with UtteranceProducer
%
%

clear *

modelName = 'cs';
myPlotFlag = false;     % values: true (with) and false (without) graphics 


% read model specification (xml-file) and create the model
matSpeakerModel = xml_read(['./' modelName '_model.xml']);
mySpeakerModel = SpeakerModel(matSpeakerModel);

% construct an UtteranceProducer (passing in the SpeakerModel)
myUtteranceProducer = UtteranceProducer(mySpeakerModel);

% construct an utterance plan (passing in a speech-like target string)
myUtterancePlan = UtterancePlan('ai');

% manipulate timing informations
% standard values are 50 msec for transition, 100 msec hold duration
myUtterancePlan.durTransition = [0.050 0.050];
myUtterancePlan.durHold = [0.080 0.080];

% specify delta muscle activations
myUtterancePlan.deltaLambdaGGA = [-10 20];
myUtterancePlan.deltaLambdaGGP = [20 -15];
myUtterancePlan.deltaLambdaSTY = [0 -15];

% specify values for the remeining structures (no bio-mechanics)
myUtterancePlan.jawRotation = [9 -10];
myUtterancePlan.lipProtrusion = [2 -6];
%myUtterancePlan.lipRotation = [8 -8];
myUtterancePlan.hyoid_mov = [4 -4];

% simulate movement by passing the utterancePlan to UtteranceProducer
[~, matUtt] = myUtteranceProducer.simulateMovement(myUtterancePlan, myPlotFlag);

% in case of simulating a bunch of utterances, save data on harddisk
save ([modelName '_test_v01.mat'], '-struct', 'matUtt')

% in case of simulating just one utterance (and you want to have a look 
% on details) create an object of class Utterance
myUtterance = Utterance(matUtt);


