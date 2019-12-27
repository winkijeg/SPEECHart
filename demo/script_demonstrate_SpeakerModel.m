%
% demonstrate tasks related to the class SpeakerModel
%

clear *

% a model can be adapted (from a speaker configuration) or read from an
% xml-file
modelSource = 'adapt'; % values are 'adapt' or 'xml'

speakerName = 'm1'; % values ('adapt') are  'av' or 'cs'
                    % values ('xml') are  'av' or 'cs' or 'ypm'

switch modelSource
    case 'adapt'
        
        % read in XML-Data from disk and create an object of class SpeakerData
        matSpeakerData = xml_read(['./' speakerName '_MRI.xml']);
        mySpeakerData = SpeakerData(matSpeakerData);

        % extract data that actually guide the model design
        matForModelDesign = mySpeakerData.getDataForModelCreation();

        % create an object of class ModelProducer
        % The only input to the model producer are the data regarding the specific
        % speaker - the ModelProducer always know the generic model! 
        myModelProducer = ModelProducer(matForModelDesign);
        matModel = myModelProducer.matchModel();
        
    case 'xml'
        
        % read model from xml-file
        matModel = xml_read([speakerName '_model.xml']);
        
end

% construct an object of class SpeakerModel from the output-data of matchModel
myModel = SpeakerModel(matModel);

% several things could be done with a SpeakerModel:

% just after model design, the model should be stored on harddisk
% this make sense only if model is ADAPTED
if strcmp(modelSource, 'adapt')
    myModel.export_to_XML([myModel.modelName '_model.xml']);
end

% visualize contents of the SpeakerModel
h_axes = myModel.initPlotFigure(false);

% visualize the tongue
% plot the tongue CONTOUR (in tongue rest position)
myModel.plot_tongueSurface('r', h_axes);

% plot the tongue finite elements MESH (in tongue rest position)
myModel.plot_tongueMesh([0.7 0.7 0.7], h_axes);

% for plotting EVERY landmark specify an first empty argument 
myModel.plot_landmarks({},'b', h_axes);

% for plotting only A FEW landmark give names into first argument
myModel.plot_landmarks({'ANS', 'PNS'},'r', h_axes);

% plot any (or all) contours of the model structures
myModel.plot_contours({}, 'b', h_axes);
% plot a selected contour of the Model
myModel.plot_contours({'backPharyngealWall', 'upperIncisorPalate'}, 'g', h_axes);

% there is a wrapper-method for plotting RIGID structures (in order to visualize utterancen)
myModel.plot_fixedContours('m', h_axes);

% plot any (or all) contours of the model structures
myModel.plot_muscles({}, 'g', h_axes);
myModel.plot_muscles({'STY'}, 'k', h_axes);

% list the (maximum) fiber length for each muscle in model rest position
myModel.list_maxFiberLengthAtRest();
