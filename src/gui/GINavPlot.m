function varargout = GINavPlot(varargin)
% GINAVPLOT MATLAB code for GINavPlot.fig
%      GINAVPLOT, by itself, creates a new GINAVPLOT or raises the existing
%      singleton*.
%
%      H = GINAVPLOT returns the handle to a new GINAVPLOT or the handle to
%      the existing singleton*.
%
%      GINAVPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GINAVPLOT.M with the given input arguments.
%
%      GINAVPLOT('Property','Value',...) creates a new GINAVPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GINavPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GINavPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GINavPlot

% Last Modified by GUIDE v2.5 23-Dec-2020 21:34:33
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GINavPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @GINavPlot_OutputFcn, ...
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


% --- Executes just before GINavPlot is made visible.
function GINavPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GINavPlot (see VARARGIN)

H=get(0,'ScreenSize'); h=get(gcf,'Position');
x=H(3)/2-h(3)/2; y=H(4)/2-h(4)/2; h(1)=x; h(2)=y;
set(gcf,'Position',h);

% Choose default command line output for GINavPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GINavPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GINavPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in solfile.
function solfile_Callback(hObject, eventdata, handles)
% hObject    handle to solfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glc
fullpath=which('GINavExe.m');
[path,~,~]=fileparts(fullpath); 
result_path=[path,glc.sep,'result',glc.sep];
[filename,pathname] = uigetfile('*.pos','Select solution file',result_path);
if any(filename)
    fullname = [pathname filename];
    if ~exist(fullname,'file')
        error('The solution file does not exist!!!');
    end
    idx=find(filename=='.');
    if any(idx)
        suffix=filename(idx+1:end);
    else
        error('Incorrect file suffix name!!!');
    end
    switch suffix
        case 'mat'
            load(fullname);
        case 'pos'
            solution=readGINavsol(fullname);
        case 'pva'
            solution=readGINavsol(fullname);
    end
    handles.solution=solution;
    guidata(hObject,handles)
else
    fprintf('Please reselect solution file!!!\n');
end


% --- Executes on selection change in plot_any.
function plot_any_Callback(hObject, eventdata, handles)
% hObject    handle to plot_any (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plot_any contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plot_any
solution=handles.solution;
str = get(handles.plot_any,'String');
val = get(handles.plot_any,'Value');
switch str{val}
    case 'Trajectory'
        plot_trajectory(solution);
    case 'Position'
        plot_position(solution);
    case 'Velocity'
        plot_velocity(solution);
    case 'Number of satellite'
        plot_nsat(solution);
    case 'AR ratio factor'
        plot_ARratio(solution);
end

% --- Executes during object creation, after setting all properties.
function plot_any_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_any (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function staname_Callback(hObject, eventdata, handles)
% hObject    handle to staname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of staname as text
%        str2double(get(hObject,'String')) returns contents of staname as a double
station_name=get(handles.staname,'String');
if any(station_name)
    handles.station_name=station_name;
    guidata(hObject,handles);
else
    fprintf('Please re-enter the station name!!!\n');
end

% --- Executes during object creation, after setting all properties.
function staname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SNX.
function SNX_Callback(hObject, eventdata, handles)
% hObject    handle to SNX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.snx';'*.SNX'},'Select SNX file');
if any(filename)
    snxfilename = [pathname filename];
    if ~exist(snxfilename,'file')
        error('The SNX file does not exist!!!');
    end
    handles.snxfilename=snxfilename;
    guidata(hObject,handles);
else
   fprintf('Please reselect SNX file!!!\n');
end

% --- Executes on button press in plotPPP.
function plotPPP_Callback(hObject, eventdata, handles)
% hObject    handle to plotPPP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
station_name=handles.station_name;
snxfilename=handles.snxfilename;
solution=handles.solution;
plot_ppp_err(solution,station_name,snxfilename);

% --- Executes on button press in ref.
function ref_Callback(hObject, eventdata, handles)
% hObject    handle to ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat','Select pos reference data');
if any(filename)
    fullname = [pathname filename];
    if ~exist(fullname,'file')
        error('The pos reference file does not exist!!!');
    end
    load(fullname);
    handles.reference=reference;
    guidata(hObject,handles)
else
    fprintf('Please reselect pos ref file!!!\n');
end


% --- Executes on selection change in plot_err.
function plot_err_Callback(hObject, eventdata, handles)
% hObject    handle to plot_err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plot_err contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plot_err
solution  = handles.solution;
reference = handles.reference;
str = get(handles.plot_err,'String');
val = get(handles.plot_err,'Value');
switch str{val}
    case 'Position error'
        plot_pva_err(solution,reference,1)
    case 'Velocity error'
        plot_pva_err(solution,reference,2)
    case 'Attitude error'
        plot_pva_err(solution,reference,3)
end

% --- Executes during object creation, after setting all properties.
function plot_err_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
