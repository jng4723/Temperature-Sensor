function varargout = Temp(varargin)
% TEMP MATLAB code for Temp.fig
%      TEMP, by itself, creates a new TEMP or raises the existing
%      singleton*.
%
%      H = TEMP returns the handle to a new TEMP or the handle to
%      the existing singleton*.
%
%      TEMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEMP.M with the given input arguments.
%
%      TEMP('Property','Value',...) creates a new TEMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Temp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Temp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Temp

% Last Modified by GUIDE v2.5 08-Nov-2019 13:11:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Temp_OpeningFcn, ...
                   'gui_OutputFcn',  @Temp_OutputFcn, ...
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


% --- Executes just before Temp is made visible.
function Temp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Temp (see VARARGIN)

% Choose default command line output for Temp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Temp wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Temp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
START = 1;
str = datetime;
startTime = datestr(str);
set(handles.Time_Start_Tag, 'String', startTime);
runTimeHr = str2double(get(handles.hrRunTime_val,'String'));                %Takes user input from GUI
runTime = runTimeHr*60*60;                                                  %How long program will run (seconds)
intervals = str2double(get(handles.samplesPerHour_val,'String'));           %Takes user input from GUI
pauseTime = intervals*60;                                                   %When program takes a sample for sensor
arr = runTime/pauseTime;
axes(handles.axes1);
if START == 1
    %try catch loop is if there is an error it runs a different set 
    try                                                                    %If error do this
                     fclose(instrfind)                                     %Only line diffence between the try catch, this closes the previous open serial monitor 
                     sMonitor = serial ('COM3');                                             %Check COM connected
                     fopen(sMonitor);                                                        %Allows to read serial monitor from Arduino
                     i = 1;
                    yTemp =  zeros((arr-1),1);                                              %Array where data will be stored               
                        while i < arr
                            str = fscanf(sMonitor);                                         %Reading Serial Monitor from Arduino 
                            val = str2double(str)                                           %DISPLAYS TEMP VALUES TO CMD
                            yTemp(i)= val;

                            pause(pauseTime);                                               %wait time before the next iteration
                            i = i + 1;
                            plot(yTemp)
                        end

                     fclose(instrfind)                                                      %Closes session of serial monitor
                     xlabel(handles.axes1,'Time Elapsed (s)')                               %Label X axes
                     ylabel(handles.axes1,'Temperature (F)')                                %Label Y axes
                     START = 0;                                                             %Closes loop


                strEnd = datetime;
                endTime = datestr(strEnd);
                set(handles.endTime, 'String', endTime); 

                %################## Save Data %##################

                getdata = findall(handles.axes1,'type','line');
                oldTemps = get(getdata,'Ydata');
                time = [1:runTime-1]';
                temps = oldTemps';
                filename = [datestr(now,'yyyy-mm-dd_HHMMSS'),'.mat'];
                save(filename,'time','temps');
    catch                                                                  %if there is no error then do this 
                 sMonitor = serial ('COM3');                                             %Check COM connected
                 fopen(sMonitor);                                                        %Allows to read serial monitor from Arduino
                 i = 1;
                yTemp =  zeros((arr-1),1);                                              %Array where data will be stored               
                    while i < arr
                        str = fscanf(sMonitor);                                         %Reading Serial Monitor from Arduino 
                        val = str2double(str)                                           %DISPLAYS TEMP VALUES TO CMD
                        yTemp(i)= val;

                        pause(pauseTime);                                               %wait time before the next iteration
                        i = i + 1;
                        plot(yTemp)
                    end

                 fclose(instrfind)                                                      %Closes session of serial monitor
                 xlabel(handles.axes1,'Time Elapsed (s)')                               %Label X axes
                 ylabel(handles.axes1,'Temperature (F)')                                %Label Y axes
                 START = 0;                                                             %Closes loop


            strEnd = datetime;
            endTime = datestr(strEnd);
            set(handles.endTime, 'String', endTime); 

            %################## Save Data %##################

            getdata = findall(handles.axes1,'type','line');
            oldTemps = get(getdata,'Ydata');
            time = [1:runTime-1]';
            temps = oldTemps';
            filename = [datestr(now,'yyyy-mm-dd_HHMMSS'),'.mat'];
            save(filename,'time','temps');
    end                                                                    % end of the try catch loop
end                                                                        % end of button press



function NumHours_Callback(hObject, eventdata, handles)
% hObject    handle to NumHours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumHours as text
%        str2double(get(hObject,'String')) returns contents of NumHours as a double


% --- Executes during object creation, after setting all properties.
function NumHours_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumHours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hrRunTime_val_Callback(hObject, eventdata, handles)
% hObject    handle to hrRunTime_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hrRunTime_val as text
%        str2double(get(hObject,'String')) returns contents of hrRunTime_val as a double


% --- Executes during object creation, after setting all properties.
function hrRunTime_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hrRunTime_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function samplesPerHour_val_Callback(hObject, eventdata, handles)
% hObject    handle to samplesPerHour_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplesPerHour_val as text
%        str2double(get(hObject,'String')) returns contents of samplesPerHour_val as a double



% --- Executes during object creation, after setting all properties.
function samplesPerHour_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplesPerHour_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
