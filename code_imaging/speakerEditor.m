function varargout = speakerEditor(varargin)
% SPEAKEREDITOR MATLAB code for speakerEditor.fig
%      SPEAKEREDITOR, by itself, creates a new SPEAKEREDITOR or raises the existing
%      singleton*.
%
%      H = SPEAKEREDITOR returns the handle to a new SPEAKEREDITOR or the handle to
%      the existing singleton*.
%
%      SPEAKEREDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPEAKEREDITOR.M with the given input arguments.
%
%      SPEAKEREDITOR('Property','Value',...) creates a new SPEAKEREDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before speakerEditor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to speakerEditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help speakerEditor

% Last Modified by GUIDE v2.5 23-Dec-2019 17:50:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @speakerEditor_OpeningFcn, ...
                   'gui_OutputFcn',  @speakerEditor_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before speakerEditor is made visible.
function speakerEditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to speakerEditor (see VARARGIN)

% Choose default command line output for speakerEditor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% pop-up default value
set(handles.popupmenuModusSelector, 'String', {'Landmarks', 'InnerTrace', 'OuterTrace'});
set(handles.popupmenuModusSelector, 'Value', 1);

% manage figure size
set(gcf, 'Position', [1 1000 920, 700])

% disable things that are impossible at the moment
disablePanel(handles.uipanelTask)
disablePanel(handles.uipanelAdd)
disablePanel(handles.uipanelEdit)
set(handles.buttonSave, 'enable', 'off')
set(handles.buttonExport, 'enable', 'off')
set(handles.pushbuttonSamplContInner, 'enable', 'off')
set(handles.pushbuttonSamplContOuter, 'enable', 'off')
set(handles.checkboxGrid, 'enable', 'off')
set(handles.checkboxContours, 'enable', 'off')


% UIWAIT makes speakerEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = speakerEditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonOpen.
function buttonOpen_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ask for MRI-slice and load image
[filenamePic, pathnamePic] = uigetfile('*_1x1mm.png', 'Pick a PNG file (MRI) ...');
speakerName = filenamePic(1:2);
img = imread([pathnamePic filenamePic]);

% determine if XML-file exists
filenameXML = [speakerName '_RAW.xml'];
if (exist(['./' filenameXML], 'file'))
    matSpeakerData = xml_read([pathnamePic filenameXML]);
    mySpeakerData = SpeakerData(matSpeakerData);
else
    mySpeakerData = SpeakerData([]);
    mySpeakerData.speakerName = speakerName;
end

% show image
imagesc(flipud(img));
colormap(gray);
set(gca, 'Color', [0 0 0], 'YDir', 'normal');
xlabel ('A -> P [mm]')
ylabel ('I -> S [mm]')

% save
gui.mySpeakerData = mySpeakerData;
gui.modus = 'default';
gui.showGrid = 0;
gui.showContours = 0;

gui.handlesLandmarks = [];
gui.handlesInnerTrace_raw = [];
gui.handlesOuterTrace_raw = [];
set(gcbf, 'UserData', gui)

% update Figure name
nameOld = get(gcf, 'Name');
nameNew = [nameOld ' -> Speaker: ' speakerName];
set(gcf, 'Name', nameNew)

% update axes
updateAxes();

% update buttons
enablePanel(handles.uipanelTask)
enablePanel(handles.uipanelAdd)
set(handles.buttonSave, 'enable', 'on')

% update pop-up menus
updateLmSelector(handles)
updateTraceSelector(handles)


function updateAxes()

col_blue_light = [0.3010 0.7450 0.9330];
col_orange_dark = [0.8500 0.3250 0.0980];

gui = get(gcbf, 'UserData');
handles = guihandles;

has_grd_pts = gui.mySpeakerData.hasGridPoints();
hasValuesOnRawInnerCont = gui.mySpeakerData.hasRawContour('inner');
hasValuesOnRawOuterCont = gui.mySpeakerData.hasRawContour('outer');
hasValuesOnSamplInnerCont = gui.mySpeakerData.hasSampledContour('inner');
hasValuesOnSamplOuterCont = gui.mySpeakerData.hasSampledContour('outer');
hasFullPointSet = gui.mySpeakerData.hasAllLandmarksContours();

% delete raphics objects
handles_lm = gui.handlesLandmarks(ishandle(gui.handlesLandmarks));
delete(handles_lm);

handles_innerTrace_raw = ...
    gui.handlesInnerTrace_raw(ishandle(gui.handlesInnerTrace_raw));
delete(handles_innerTrace_raw);

handles_outerTrace_raw = ...
    gui.handlesOuterTrace_raw(ishandle(gui.handlesOuterTrace_raw));
delete(handles_outerTrace_raw)

handles_grid = findobj(handles.axes1, 'Tag', 'grid');
delete(handles_grid)

handles_grid_lm = findobj(handles.axes1, 'Tag', 'grid_lm');
delete(handles_grid_lm)

handles_cont_sampl = findobj(handles.axes1, 'Tag', 'cont_sampl');
delete(handles_cont_sampl)

% update grid / contours first
if gui.showGrid == 1
    if gui.mySpeakerData.hasGridPoints()
        gui.mySpeakerData.plot_grid(col_blue_light, [], gca);
        gui.mySpeakerData.grid.plot_landmarks(col_blue_light, gca)
    end
end

if gui.showContours == 1
    gui.mySpeakerData.plot_contour_sampled(col_orange_dark, gca)
end


% this holds only if Task == 'Edit'
switch gui.modus
    case 'default'
        handles_lm = gui.mySpeakerData.plot_landmarks({}, 'w', gca);
        handles_innerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'inner', 'w', gca);
        handles_outerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'outer', 'w', gca);
     case 'lm'
        handles_innerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'inner', 'w', gca);
        handles_outerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'outer', 'w', gca);
        handles_lm = plot_landmarks(gui.mySpeakerData, {}, col_orange_dark, ...
             gca, @startMoveLandmark);
     case 'inner'
         handles_lm = plot_landmarks(gui.mySpeakerData, {}, 'w', gca);
         handles_outerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'outer', 'w', gca);
         handles_innerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'inner', col_orange_dark, ...
             gca, @startMoveLinePt);
     case 'outer'
         handles_lm = plot_landmarks(gui.mySpeakerData, {}, 'w', gca);
         handles_innerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'inner', 'w', gca);
         handles_outerTrace_raw = gui.mySpeakerData.plot_contour('raw', 'outer', col_orange_dark, ...
             gca, @startMoveLinePt);
end

drawnow;

% update GUI element visibillity
if has_grd_pts
    set(handles.checkboxGrid, 'enable', 'on')
end

if hasValuesOnRawInnerCont
    set(handles.pushbuttonSamplContInner, 'enable', 'on')
end

if hasValuesOnRawOuterCont
    set(handles.pushbuttonSamplContOuter, 'enable', 'on')
end

if hasValuesOnSamplInnerCont || hasValuesOnSamplOuterCont
    set(handles.checkboxContours, 'enable', 'on')
end

if hasFullPointSet
    set(handles.buttonExport, 'enable', 'on')
end


% save
gui.handlesLandmarks = handles_lm;
gui.handlesInnerTrace_raw = handles_innerTrace_raw;
gui.handlesOuterTrace_raw = handles_outerTrace_raw;

set(gcbf, 'UserData', gui);







function startMoveLandmark(hObject, eventdata)

% initialization
gui = get(gcbf, 'UserData');
gui.lmName = get(hObject, 'Tag');

% Remove mouse pointer
set(gcbf,'PointerShapeCData',nan(16,16));
set(gcbf,'Pointer','custom');

% Set callbacks
gui.currenthandle = hObject;
set(gcbf,'WindowButtonMotionFcn',@movePoint);
set(gcbf,'WindowButtonUpFcn',@stopMoveLandmark);

% Store starting point of the object
gui.startpoint = get(gca,'CurrentPoint');
set(gui.currenthandle,'UserData',{get(gui.currenthandle,'XData') get(gui.currenthandle,'YData')});

% save
set(gcbf, 'UserData', gui);


function stopMoveLandmark(hObject, eventdata)

% initialization
gui = get(gcbf, 'UserData');

% actions
coordinates = get(gca,'CurrentPoint'); 
gui.mySpeakerData.(['xy' gui.lmName]) = coordinates(1, 1:2)';

set(gcbf,'Pointer','arrow');
set(gcbf,'WindowButtonUpFcn','');
set(gcbf,'WindowButtonMotionFcn','');

% save
set(gui.currenthandle, 'UserData', '');
set(gcbf, 'UserData', gui);

% re-draw
updateAxes();


function startMoveLinePt(hObject, eventdata)

% initialization
gui = get(gcbf, 'UserData');
gui.pointNumber = str2double(get(hObject, 'Tag'));

% Remove mouse pointer
set(gcbf,'PointerShapeCData',nan(16,16));
set(gcbf,'Pointer','custom');

% Set callbacks
gui.currenthandle = hObject;
set(gcbf, 'WindowButtonMotionFcn', @movePoint);
set(gcbf, 'WindowButtonUpFcn', @stopMoveLinePt);

% Store starting point of the object
gui.startpoint = get(gca, 'CurrentPoint');
set(gui.currenthandle,'UserData',{get(gui.currenthandle,'XData') get(gui.currenthandle,'YData')});

% save 
set(gcbf, 'UserData', gui);



function movePoint(hObject, eventdata)
% initialization
gui = get(gcbf, 'UserData');

try
    if isequal(gui.startpoint,[])
        return
    end
catch
        % nothing to do ...
end

% do "smart" positioning of the object, relative to starting point...
pos = get(gca,'CurrentPoint') - gui.startpoint;
XYData = get(gui.currenthandle, 'UserData');

set(gui.currenthandle,'XData',XYData{1} + pos(1,1));
set(gui.currenthandle,'YData',XYData{2} + pos(1,2));

drawnow;

% save
set(gcbf, 'UserData', gui);


function stopMoveLinePt(hObject, eventdata)

% initialization
gui = get(gcbf, 'UserData');

% actions
switch gui.modus
    case 'inner'
        traceTmp = gui.mySpeakerData.xyInnerTrace_raw;
    case 'outer'
        traceTmp = gui.mySpeakerData.xyOuterTrace_raw;
end
coordinates = get(gca, 'CurrentPoint');

traceTmp(1:2, gui.pointNumber) = coordinates(1, 1:2)';

set(gcbf, 'Pointer','arrow');
set(gcbf, 'WindowButtonUpFcn','');
set(gcbf, 'WindowButtonMotionFcn','');

% save
switch gui.modus
    case 'inner'
        gui.mySpeakerData.xyInnerTrace_raw = traceTmp;
    case 'outer'
        gui.mySpeakerData.xyOuterTrace_raw = traceTmp;
end
set(gui.currenthandle, 'UserData', '');
set(gcbf, 'UserData', gui);

% update graphics
updateAxes();


% --- Executes on button press in buttonSave.
function buttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui = get(handles.figure1, 'UserData');
mySpeakerData = gui.mySpeakerData;
speakerName = mySpeakerData.speakerName;

[filename, pathname] = uiputfile('*_RAW.xml', 'Save as ...', ...
    [pwd '\' speakerName '_RAW.xml']);

mySpeakerData.save_to_XML( [pathname filename] )


% --- Executes on selection change in popupmenuModusSelector.
function popupmenuModusSelector_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuModusSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuModusSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuModusSelector

% initialize
gui = get(gcbf, 'UserData');

% read the selected item
contents = cellstr(get(hObject,'String'));
switch contents{get(hObject,'Value')}
    case 'Landmarks'
        gui.modus = 'lm';
    case 'InnerTrace'
        gui.modus = 'inner';
    case 'OuterTrace'
        gui.modus = 'outer';
end

set(gcbf, 'UserData', gui);

updateAxes();


% --- Executes during object creation, after setting all properties.
function popupmenuModusSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuModusSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateLmSelector(handles)

% initialize
gui = get(gcbf, 'UserData');

% assign possible landmark names
cellStr = get_emptyLandmarkNames(gui.mySpeakerData);
set(handles.popupmenuLmSelector, 'String', cellStr);

function updateTraceSelector(handles)
% initialize
gui = get(gcbf, 'UserData');

% assign possible landmark names
cellStr = get_emptyTraceNames(gui.mySpeakerData);
set(handles.popupmenuTraceSelector, 'String', cellStr);



% --- Executes on selection change in popupmenuLmSelector.
function popupmenuLmSelector_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuLmSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuLmSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuLmSelector
% initialize
gui = get(gcbf, 'UserData');

% read the selected item
contents = cellstr(get(hObject,'String'));
lmStr = contents{get(hObject,'Value')};

posTmp = ginput(1);

gui.mySpeakerData.(['xy' lmStr]) = posTmp';

% save
set(gcbf, 'UserData', gui);

% update menu String-Value
updateLmSelector(handles)

% update graphics
updateAxes();


% --- Executes on selection change in popupmenuTraceSelector.
function popupmenuTraceSelector_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuTraceSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuTraceSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuTraceSelector
gui = get(gcbf, 'UserData');

% read the selected item
contents = cellstr(get(hObject,'String'));
TraceStr = contents{get(hObject,'Value')};

gui.mySpeakerData.(['xy' TraceStr]) = ginput';

% save
set(gcbf, 'UserData', gui);

% update menu String-Value
updateTraceSelector(handles)

% update graphics
updateAxes();


% --- Executes during object creation, after setting all properties.
function popupmenuTraceSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuTraceSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanelTask.
function uipanelTask_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanelTask 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

gui = get(gcbf, 'UserData');
val = get(eventdata.NewValue, 'String');

switch val
    case 'Add'
        gui.modus = 'default';
        set(gcbf, 'UserData', gui);

        updateAxes()
        disablePanel(handles.uipanelEdit)
        enablePanel(handles.uipanelAdd)

    case 'Edit'
        updateAxes()
        disablePanel(handles.uipanelAdd)
        enablePanel(handles.uipanelEdit)
end


function disablePanel(panelHandle)
set(findall(panelHandle, '-property', 'enable'), 'enable', 'off')

function enablePanel(panelHandle)
set(findall(panelHandle, '-property', 'enable'), 'enable', 'on')


% --- Executes during object creation, after setting all properties.
function popupmenuLmSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuLmSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonExport.
function buttonExport_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui = get(handles.figure1, 'UserData');
mySpeakerData = gui.mySpeakerData;
speakerName = mySpeakerData.speakerName;

% snap points to the grid ...
mySpeakerData.xyInnerTrace_sampl = mySpeakerData.sample_contour_on_grid('inner');
mySpeakerData.xyOuterTrace_sampl = mySpeakerData.sample_contour_on_grid('outer');

[filename, pathname] = uiputfile('*_MRI.xml', 'Save as ...', ...
    [pwd '\' speakerName '_MRI.xml']);

mySpeakerData.export_to_XML([pathname filename])


% --- Executes on button press in checkboxGrid.
function checkboxGrid_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGrid

gui = get(gcbf, 'UserData');
gui.showGrid = get(hObject,'Value');
set(gcbf, 'UserData', gui);
updateAxes()


% --- Executes on button press in checkboxContours.
function checkboxContours_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxContours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxContours

gui = get(gcbf, 'UserData');
gui.showContours = get(hObject,'Value');
set(gcbf, 'UserData', gui);
updateAxes()


% --- Executes on button press in pushbuttonSamplContInner.
function pushbuttonSamplContInner_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSamplContInner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui = get(gcbf, 'UserData');
gui.mySpeakerData.xyInnerTrace_sampl = gui.mySpeakerData.sample_contour_on_grid('inner');
set(gcbf, 'UserData', gui);
updateAxes()


% --- Executes on button press in pushbuttonSamplContOuter.
function pushbuttonSamplContOuter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSamplContOuter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui = get(gcbf, 'UserData');
gui.mySpeakerData.xyOuterTrace_sampl = gui.mySpeakerData.sample_contour_on_grid('outer');
set(gcbf, 'UserData', gui);
updateAxes()



% --- Executes on button press in pushbuttonReset.
function pushbuttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
