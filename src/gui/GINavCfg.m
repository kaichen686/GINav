function varargout = GINavCfg(varargin)
% GINAVCFG MATLAB code for GINavCfg.fig
%      GINAVCFG, by itself, creates a new GINAVCFG or raises the existing
%      singleton*.
%
%      H = GINAVCFG returns the handle to a new GINAVCFG or the handle to
%      the existing singleton*.
%
%      GINAVCFG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GINAVCFG.M with the given input arguments.
%
%      GINAVCFG('Property','Value',...) creates a new GINAVCFG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GINavCfg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GINavCfg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GINavCfg

% Last Modified by GUIDE v2.5 25-Dec-2020 12:27:04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GINavCfg_OpeningFcn, ...
                   'gui_OutputFcn',  @GINavCfg_OutputFcn, ...
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


% --- Executes just before GINavCfg is made visible.
function GINavCfg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GINavCfg (see VARARGIN)

% set default processing options and file path
global gls
handles.opt=gls.default_opt;
handles.file=gls.default_file;

% set GUI figure position
H=get(0,'ScreenSize'); h=get(gcf,'Position');
x=H(3)/2-h(3)/2; y=H(4)/2-h(4)/2; h(1)=x; h(2)=y;
set(gcf,'Position',h);

% Choose default command line output for GINavCfg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% wiat for user to configure file
uiwait(hObject);

% UIWAIT makes GINavCfg wait for user response (see UIRESUME)
% uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = GINavCfg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% output processing options and file path 
if isfield(handles,'opt')
    varargout{1} = handles.opt;
else
    varargout{1} = NaN;
end
if isfield(handles,'file')
    varargout{2} = handles.file;
else
    varargout{2} = NaN;
end
if isfield(handles,'gui_flag')
    varargout{3} = handles.gui_flag;
else
    varargout{3} = 0;
end


% close GUI figure
if ~isempty(handles)
    close(handles.figure);
end



function cfg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cfg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cfg_edit as text
%        str2double(get(hObject,'String')) returns contents of cfg_edit as a double
global gls
cfg_file_fullname=get(hObject,'String');
if isempty(cfg_file_fullname)
    handles=rmfield(handles,'opt');
    handles.opt=gls.default_opt;
    guidata(hObject,handles);
else
    if ~exist(cfg_file_fullname,'file')
        error('The configuration file does not exist');
    end
    handles.cfg_edit.String=cfg_file_fullname;
    handles.opt=decode_cfg(handles.opt,cfg_file_fullname);
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function cfg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cfg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in cfg_pb.
function cfg_pb_Callback(hObject, eventdata, handles)
% hObject    handle to cfg_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glc
fullpath=which('GINavExe.m');
[path,~,~]=fileparts(fullpath);
conf_pathname=[path,glc.sep,'conf',glc.sep];
[filename,pathname] = uigetfile('*.ini','Select configration file',conf_pathname);
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The configuration file does not exist');
    end
    handles.cfg_edit.String=fullname;
    % decode configuration file
    handles.opt=decode_cfg(handles.opt,fullname);
    % match required input file
    handles=matchinfile(handles);
    handles.mainpath=handles.file.path;
    guidata(hObject,handles);
end

function obsr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to obsr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obsr_edit as text
%        str2double(get(hObject,'String')) returns contents of obsr_edit as a double
obsr_file_fullname=get(hObject,'String');
if isempty(obsr_file_fullname)
    handles.file.obsr='';
    guidata(hObject,handles);
else
    if ~exist(obsr_file_fullname,'file')
        error('The rover observation file does not exist');
    end
    handles.obsr_edit.String=obsr_file_fullname;
    handles.file.obsr=obsr_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function obsr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obsr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in obsr_pb.
function obsr_pb_Callback(hObject, eventdata, handles)
% hObject    handle to obsr_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.*o';'*.*O';'*.obs'},'Select rover observation file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.*o';'*.*O';'*.obs'},'Select rover observation file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The rover observation file does not exist');
    end
    handles.obsr_edit.String=fullname;
    handles.file.obsr=fullname;
    handles.mainpath=pathname;
    guidata(hObject,handles);
end

function beph_edit_Callback(hObject, eventdata, handles)
% hObject    handle to beph_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beph_edit as text
%        str2double(get(hObject,'String')) returns contents of beph_edit as a double
beph_file_fullname=get(hObject,'String');
if isempty(beph_file_fullname)
    handles.file.beph='';
    guidata(hObject,handles);
else
    if ~exist(beph_file_fullname,'file')
        error('The broadcast ephemeris file does not exist');
    end
    handles.beph_edit.String=beph_file_fullname;
    handles.file.beph=beph_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function beph_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beph_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in beph_pb.
function beph_pb_Callback(hObject, eventdata, handles)
% hObject    handle to beph_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.*n';'*.*N';'*.*p';'*.*P'},'Select broadcast ephemeris file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.*n';'*.*N';'*.*p';'*.*P'},'Select broadcast ephemeris file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The broadcast ephemeris file does not exist');
    end
    handles.beph_edit.String=fullname;
    handles.file.beph=fullname;
    guidata(hObject,handles);
end

function obsb_edit_Callback(hObject, eventdata, handles)
% hObject    handle to obsb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obsb_edit as text
%        str2double(get(hObject,'String')) returns contents of obsb_edit as a double
obsb_file_fullname=get(hObject,'String');
if isempty(obsb_file_fullname)
    handles.file.obsb='';
    guidata(hObject,handles);
else
    if ~exist(obsb_file_fullname,'file')
        error('The base observation file does not exist');
    end
    handles.obsb_edit.String=obsb_file_fullname;
    handles.file.obsb=obsb_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function obsb_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obsb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in obsb_pb.
function obsb_pb_Callback(hObject, eventdata, handles)
% hObject    handle to obsb_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.*o';'*.*O';'*.obs'},'Select base observation file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.*o';'*.*O';'*.obs'},'Select base observation file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The base observation file does not exist');
    end
    handles.obsb_edit.String=fullname;
    handles.file.obsb=fullname;
    guidata(hObject,handles);
end

function sp3_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sp3_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sp3_edit as text
%        str2double(get(hObject,'String')) returns contents of sp3_edit as a double
sp3_file_fullname=get(hObject,'String');
if isempty(sp3_file_fullname)
    handles.file.sp3='';
    guidata(hObject,handles);
else
    if ~exist(sp3_file_fullname,'file')
        error('The precise ephemeris file does not exist');
    end
    handles.sp3_edit.String=sp3_file_fullname;
    handles.file.sp3=sp3_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function sp3_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sp3_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in sp3_pb.
function sp3_pb_Callback(hObject, eventdata, handles)
% hObject    handle to sp3_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.sp3';'*.SP3';'*.eph';'*.EPH'},'Select precise ephemeris file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.sp3';'*.SP3';'*.eph';'*.EPH'},'Select precise ephemeris file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The precise ephemeris file does not exist');
    end
    handles.sp3_edit.String=fullname;
    handles.file.sp3=fullname;
    guidata(hObject,handles);
end

function clk_edit_Callback(hObject, eventdata, handles)
% hObject    handle to clk_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clk_edit as text
%        str2double(get(hObject,'String')) returns contents of clk_edit as a double
clk_file_fullname=get(hObject,'String');
if isempty(clk_file_fullname)
    handles.file.clk='';
    guidata(hObject,handles);
else
    if ~exist(clk_file_fullname,'file')
        error('The clock ephemeris file does not exist');
    end
    handles.clk_edit.String=clk_file_fullname;
    handles.file.clk=clk_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function clk_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clk_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in clk_pb.
function clk_pb_Callback(hObject, eventdata, handles)
% hObject    handle to clk_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.clk';'*.CLK'},'Select precise clock file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.clk';'*.CLK'},'Select precise clock file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The clock ephemeris file does not exist');
    end
    handles.clk_edit.String=fullname;
    handles.file.clk=fullname;
    guidata(hObject,handles);
end


function atx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to atx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of atx_edit as text
%        str2double(get(hObject,'String')) returns contents of atx_edit as a double
atx_file_fullname=get(hObject,'String');
if isempty(atx_file_fullname)
    handles.file.atx='';
    guidata(hObject,handles);
else
    if ~exist(atx_file_fullname,'file')
        error('The atx file does not exist');
    end
    handles.atx_edit.String=atx_file_fullname;
    handles.file.atx=atx_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function atx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to atx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in atx_pb.
function atx_pb_Callback(hObject, eventdata, handles)
% hObject    handle to atx_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.atx';'*.ATX'},'Select atx file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.atx';'*.ATX'},'Select atx file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The atx file does not exist');
    end
    handles.atx_edit.String=fullname;
    handles.file.atx=fullname;
    guidata(hObject,handles);
end


function DCB_edit_Callback(hObject, eventdata, handles)
% hObject    handle to DCB_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DCB_edit as text
%        str2double(get(hObject,'String')) returns contents of DCB_edit as a double
global glc
DCB_file_fullname=get(hObject,'String');
if isempty(DCB_file_fullname)
    for i=1:3
        handles.file.dcb{1,i}='';
    end
    guidata(hObject,handles);
else
    idx=find(DCB_file_fullname==glc.sep); pathname=DCB_file_fullname(1:idx(end));
    files = dir([pathname,'*.','DCB']);
    nf=size(files,1);
    for i=1:nf
        fullname=[pathname,files(i).name];
        if ~exist(fullname,'file')
            error('The DCB file does not exist');
        end
        handles.file.dcb{1,i}=fullname;
    end
    handles.DCB_edit.String=[pathname,'*.DCB'];
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function DCB_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCB_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in DCB_pb.
function DCB_pb_Callback(hObject, eventdata, handles)
% hObject    handle to DCB_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [~,pathname] = uigetfile({'*.dcb';'*.DCB'},'Select DCB file',handles.mainpath);
else
    [~,pathname] = uigetfile({'*.dcb';'*.DCB'},'Select DCB file');
end
if any(pathname)
    files = dir([pathname,'*.','DCB']);
    nf=size(files,1);
    for i=1:nf
        fullname=[pathname,files(i).name];
        if ~exist(fullname,'file')
            error('The DCB file does not exist');
        end
        handles.file.dcb{1,i}=fullname;
        guidata(hObject,handles);
    end
    handles.DCB_edit.String=[pathname,'*.DCB'];
    guidata(hObject,handles);
end

function BSX_edit_Callback(hObject, eventdata, handles)
% hObject    handle to BSX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BSX_edit as text
%        str2double(get(hObject,'String')) returns contents of BSX_edit as a double
BSX_file_fullname=get(hObject,'String');
if isempty(BSX_file_fullname)
    handles.file.dcb_mgex='';
    guidata(hObject,handles);
else
    if ~exist(BSX_file_fullname,'file')
        error('The BSX file does not exist');
    end
    handles.BSX_edit.String=BSX_file_fullname;
    handles.file.dcb_mgex=BSX_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function BSX_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BSX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in BSX_pb.
function BSX_pb_Callback(hObject, eventdata, handles)
% hObject    handle to BSX_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.bsx';'*.BSX'},'Select BSX file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.bsx';'*.BSX'},'Select BSX file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The BSX file does not exist');
    end
    handles.BSX_edit.String=fullname;
    handles.file.dcb_mgex=fullname;
    guidata(hObject,handles);
end

function erp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to erp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of erp_edit as text
%        str2double(get(hObject,'String')) returns contents of erp_edit as a double
erp_file_fullname=get(hObject,'String');
if isempty(erp_file_fullname)
    handles.file.erp='';
    guidata(hObject,handles);
else
    if ~exist(erp_file_fullname,'file')
        error('The erp file does not exist');
    end
    handles.erp_edit.String=erp_file_fullname;
    handles.file.erp=erp_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function erp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to erp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in erp_pb.
function erp_pb_Callback(hObject, eventdata, handles)
% hObject    handle to erp_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.erp';'*.ERP'},'Select erp file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.erp';'*.ERP'},'Select erp file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The erp file does not exist');
    end
    handles.erp_edit.String=fullname;
    handles.file.erp=fullname;
    guidata(hObject,handles);
end

function blq_edit_Callback(hObject, eventdata, handles)
% hObject    handle to blq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blq_edit as text
%        str2double(get(hObject,'String')) returns contents of blq_edit as a double
blq_file_fullname=get(hObject,'String');
if isempty(blq_file_fullname)
    handles.file.blq='';
    guidata(hObject,handles);
else
    if ~exist(blq_file_fullname,'file')
        error('The blq file does not exist');
    end
    handles.blq_edit.String=blq_file_fullname;
    handles.file.blq=blq_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function blq_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in blq_pb.
function blq_pb_Callback(hObject, eventdata, handles)
% hObject    handle to blq_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.blq';'*.BLQ'},'Select blq file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.blq';'*.BLQ'},'Select blq file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The blq file does not exist');
    end
    handles.blq_edit.String=fullname;
    handles.file.blq=fullname;
    guidata(hObject,handles);
end

function imu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to imu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imu_edit as text
%        str2double(get(hObject,'String')) returns contents of imu_edit as a double
imu_file_fullname=get(hObject,'String');
if isempty(imu_file_fullname)
    handles.file.imu='';
    guidata(hObject,handles);
else
    if ~exist(imu_file_fullname,'file')
        error('The imu file does not exist');
    end
    handles.imu_edit.String=imu_file_fullname;
    handles.file.imu=imu_file_fullname;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function imu_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in imu_pb.
function imu_pb_Callback(hObject, eventdata, handles)
% hObject    handle to imu_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mainpath')
    [filename,pathname] = uigetfile({'*.csv';'*.CSV'},'Select imu file',handles.mainpath);
else
    [filename,pathname] = uigetfile({'*.csv';'*.CSV'},'Select imu file');
end
if any(filename)
    fullname=[pathname,filename];
    if ~exist(fullname,'file')
        error('The imu file does not exist');
    end
    handles.imu_edit.String=fullname;
    handles.file.imu=fullname;
    guidata(hObject,handles);
end

% --- Executes on button press in run_pb.
function run_pb_Callback(hObject, eventdata, handles)
% hObject    handle to run_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.gui_flag=1;
guidata(hObject,handles);
uiresume(handles.figure);

% --- Executes on button press in quit_pb.
function quit_pb_Callback(hObject, eventdata, handles)
% hObject    handle to quit_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.gui_flag=0;
guidata(hObject,handles);
uiresume(handles.figure);
