function varargout = validate_gui(varargin)
% validate_gui MATLAB code for validate_gui.fig
%      validate_gui, by itself, creates a new validate_gui or raises the existing
%      singleton*.
%
%      H = validate_gui returns the handle to a new validate_gui or the handle to
%      the existing singleton*.
%
%      validate_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in validate_gui.M with the given input arguments.
%
%      validate_gui('Property','Value',...) creates a new validate_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before validate_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to validate_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help validate_gui

% Last Modified by GUIDE v2.5 18-Nov-2017 17:52:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @validate_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @validate_gui_OutputFcn, ...
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


% --- Executes just before validate_gui is made visible.
function validate_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to validate_gui (see VARARGIN)

% Choose default command line output for validate_gui
handles.output = hObject;
handles.rangeFiltSelected = 0;

% Set the default area as all 1s (everything is shown, no mask)
handles.area = ones(520, 696);

% Initialize variables
handles.labelledImageStr = [];
handles.capArea = [];
handles.fnames = {};
handles.fnames442 = {};
handles.fnames454 = {};
handles.frameNumber = 1;
handles.rangeFiltSelected = 0;
handles.textSelected = 0;
handles.boxSelected = 0;
handles.impointArray = impoint(gca, 0, 0);
handles.impointArray.setColor('w');
handles.dividerPoints = 0;
handles.dividerPositionPos = zeros(1,2);

% Validate mode unique!
handles.validateMode = false;
handles.dividerMode = false; % For adding dividers in validate mode
handles.focusMask = [];
handles.focusColor = [];
handles.focusColorMode = true;
handles.detectedCapSelected = true;
handles.lastTouched = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes validate_gui wait for user response (see UIRESUME)
%uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
% This is actually the last function that runs when you close the gui
% because of uiresume in closingfcn 
function varargout = validate_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.capArea;
%delete(hObject); % Clean up

% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Load the frames specified by the user inputted path
try
    [fnames, path] = getFnames;
catch ME
    return
end

handles.fnames = fnames;
handles.fnames442 = fnames;
handles.fnames454 = strrep(fnames, '442', '454');

% Loading bar since it seems to take a while
h = waitbar(0,'Loading..');

% Get the path string and use it to find the labelled image
path = strrep(path, 'Captured', 'Processed');


% Remove wavelength directory string
path = strrep(path, [filesep '442'], '');
path = strrep(path, [filesep '454'], '');


waitbar(0.25,h);

handles.fovName = path(strfind(path, 'X20'):end-1);
handles.labelledImageStr = strrep([path 'VesselGeometry/' handles.fovName 'GradientImageLabelled.fig'], '\', '/');

% Show the first frame in axes1
imshow(imread(fnames{1}), 'Parent', handles.axes1, 'DisplayRange', [0 65536]);

% Calculate and store the variance image of the frames
handles.varianceImage = imread(strrep([path 'Functional-16bitImages/' handles.fovName '-16bit442Var.tif'], '\', '/'));

% Store the max image of the frames
handles.maxImage = imread(strrep([path 'Functional-16bitImages/' handles.fovName '-16bit442Max.tif'], '\', '/'));

% Store the capillary area mask
[handles.capArea, handles.idList] = getCapillaries(handles.varianceImage);

handles.focusMask = zeros(size(handles.capArea));


% Store location of capillary text labels
handles.coords = getLabelLocation(handles.capArea, handles.idList);
handles.textHandles = zeros(size(handles.idList, 1));

waitbar(0.50,h);

% Calculate data for labelled image
showArea = imread(handles.fnames{handles.frameNumber});
showArea(~handles.capArea) = 0;
hImage = imshow(showArea, 'Parent', handles.axes2, 'DisplayRange', [0 65536]);
set(hImage,'ButtonDownFcn',@image_ButtonDownFcn);


waitbar(0.75,h);
set(handles.text1, 'String', [handles.fovName ' loaded']);
handles.impointArray = impoint(gca, 0, 0);
handles.impointArray.setColor('w');
guidata(hObject, handles);
close(h);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.frameNumber = uint8(str2double(get(hObject, 'String')));
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% Get the current frame number from the editable text
handles.frameNumber = uint8(str2double(get(hObject, 'String')));

% Set the location of the slider
set(handles.slider1, 'Value', str2double(get(hObject, 'String')));

% Show the current frame / area
refresh(hObject, handles);
guidata(hObject, handles);



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% If the frame has not been loaded yet, do nothing
if isempty(handles.fnames)
    return;
end

% Get the current frame number from the slider location
handles.frameNumber = uint16(get(hObject, 'Value'));

% Set the editable text value
set(handles.edit1, 'String', handles.frameNumber);

refresh(hObject, handles);

guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% If the frame has not been loaded yet, do nothing
if isempty(handles.fnames)
    return;
    
elseif strcmp(get(hObject, 'Tag'), 'capillary_button')
    handles.area = handles.capArea;
    handles.rangeFiltSelected = 0;
    handles = refresh(hObject, handles);
    
elseif strcmp(get(hObject, 'Tag'), 'range_button')
    handles.area = handles.capArea;
    handles.rangeFiltSelected = 1;
    handles = refresh(hObject, handles);
    
else
    handles.area = ones(520, 696);
    handles.rangeFiltSelected = 0;
    handles = refresh(hObject, handles);
end

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on key press with focus on slider1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% If the frame has not been loaded yet, do nothing
if isempty(handles.fnames)
    return;
end

switch eventdata.Key
    case 'rightarrow'
        if str2double(get(handles.edit1, 'String')) + 1 <= 1260
            set(handles.slider1, 'Value', str2double(get(handles.edit1, 'String')) + 1);
            set(handles.edit1, 'String', str2double(get(handles.edit1, 'String')) + 1);
            handles.frameNumber = handles.frameNumber + 1;
            refresh(hObject, handles);
        end
        
    case 'leftarrow'
        if str2double(get(handles.edit1, 'String')) - 1 > 0
            set(handles.slider1, 'Value', str2double(get(handles.edit1, 'String')) - 1);
            set(handles.edit1, 'String', str2double(get(handles.edit1, 'String')) - 1);
            handles.frameNumber = handles.frameNumber - 1;
            refresh(hObject, handles);
        end
    
    otherwise
        
end


guidata(hObject, handles);



% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% If the frame has not been loaded yet, do nothing
if isempty(handles.fnames)
    return;
end

if strcmp(get(hObject, 'Tag'), 'var_button')
    hImage = imshow(handles.varianceImage, 'Parent', handles.axes2, 'DisplayRange', []);
    handles.detectedCapSelected = false;
    % Add callback function to the image
    set(hImage,'ButtonDownFcn',@image_ButtonDownFcn);
elseif strcmp(get(hObject, 'Tag'), 'label_button')
    handles.detectedCapSelected = false;
    if exist(handles.labelledImageStr, 'file')
        openfig(handles.labelledImageStr, 'new', 'invisible');
        myhandle = findall(gcf, 'type', 'image');
        labelledImage = get(myhandle, 'cdata');
        hImage = imshow(labelledImage, 'Parent', handles.axes2, 'DisplayRange', []);
        myhandle = findall(gcf, 'type', 'text');
        handles.position = get(myhandle, 'position');
        handles.textStr = get(myhandle, 'string');
        delete(gcf);
        axes(handles.axes2);

        for i = 1:size(handles.position, 1)
        cellData = handles.position{i};
            if cellData(2) >= 0 && cellData(1) >= 0 && ~strcmp(handles.textStr{i}, 'pixels')
                text(cellData(1), cellData(2), handles.textStr{i}, 'Color', 'white');
            end
        end
    end
    % Add callback function to the image
    set(hImage,'ButtonDownFcn',@image_ButtonDownFcn);
else
    handles.detectedCapSelected = true;
    handles = refresh(hObject, handles);
end


guidata(hObject, handles);

    


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

function handles = refresh (hObject, handles)
% If the frame has not been loaded yet, do nothing
if isempty(handles.fnames)
    return;
end


axes(handles.axes1);
showArea = imread(handles.fnames{handles.frameNumber});


if handles.rangeFiltSelected
    showArea = rangefilt(showArea);
    showArea(~handles.area) = 0;
    imshow(showArea, 'Parent', handles.axes1, 'DisplayRange', []);
else
    showArea(~handles.area) = 0;
    imshow(showArea, 'Parent', handles.axes1, 'DisplayRange', [0 65536]);
end

if handles.textSelected
    if handles.area == handles.capArea
        color = 'white';
    else
        color = 'black';
    end
    
    for i = 1:size(handles.idList, 1)
        text(handles.coords(i, 2), handles.coords(i, 1), num2str(handles.idList(i, 1)), 'Color', color);
    end
    
end

% Focus mask code
handles.focusMask = zeros(size(handles.focusMask));
for i = 1:handles.dividerPoints
    
    coords = handles.dividerPositionPos(i, :);
    if handles.capArea(round(coords(2)), round(coords(1))) ~= 0
        capID = handles.capArea(round(coords(2)), round(coords(1)));
        handles.focusMask(handles.capArea == capID) = 1337;
        
        % Set the bottom half to red
        [hy,hx] = find(handles.capArea == capID);
        
        hx = hx(hy > coords(2));
        hy = hy(hy > coords(2));
        
        midSubs = sub2ind(size(handles.capArea), hy, hx);
        handles.focusMask(midSubs) = 9001;
    end
end

% Refresh frame for axes2 if it is in detected capillary mode
if handles.detectedCapSelected
    axes(handles.axes2);
    showArea = imread(handles.fnames{handles.frameNumber});
    showArea(~handles.capArea) = 0;
    hImage = imshow(showArea, 'Parent', handles.axes2, 'DisplayRange', [0 65536]);
    set(hImage,'ButtonDownFcn',@image_ButtonDownFcn);
    if handles.focusColorMode
        % Calculate focus color mask
        inFocusArea = find(handles.focusMask == 1337);
        noFocusArea = find(handles.focusMask == 9001);
        r = uint8(zeros(size(handles.capArea)));
        g = uint8(zeros(size(handles.capArea)));
        b = uint8(zeros(size(handles.capArea)));

        r(inFocusArea) = 124;
        g(inFocusArea) = 252;
        b(inFocusArea) = 0;
        
        r(noFocusArea) = 252;
        g(noFocusArea) = 0;
        b(noFocusArea) = 0;
        
        handles.focusColor = cat(3, r, g, b);

        hold on
        hFocusMask = imshow(handles.focusColor);
        alphaData = zeros(size(handles.capArea)) + 0.3;
        alphaData(handles.focusMask ~= 1337 & handles.focusMask ~= 9001) = 0;

        set(hFocusMask, 'AlphaData', alphaData, 'ButtonDownFcn',@image_ButtonDownFcn);
        hold off
    end
    
end



% Refresh impoints
if handles.dividerPoints > 0
    for i=1:handles.dividerPoints
        handles.impointArray(i) = impoint(gca, handles.dividerPositionPos(i,:));
        pointMoved = @(pos) impointCallback (pos, hObject, handles, i);
        addNewPositionCallback(handles.impointArray(i), pointMoved);
        fprintf('redrawing\n');
    end
end



% --- Executes on button press in labelbutton.
function labelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to labelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of labelbutton
if get(hObject, 'Value')
    handles.textSelected = 1;
else
    handles.textSelected = 0;
end

refresh(hObject, handles);
guidata(hObject, handles);

% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Used in validate_gui to find a location to place the ID label of a capillary
% Puts it at the highest y-coordinate

function coords = getLabelLocation(area, idList)

coords = zeros(size(idList));

for i = 1:size(idList, 1)
% Get smallest Y-value
indices = find(area == idList(i, 1));

subs = zeros(numel(indices), 2);
[subs(:, 1), subs(:, 2)] = ind2sub(size(area), indices);
subs = sortrows(subs, 1);
coords(i, :) = subs(1, :);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%uiresume(handles.figure1)
delete(hObject);




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.validateMode = ~handles.validateMode;

if handles.validateMode
    set(handles.pushbutton5, 'String', 'Exit Focus Assign');
else
    set(handles.pushbutton5, 'String', 'Enter Focus Assign');
end



guidata(hObject, handles);



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.validateMode
    
    get(hObject,'CurrentPoint')
end

function image_ButtonDownFcn(hObject, eventdata)
handles = guidata(hObject);
if handles.validateMode
    hAxes  = get(hObject,'Parent');
    coordinates = get(hAxes,'CurrentPoint'); 
    coordinates = uint16(coordinates(1,1:2));
    
    id = handles.capArea(coordinates(2), coordinates(1));
    if id ~= 0
        id
        selectedCap = handles.focusMask(handles.capArea == id);
        if selectedCap(1) ~= 0
            handles.focusMask(handles.capArea == id) = 0;
        else
            if eventdata.Button == 1
                handles.focusMask(handles.capArea == id) = 1337;
            else
                handles.focusMask(handles.capArea == id) = 9001;
            end
        end
    end
    
    guidata(hObject, handles);
    refresh(hObject, handles);

end


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12
if get(hObject, 'Value')
    handles.focusColorMode = true;
else
    handles.focusColorMode = false;
end
refresh(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
capArea = handles.capArea;
focusMask = handles.focusMask;
uisave({'capArea', 'focusMask'}, [handles.fovName '-results']);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(hObject.String, 'Play')
    hObject.String = 'Pause';
else
    hObject.String = 'Play'; 
end

axes(handles.axes1);
while strcmp(hObject.String, 'Pause') && handles.frameNumber <= length(handles.fnames)
    showArea = imread(handles.fnames{handles.frameNumber});
    showArea(~handles.area) = 0;
    imshow(showArea, 'Parent', handles.axes1, 'DisplayRange', [0 65536]);
    
    if handles.frameNumber ~= length(handles.fnames)
        handles.frameNumber = handles.frameNumber + 1;
    end
    
    % Set the editable text value
    set(handles.edit1, 'String', handles.frameNumber);
    guidata(hObject, handles);
    pause(0.025);
    
end


% --- Executes on button press in dividebutton.
function dividebutton_Callback(hObject, eventdata, handles)
% hObject    handle to dividebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);
handles.impointArray(handles.dividerPoints + 1) = impoint();
%id = handles.dividerPoints + 1;

coords = getPosition(handles.impointArray(handles.dividerPoints + 1));

handles.dividerPositionPos(handles.dividerPoints + 1, :) = coords;
handles.dividerPoints = handles.dividerPoints + 1;

handles.lastTouched = handles.dividerPoints;

% This seems to work as long as the impointCallback is added after
% dividerPoint is increased?
pointMoved = @(pos) impointCallback (pos, hObject, handles, handles.dividerPoints);
addNewPositionCallback(handles.impointArray(handles.dividerPoints), pointMoved);

% Focus mask code
if handles.capArea(round(coords(2)), round(coords(1))) ~= 0
    capID = handles.capArea(round(coords(2)), round(coords(1)));
    handles.focusMask(handles.capArea == capID) = 1337;
end



handles = refresh(hObject, handles);
guidata(hObject, handles);


function impointCallback (coords, hObject, handles, id)
id
%handles.dividerPoints
coords = round(coords);
handles.capArea(coords(2), coords(1))
handles.dividerPositionPos(id, :) = coords;
handles.lastTouched = id;
guidata(hObject, handles);


% --- Executes on button press in button442.
function button442_Callback(hObject, eventdata, handles)
% hObject    handle to button442 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button442


% --- Executes on button press in button454.
function button454_Callback(hObject, eventdata, handles)
% hObject    handle to button454 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button454


% --- Executes when selected object is changed in wavelengthPanel.
function wavelengthPanel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in wavelengthPanel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.fnames)
    return;
end

if strcmp(get(hObject, 'Tag'), 'button442')
    handles.fnames = handles.fnames442;
else
    handles.fnames = handles.fnames454;
end

handles = refresh(hObject, handles);
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('Button up\n');
%if handles.dividerPoints > 0
stack = dbstack;
if ~strcmp(stack(end-3).name, 'dividebutton_Callback')

    
    handles = refresh(hObject, handles);
    guidata(hObject, handles);
end
%end
