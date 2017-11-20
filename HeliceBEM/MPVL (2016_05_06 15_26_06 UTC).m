% MPVL Version 1.0 ========== Last modified: APR/27/2007 by Hsin-Lung Chung
% =========================================================================
% Copyright 2007 Hsin-Lung Chung
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License version 2
% as published by the Free Software Foundation.
% This program is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% =========================================================================
function MPVL(action)
if nargin==0                        % nargin is "Number of Input Arguments"
   action = 'Initiate_Fig';
end
% ------------------------------------------------- Set up global variables
global Fig_Main Parametric Single Parametric_Flag Single_Flag XR0 XCHD_in XCD_in XVA_in ...
       XVT_in Text1_P Text2_P Text3_P NBLADE_in N_in D_in Input1 Hub_Flag Input1_S ...
       Input2_S Input3_S Text1_S Text2_S Text3_S f0oc_in t0oc_in skew_in rake_in ...
       Run_Parametric Run_Single Fig_P Fig1_S Fig2_S Fig3_S New_Parametric New_Single ...
       Err_Parametric Err_Single Label_Col Label_Row Welcome;
% ==================================================== INITIATE MAIN FIGURE
if strcmp(action,'Initiate_Fig')==1
    % ===================================== Declare Default Input Variables
    % Common_def: thrust,Vs,Dhub,MT,ITER,RHV,NX,HR,HT,CRP,rho
    Common_Def=[40000 5 .4 20 10 1 11 0 0 1 1025]; 
    XR0=[.2 .3 .4 .5 .6 .7 .8 .9 .95 1];                     % r/R
    XCHD_def=[.1600 .1818 .2024 .2196 .2305 .2311 .2173 .1806 .1387 .0010];  % c/D
    XCD_def=ones(length(XR0)).*.008;                         % Cd
    XVA_def=ones(length(XR0));                               % Va/Vs
    XVT_def=zeros(length(XR0));                              % Vt/Vs
    f0oc_def=[.0174 .0195 .0192 .0175 .0158 .0143 .0133 .0125 .0115 .0000]; % f0/c
    t0oc_def=[.2056 .1551 .1181 .0902 .0694 .0541 .0419 .0332 .0324 .0000]; % t0/c
    skew_def=zeros(length(XR0));                             % Skew (degrees)
    rake_def=zeros(length(XR0));                             % Rake (Xs/D)
    Parametric_def = [3 6 1 50 200 50 2 5 .5];               % Z,N,D (Min,Max,Increment)
    Single_def1=[6 200 2];                                   % NBLADE, N and D  
    Single_def2=[3 .3 1.54 20];                              % H, dV, AlphaI and NP
    % ------------------ Parameters that define the layout of UI components
    ew = .06;    eh = .04;   tw1 = .15;  tw2 = .35;   ph = .06;   X1 = .02;     X2 = .085;
    X3 = .45;    Y1 = .93;   Y2 = .7;    Y3 = .18;    Y4 = .015;  h1 = eh+.005;
    % ----------------------------------------------- Create Figure for GUI
    close all;
    Fig_Main=figure('units','normalized','position',[.02 .3 .96 .6],...
        'numbertitle','off','name','MPVL','menubar','none');
    Frame=uicontrol('parent',Fig_Main,'style','frame',...
        'units','normalized','position',[0 0 1 1]);
	% ------------------------------------------- Create UI menu components
    Menu=uimenu(Fig_Main,'label','Options');
    Parametric=uimenu(Menu,'label','Parametric Analysis','callback',...
        'MPVL(''Initiate_Parametric'')');
    Single=uimenu(Menu,'label','Single Propeller Design','callback',...
        'MPVL(''Initiate_Single'')');
    uimenu(Menu,'label','Print Screen','separator','on','callback',['printpreview']);
    uimenu(Menu,'label','Exit','separator','on','callback',['clear all; close all; clc']);
    Parametric_Flag = 0;     Single_Flag = 0;    % Flags that indicate the status of program
    % ----------------------------------------------------- Welcome message
    Welcome=uicontrol('style','text','units','normalized','FontSize',14,...
        'FontWeight','bold','position',[.2 .4 .6 .2],'string',...
        'To Start, Select an Action in the Option Menu.');
    % -------------------------------------------------- Create Text Labels
    Label1_P={'Min' 'Max' 'Increment'};
    Label2_P={'Number of blades' 'Propeller speed (RPM)' 'Propeller diameter (m)'};
    Label3_P={'Required Thrust (N)'                             % THRUST
              'Ship Velocity (m/s)'                             % V
              'Hub Diameter (m)'                                % Dhub
              'Number of Vortex Panels over the Radius'         % MT
              'Max. Iterations in Wake Alignment'               % ITER         
              'Hub Vortex Radius/Hub Radius'                    % RHV
              'Number of Input Radii'                           % NX    
              'Hub Unloading Factor: 0=Optimum'                 % HR
              'Tip Unloading Factotr: 1=Reduced Loading'        % HT     
              'Swirl Cancellation Factor: 1=No Cancellation'    % CRP
              'Water Density (kg/m^3)'};                        % rho
    Label1_S={'Number of Blades'                                % NBLADE
              'Propeller Speed (RPM)'                           % N
              'Propeller Diameter (m)'};                        % D
    Label2_S={'Shaft Centerline Depth (m)'                      % H
              'Inflow Variation (m/s)'                          % dV
              'Ideal Angle of Attack (degrees)'                 % AlphaI
              'Number of Points over the Chord'};               % NP    
    % -------------------- Create UI components for Parametric Analysis GUI
    for i=1:length(Label1_P)     
        NBLADE_in(i)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','position',[tw1+ew*(i) Y1-h1 ew eh],...
            'string',Parametric_def(i),'callback','MPVL(''Update'')','visible','off');            
        N_in(i)=uicontrol('style','edit','units','normalized','FontSize',10,'FontWeight',...
            'bold','backgroundcolor','w','string',Parametric_def(i+3),'position',...
            [tw1+ew*(i) Y1-h1*2 ew eh],'callback','MPVL(''Update'')','visible','off');            
        D_in(i)=uicontrol('style','edit','units','normalized','FontSize',10,'FontWeight',...
            'bold','backgroundcolor','w','position',[tw1+ew*(i) Y1-h1*3 ew eh],...
            'string',Parametric_def(i+6),'callback','MPVL(''Update'')','visible','off');           
        Text1_P(i)=uicontrol('style','text','units','normalized','FontSize',9,...
            'FontWeight','bold','position',[tw1+ew*(i) Y1 ew eh],'string',Label1_P(i),...
            'visible','off');
        Text2_P(i)=uicontrol('style','text','units','normalized','FontSize',10,...
            'FontWeight','bold','HorizontalAlignment','left','visible','off',...
            'position',[X1 Y1-h1*(i) tw1 eh],'string',Label2_P(i));
    end
    % -------------------------- Create UI components for Single Design GUI
    for i = 1:length(Single_def1)
        Input1_S(i)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','callback','MPVL(''Update'')',...
            'position',[X1 Y1-h1*(i-1) ew eh],'string',Single_def1(i),'visible','off');
        Text1_S(i)=uicontrol('style','text','units','normalized','FontSize',10,...
            'FontWeight','bold','HorizontalAlignment','left','position',...
            [X2 Y1-h1*(i-1) tw2 eh],'string',Label1_S(i),'visible','off');    
    end    
    for i = 1:length(Single_def2)
        Input2_S(i)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','callback','MPVL(''Update'')',...
            'position',[X1 Y3-h1*(i-1) ew eh],'string',Single_def2(i),'visible','off');
        Text2_S(i)=uicontrol('style','text','units','normalized','FontSize',10,...
            'FontWeight','bold','HorizontalAlignment','left','visible','off',...
            'position',[X2 Y3-h1*(i-1) tw2 eh],'string',Label2_S(i));    
    end
    % ------------------------------ Create UI components for Common Inputs
    for i = 1:length(Common_Def)
        Input1(i)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','callback','MPVL(''Update'')',...
            'position',[X1 Y2-h1*(i-1) ew eh],'string',Common_Def(i),'visible','off');
        Text3_P(i)=uicontrol('style','text','units','normalized','FontSize',10,...
            'FontWeight','bold','HorizontalAlignment','left','visible','off',...
            'position',[X2 Y2-h1*(i-1) tw2 eh],'string',Label3_P(i));
    end
    Hub_Flag=uicontrol('style','checkbox','units','normalized','FontSize',10,...
        'FontWeight','bold','position',[X3 Y1 tw2 eh],'value',1,'callback',...
        'MPVL(''Update'')','string','Hub Image Flag (Check for YES)','visible','off');  
    % -------------------------------------------------- Create POP-UP MENU
    Input3_S(1)=uicontrol('style','popupmenu','units','normalized','FontSize',8,...
        'FontWeight','bold','backgroundcolor','w','callback','MPVL(''Update'')','position',...
        [X3 Y1-eh*3 tw1 eh],'string',{'NACA a=0.8' 'Parabolic'},'visible','off'); 
    Text3_S(1)=uicontrol('style','text','units','normalized','FontSize',10,...
        'FontWeight','bold','HorizontalAlignment','left','position',[X3 Y1-eh*2 tw1 eh],...
        'string','Meanline Type:','visible','off');
    Input3_S(2)=uicontrol('style','popupmenu','units','normalized','FontSize',8,...
        'FontWeight','bold','backgroundcolor','w','callback','MPVL(''Update'')','position',...
        [X3+tw1+ew Y1-eh*3 tw1 eh],'string',{'NACA 65A010' 'Elliptical' 'Parabolic'},...
        'visible','off');
    Text3_S(2)=uicontrol('style','text','units','normalized','FontSize',10,'FontWeight',...
        'bold','HorizontalAlignment','left','position',[X3+tw1+ew Y1-eh*2 tw1 eh],...
        'string','Thickness Form:','visible','off');
    % ------------- Create UI components for inputs on the right of the GUI
    for j = 1:length(XR0)
        Label_Row(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','position',[X3 Y2-h1*j ew eh],'string',XR0(j),...
            'visible','off','enable','inactive');
        XCHD_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',XCHD_def(j),'position',...
            [X3+ew Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        XCD_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',XCD_def(j),'position',...
            [X3+ew*2 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        XVA_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',XVA_def(j),'position',...
            [X3+ew*3 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        XVT_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',XVT_def(j),'position',...
            [X3+ew*4 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        f0oc_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',f0oc_def(j),'position',...
            [X3+ew*5 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        t0oc_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',t0oc_def(j),'position',...
            [X3+ew*6 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        skew_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',skew_def(j),'position',...
            [X3+ew*7 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
        rake_in(j)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','backgroundcolor','w','string',rake_def(j),'position',...
            [X3+ew*8 Y2-h1*j ew eh],'callback','MPVL(''Update'')','visible','off');    
    end
    ColName={'r/R' 'c/D' 'Cd' 'Va/Vs' 'Vt/Vs' 'f0/c' 't0/c' 'Skew' 'Xs/D'};
    for i = 1:length(ColName)
        Label_Col(i)=uicontrol('style','edit','units','normalized','FontSize',10,...
            'FontWeight','bold','position',[X3+ew*(i-1) Y2 ew eh],'string',ColName(i),...
            'enable','inactive','visible','off');
    end
    % -------------------------------------------------- Create Pushbuttons    
    Run_Parametric = uicontrol('style','pushbutton','units','normalized','FontSize',10,...
        'FontWeight','bold','position',[X3 Y4 ph*2 ph],'string','Run MPVL','callback',...
        'MPVL(''Execute_Parametric'')','visible','off');
    Run_Single = uicontrol('style','pushbutton','units','normalized','FontSize',10,...
        'FontWeight','bold','position',[X3 Y4 ph*2 ph],'string','Run MPVL','callback',...
        'MPVL(''Execute_Single'')','visible','off');            
    New_Parametric = uicontrol('style','pushbutton','units','normalized','FontSize',10,...
        'FontWeight','bold','position',[X3+ph*2 Y4 ph*2 ph],'string','Try Again',...
        'callback','MPVL(''Update'')','visible','off');
    New_Single = uicontrol('style','pushbutton','units','normalized','FontSize',10,...
        'FontWeight','bold','position',[X3+ph*2 Y4 ph*2 ph],'string','Try Again',...
        'callback','MPVL(''Update'')','visible','off');
    Err_Parametric = uicontrol('style','pushbutton','units','normalized','FontSize',8,...
        'Fontweight','bold','position',[X3+ph*4 Y4 ph*3 ph],'Foregroundcolor','r',...
        'callback','MPVL(''Update'')','visible','off');
    Err_Single = uicontrol('style','pushbutton','units','normalized','FontSize',8,...
        'Fontweight','bold','position',[X3+ph*4 Y4 ph*3 ph],'Foregroundcolor','r',...
        'callback','MPVL(''Update'')','visible','off');
% ======================================== INITIATE PARAMETRIC ANALYSIS GUI
elseif strcmp(action,'Initiate_Parametric')==1
    set(Welcome,'visible','off');               set(Parametric,'enable','off');
    set(Single,'enable','on');                  Parametric_Flag = 1;                        
    if Single_Flag ==1          % If Single Design GUI is already launched
        set(Input1_S,'visible','off');          set(Text1_S,'visible','off');    
        set(Input2_S,'visible','off');          set(Text2_S,'visible','off');        
        set(Input3_S,'visible','off');          set(Text3_S,'visible','off');  
        set(f0oc_in,'visible','off');           set(t0oc_in,'visible','off');
        set(skew_in,'visible','off');           set(rake_in,'visible','off');
        set(Run_Single,'visible','off');        set(New_Single,'visible','off');
        set(Err_Single,'visible','off');
    end
    set(Text1_P,'visible','on');                
    set(Text2_P,'visible','on');
    set(NBLADE_in,'enable','on','visible','on');
    set(NBLADE_in(3),'Enable','off');
    set(N_in,'enable','on','visible','on');    
    set(D_in,'enable','on','visible','on');     
    set(Input1,'enable','on','visible','on');   
    set(Text3_P,'visible','on');
    set(Hub_Flag,'enable','on','visible','on');
    set(Label_Col(1:5),'visible','on');         
    set(Label_Col(6:9),'visible','off');
    set(Label_Row,'visible','on');              
    set(XCHD_in,'enable','on','visible','on');             
    set(XCD_in,'enable','on','visible','on');              
    set(XVA_in,'enable','on','visible','on');              
    set(XVT_in,'enable','on','visible','on');              
    set(Run_Parametric,'enable','on','visible','on');
    Single_Flag = 0;
% ==================================================== UPDATE INPUTS FIELDS
elseif strcmp(action,'Update')==1
    % ------------------------------------------ Update Common Input Fields
    set(Input1,'enable','on');                  set(Hub_Flag,'enable','on'); 
    set(XCHD_in,'enable','on');                 set(XCD_in,'enable','on'); 
    set(XVA_in,'enable','on');                  set(XVT_in,'enable','on');
    get(Input1,'string');                       get(Hub_Flag,'value');  
    get(XCHD_in,'string');                      get(XCD_in,'string');       
    get(XVA_in,'string');                       get(XVT_in,'string');   
    % -------------------------------------- Update Respective Input Fields
    if Parametric_Flag==1       
        set(NBLADE_in(1:2),'enable','on');      set(N_in,'enable','on');   
        set(D_in,'enable','on');                set(Run_Parametric,'enable','on');    
        set(New_Parametric,'visible','off');    set(Err_Parametric,'visible','off');
        get(NBLADE_in,'string');                get(N_in,'string');       
        get(D_in,'string');
    elseif Single_Flag==1
        set(Run_Single,'enable','on');          set(Input1_S,'enable','on');       
        set(Input2_S,'enable','on');            set(Input3_S,'enable','on');       
        set(f0oc_in,'enable','on');             set(t0oc_in,'enable','on');        
        set(skew_in,'enable','on');             set(rake_in,'enable','on');        
        set(New_Single,'visible','off');        set(Err_Single,'visible','off');
        get(Input1_S,'string');                 get(Input2_S,'string');   
        get(Input3_S,'string');                 get(f0oc_in,'string');              
        get(t0oc_in,'string');                  get(skew_in,'string');   
        get(rake_in,'string');                   
    end
% =================================== PERFORM PARAMETRIC ANALYSIS ALGORITHM
elseif strcmp(action,'Execute_Parametric')==1    
    tic;      % start stopwatch
    % ------- Disable components to prevent intervention during calculation
    set(NBLADE_in,'enable','off');              set(N_in,'enable','off');
    set(D_in,'enable','off');                   set(Input1,'enable','off');       
    set(Hub_Flag,'enable','off');               set(XCHD_in,'enable','off');      
    set(XCD_in,'enable','off');                 set(XVA_in,'enable','off');       
    set(XVT_in,'enable','off');                 set(Run_Parametric,'enable','off');
    set(New_Parametric,'visible','on','enable','on');
    % ------------------------------------ Close figures previously created
    if ishandle(Fig_P)~=0
        close(Fig_P);
    end
    if ishandle(Fig1_S)~=0 
       close(Fig1_S); 
    end
    if ishandle(Fig2_S)~=0 
       close(Fig2_S); 
    end
    if ishandle(Fig3_S)~=0 
        close(Fig3_S); 
    end    
    % ---------------------------------------------------- Define Variables
    NBLADE=str2double(get(NBLADE_in(1),'string')):1:str2double(get(NBLADE_in(2),'string'));
    N=str2double(get(N_in(1),'string')):str2double(get(N_in(3),'string')):...
        str2double(get(N_in(2),'string'));
    D=str2double(get(D_in(1),'string')):str2double(get(D_in(3),'string')):...
        str2double(get(D_in(2),'string'));
    % ----------------------------- Set constraints on propeller parameters
    if (max(NBLADE>6)) || (min(NBLADE)<2)
        set(Err_Parametric,'visible','on','enable','on','string','2<=Number of Blades=<6');
        set(New_Parametric,'enable','off');         beep;           return;
    elseif (str2double(get(N_in(1),'string'))>str2double(get(N_in(2),'string')))
        set(Err_Parametric,'visible','on','enable','on','string','Check Propeller Speed');
        set(New_Parametric,'enable','off');         beep;           return;
    elseif (str2double(get(D_in(1),'string'))>str2double(get(D_in(2),'string')))
        set(Err_Parametric,'visible','on','enable','on','string','Check Propeller Diameter');
        set(New_Parametric,'enable','off');         beep;           return;
    end
    % ------------------------------ Derive Common Input Fields in a String
    string = str2double(get(Input1,'string')); 
    THRUST = string(1);         V = string(2);              Dhub = string(3); 
    MT = string(4);             ITER = string(5);           RHV = string(6);    
    NX = string(7);             HR = string(8);             HT = string(9); 
    CRP = string(10);           rho = string(11);           Rhub = Dhub/2;              
    IHUB = get(Hub_Flag,'value');
    XCHD0 = str2double(get(XCHD_in,'string'));
    XCD0 = str2double(get(XCD_in,'string'));
    XVA0 = str2double(get(XVA_in,'string'));
    XVT0 = str2double(get(XVT_in,'string'));
    %---------------------------------------------------- Perform Algorithm
    for k=1:length(NBLADE)
        for i=1:length(N)
            n(i) = N(i)/60;
            for j=1:length(D)
                R(j) = D(j)/2;       
                ADVCO = V/(n(i)*D(j));
                CTDES = THRUST/(rho*V^2*pi*R(j)^2/2);
                XR1 = Rhub/R(j):(1-Rhub/R(j))/(NX-3):1;
                half1 = (XR1(1)+XR1(2))/2;                 
                half2 = (XR1(NX-3)+XR1(NX-2))/2;
                XR = cat(2,XR1(1), half1, XR1(2:NX-3), half2, XR1(NX-2));
                XCHD = pchip(XR0,XCHD0,XR);         
                XCD = pchip(XR0,XCD0,XR);
                XVA = pchip(XR0,XVA0,XR);           
                XVT = pchip(XR0,XVT0,XR);
                % ====================================== Call Main Function
                [CT,CP,KT,KQ,WAKE,EFFY0,RC,G,VAC,VTC,UASTAR,UTSTAR,TANBC,TANBIC,CDC,CD,KTRY]...
                =Main(MT,ITER,IHUB,RHV,NX,NBLADE(k),ADVCO,CTDES,HR,HT,CRP,XR,XCHD,XCD,XVA,XVT);
                % =========================================================
                EFFY(i,j,k) = EFFY0(end);
            end
        end
    end
    Fig_P=figure('units','normalized','position',[0.01 .06 .4 .3],'name','Efficiency',...
        'numbertitle','off');
    for i = 1:length(NBLADE)
        if length(NBLADE)==4
           subplot(2,2,i);
        else
           subplot(length(NBLADE),1,i);
        end
        plot(D,EFFY(:,:,i));
        str_suffix={' RPM'};
        for j=1:length(N)
            str_legend(j)=strcat(num2str(N(j)),str_suffix);
        end
        legend(str_legend,'location','southwest');          grid on;
        xlabel('Propeller Diameter (m)');                   ylabel('Efficiency');
        title_prefix = {'Number of Blades: '};  
        title(strcat(title_prefix,num2str(NBLADE(i))))
    end
    set(New_Parametric,'enable','on');    
    figure(Fig_Main);                               
    toc     % Stop stopwatch
% ============================================== INITIATE SINGLE DESIGN GUI
elseif strcmp(action,'Initiate_Single')==1
    set(Welcome,'visible','off');                   set(Parametric,'enable','on');       
    set(Single,'enable','off');                     Single_Flag = 1;                        
    if Parametric_Flag ==1  % If Parametric Analysis GUI is already launched
        set(Text1_P,'visible','off');               set(Text2_P,'visible','off');
        set(NBLADE_in,'visible','off');             set(N_in,'visible','off');    
        set(D_in,'visible','off');                  set(Run_Parametric,'visible','off');
        set(New_Parametric,'visible','off');        set(Err_Parametric,'visible','off');
    end
    set(Input1_S,'visible','on','enable','on');     set(Text1_S,'visible','on');    
    set(Input1,'visible','on','enable','on');       set(Text3_P,'visible','on');        
    set(Input2_S,'visible','on','enable','on');     set(Text2_S,'visible','on');        
    set(Hub_Flag,'visible','on','enable','on');     
    set(Input3_S,'visible','on','enable','on');     set(Text3_S,'visible','on');  
    set(Label_Col,'visible','on');                  set(Label_Row,'visible','on');  
    set(XCHD_in,'visible','on','enable','on');      set(XCD_in,'visible','on','enable','on');
    set(XVA_in,'visible','on','enable','on');       set(XVT_in,'visible','on','enable','on');
    set(f0oc_in,'visible','on','enable','on');      set(t0oc_in,'visible','on','enable','on');
    set(skew_in,'visible','on','enable','on');      set(rake_in,'visible','on','enable','on');
    set(Run_Single,'visible','on','enable','on');   Parametric_Flag = 0;
% ========================================= PERFORM SINGLE DESIGN ALGORITHM
elseif strcmp(action,'Execute_Single')==1   
    tic;        % start stopwatch
    set(Run_Single,'enable','off');                 set(Input1,'enable','off');    
    set(Input1_S,'enable','off');                   set(Input2_S,'enable','off');
    set(Input3_S,'enable','off');                   set(Hub_Flag,'enable','off');          
    set(XCHD_in,'enable','off');                    set(XCD_in,'enable','off');            
    set(XVA_in,'enable','off');                     set(XVT_in,'enable','off');            
    set(f0oc_in,'enable','off');                    set(t0oc_in,'enable','off');           
    set(skew_in,'enable','off');                    set(rake_in,'enable','off');    
    % ------------------------------------ Close figures previously created 
    if ishandle(Fig_P)~=0
        close(Fig_P);
    end
    if ishandle(Fig1_S)~=0 
       close(Fig1_S); 
    end
    if ishandle(Fig2_S)~=0   
       close(Fig2_S); 
    end
    if ishandle(Fig3_S)~=0   
        close(Fig3_S); 
    end    
    % ------------------------------------------------- Derive Input Fields
    string1 = str2double(get(Input1_S,'string'));
    string2 = str2double(get(Input1,'string'));
    string3 = str2double(get(Input2_S,'string'));    
    NBLADE = string1(1);        N = string1(2);             D = string1(3); 
    THRUST = string2(1);        V = string2(2);             Dhub = string2(3); 
    MT = string2(4);            ITER = string2(5);          RHV = string2(6);    
    NX = string2(7);            HR = string2(8);            HT = string2(9);    
    CRP = string2(10);          rho = string2(11);
    H = string3(1);             dV = string3(2);            
    AlphaI = string3(3);        NP = string3(4);     
    R = D/2;                    Rhub = Dhub/2;              n = N/60;
    ADVCO = V/(n*D);            CTDES = THRUST/(rho*V^2*pi*R^2/2);
    IHUB = get(Hub_Flag,'Value');
    Meanline = get(Input3_S(1),'Value');        
    Thickness = get(Input3_S(2),'Value');
    XCHD0 = str2double(get(XCHD_in,'String'));  
    XCD0 = str2double(get(XCD_in,'String'));
    XVA0 = str2double(get(XVA_in,'String'));    
    XVT0 = str2double(get(XVT_in,'String'));
    f0oc0 = str2double(get(f0oc_in,'String'));  
    t0oc0 = str2double(get(t0oc_in,'String'));
    skew0 = str2double(get(skew_in,'String'));  
    rake0 = str2double(get(rake_in,'String'));
    if Dhub/D < .15      % Warn if hub diameter is too small
        set(Err_Single,'visible','on','enable','on','string','Dhub/D >= 15%');
        return;
    end
    % ------------------------------------------------- Make MPVL_Input.txt
    XR1 = Rhub/R:(1-Rhub/R)/(NX-3):1;
    half1 = (XR1(1)+XR1(2))/2;                  
    half2 = (XR1(NX-3)+XR1(NX-2))/2;
    XR = [XR1(1) half1 XR1(2:NX-3) half2 XR1(NX-2)];
    XCHD = pchip(XR0,XCHD0,XR);                 
    XCD = pchip(XR0,XCD0,XR);
    XVA = pchip(XR0,XVA0,XR);                   
    XVT = pchip(XR0,XVT0,XR);
    Flag1 = datestr(now,31);              
    fid = fopen('MPVL_Input.txt','w'); 
    fprintf(fid,'%s\tMPVL_Input.txt\n',Flag1);
    fprintf(fid,'%.0f \t\tNumber of Vortex Panels over the Radius\n',MT);
    fprintf(fid,'%.0f \t\tMax. Iterations in Wake Alignment\n',ITER);
    fprintf(fid,'%.0f \t\tHub Image Flag: 1=YES, 0=NO\n',IHUB);
    fprintf(fid,'%.1f \tHub Vortex Radius/Hub Radius\n',RHV);
    fprintf(fid,'%.0f \t\tNumber of Input Radii\n',NX);
    fprintf(fid,'%.0f \t\tNumber of Blades\n',NBLADE);
    fprintf(fid,'%.3f \tAdvance Coef., J, Based on Ship Speed\n',ADVCO);
    fprintf(fid,'%.3f \tDesired Thrust Coef., Ct\n',CTDES);
    fprintf(fid,'%.0f \t\tHub Unloading Factor: 0=optimum\n',HR);
    fprintf(fid,'%.0f \t\tTip Unloading Factor: 1=Reduced Loading\n',HT);
    fprintf(fid,'%.0f \t\tSwirl Cencellation Factor: 1=No Cancellation\n',CRP);
    fprintf(fid,'r/R  \t  C/D  \t   XCD\t    Va/Vs  Vt/Vs\n');
    for i = 1:NX
        fprintf(fid,'%6.5f  %6.5f  %6.5f  %6.2f  %6.4f\n',XR(i),XCHD(i),XCD(i),XVA(i),XVT(i));
    end
    fclose(fid);
    % ================================================== Call Main Function
    [CT,CP,KT,KQ,WAKE,EFFY,RC,G,VAC,VTC,UASTAR,UTSTAR,TANBC,TANBIC,CDC,CD,KTRY]...
        =Main(MT,ITER,IHUB,RHV,NX,NBLADE,ADVCO,CTDES,HR,HT,CRP,XR,XCHD,XCD,XVA,XVT);
    % -------------------------------------------- Create Graphical Reports
    Fig1_S = figure('units','normalized','position',[.01 .06 .4 .3],'name',...
        'Graphical Report','numbertitle','off');
    subplot(2,2,1);         
    plot(RC,G);                                 
    xlabel('r/R');          ylabel('Non-Dimensional Circulation');      grid on;
    TitleString=strcat('J=',num2str(ADVCO,'%10.3f'),'; Ct=',num2str(CT(KTRY),'%10.3f'),...
        '; Kt=',num2str(KT(KTRY),'%10.3f'),'; Kq=',num2str(KQ(KTRY),'%10.3f'),...
        '; \eta=',num2str(EFFY(KTRY),'%10.3f'));
    title(TitleString);    
    subplot(2,2,2);         
    plot(RC,VAC,'-b',RC,VTC,'--b',RC,UASTAR,'-.r',RC,UTSTAR,':r');    
    xlabel('r/R');          legend('Va/Vs','Vt/Vs','Ua*/Vs','Ut*/Vs');  grid on;
    subplot(2,2,3);         
    plot(RC,TANBC,'--b',RC,TANBIC,'-r');                   
    xlabel('r/R');          ylabel('Degrees');      grid on;        legend('Beta','BetaI');
    subplot(2,2,4);         
    plot(RC,CDC);                               
    xlabel('r/R');          ylabel('c/D');          grid on;
    % ----------------------------------- Propeller Performance Calculation
    w = 2*pi*n;         % Angular velocity w
    for k = 1:MT
        Vstar(k) = sqrt((VAC(k)+UASTAR(k))^2 + (w*R*RC(k)+VTC(k)+UTSTAR(k))^2);
        Gamma(k) = G(k)*2*pi*R*V;
        Cl(k) = 2*Gamma(k) / (Vstar(k)*CDC(k)*D);
        dBetai(k) = atand((tand(TANBIC(k))*w*RC(k)*R+dV)/(w*RC(k)*R))...
                   -atand((tand(TANBIC(k))*w*RC(k)*R-dV)/(w*RC(k)*R));
        Sigma(k) = (101000+rho*9.81*(H-RC(k)*R)-2500)/(rho*Vstar(k)^2/2); %Cavitation Number
    end
    f0oc = pchip(XR0,f0oc0,RC).*Cl;     % Scale camber ratio with lift coefficient     
    t0oc = pchip(XR0,t0oc0,RC);     
    fid = fopen('Performance.txt','w'); 
    fprintf(fid,'\t\t\t\t\t\tPerformance.txt\n');
    fprintf(fid,'\t\t\t\t\tPropeller Performance Table\n');
    fprintf(fid,' r/R\t\tV*\t beta\t betai\t  Gamma\t\tCl\t Sigma\tdBetai\n');
    for k = 1:MT
        fprintf(fid,'%.3f\t %.3f\t %.2f\t %.2f\t %.4f\t %.3f\t %.3f\t %.2f\n'...
        ,RC(k),Vstar(k),TANBC(k),TANBIC(k),Gamma(k),Cl(k),Sigma(k),dBetai(k));
    end
    fclose(fid);        
    % ------------------------------------------------ Geometry Calculation
    skew = pchip(XR0,skew0,RC);                
    rake = pchip(XR0,rake0,RC);
    fid = fopen('Geometry.txt','w'); 
    fprintf(fid,'\t\t\tGeometry.txt\n');
    fprintf(fid,'\t\tPropeller Geometry Table\n\n');    
    fprintf(fid,'Propeller Diameter = %.1f m\n',D);
    fprintf(fid,'Number of Blades = %.0f\n',NBLADE);
    fprintf(fid,'Propeller Speed= %.0f RPM\n',N);
    fprintf(fid,'Propeller Hub Diameter = %.2f m\n',Dhub);
    if Meanline==1
        fprintf(fid,'Meanline Type: NACA a=0.8\n');
    elseif Meanline==2
        fprintf(fid,'Meanline Type: Parabolic\n');
    end
    if Thickness==1
        fprintf(fid,'Thickness Type: NACA 65A010\n\n');
    elseif Thickness==2
        fprintf(fid,'Thickness Type: Elliptical\n\n');
    elseif Thickness==3
        fprintf(fid,'Thickness Type: Parabolic\n\n');
    end
    fprintf(fid,' r/R\t P/D\t Skew\t Xs/D\t  c/D\t  f0/c\t  t0/c\n');
    for i = 1:MT
        ThetaP(i) = TANBIC(i) + AlphaI;                 % Pitch angle
        PitchOD(i) = tand(ThetaP(i))*pi*RC(i);          % P/D
        fprintf(fid, '%.3f\t %.2f\t %.1f\t %.3f\t %.3f\t %.4f\t %.4f\n'...
        ,RC(i),PitchOD(i),skew(i),rake(i),CDC(i),f0oc(i),t0oc(i));
    end
    fclose(fid);
    % --------------------------------------------------------- BASIC SHAPE
    c = CDC.*D;                             
    r = RC.*R;
    theta = 0:360/NBLADE:360;   % Angles between blades
    for i = 1:MT
        for j = 1:NP
            x1(i,j) = c(i)/2-c(i)/(NP-1)*(j-1); 
            station(1,j) = 1/(NP-1)*(j-1);              % For NACA foil
            z1(i,j,1) = sqrt(r(i)^2-x1(i,j)^2);
        end
    end
% ---------------------------------------------------- MEANLINE & THICKNESS
    x = [0 .5 .75 1.25 2.5 5 7.5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 ...
         80 85 90 95 100]./100;
    if Meanline==1          % NACA a=0.8 meanline is chosen
        foc = [0 .287 .404 .616 1.077 1.841 2.483 3.043 3.985 4.748 5.367 5.863 6.248...
            6.528 6.709 6.79 6.77 6.644 6.405 6.037 5.514 4.771 3.683 2.435 1.163 0]./100;
        fscale = f0oc./max(foc);        % Scale for camber
        dfdx0 = [.48535 .44925 .40359 .34104 .27718 .23868 .21050 .16892...
            .13734 .11101 .08775 .06634 .04601 .02613 .00620 -.01433 -.03611...
            -.06010 -.08790 -.12311 -.18412 -.23921 -.25583 -.24904 -.20385];
        for i = 1:MT
            for j = 1:NP
                f(i,:) = pchip(x,foc.*fscale(i).*c(i),station);
                dfdx(i,:) = pchip(x(2:end),dfdx0,station);
            end
        end
    elseif Meanline==2      % Parabolic meanline is chosen
        for i = 1:MT
            for j = 1:NP
                f(i,j) = f0oc(i)*c(i)*(1-(2*x1(i,j)/c(i))^2);
                dfdx(i,j) = -8*f0oc(i)*x1(i,j)/c(i);
            end
        end
    end
    if Thickness==1         % NACA 65A010 thickness form is chosen
        toc_65 = [0 .765 .928 1.183 1.623 2.182 2.65 3.04 3.658 4.127 4.483 4.742 4.912...
            4.995 4.983 4.863 4.632 4.304 3.899 3.432 2.912 2.352 1.771 1.188 .604 .021]./100;
        tscale = t0oc./2./max(toc_65);     % Scale for thickness
        for i = 1:MT
            for j = 1:NP
                t(i,:) = pchip(x,toc_65.*tscale(i).*c(i),station);
            end
        end
    elseif Thickness==2     % Elliptical thickness form is chosen
        for i = 1:MT
            for j = 1:NP
                t(i,j) = t0oc(i)*c(i)*real(sqrt(1-(2*x1(i,j)/c(i))^2));
            end
        end
    elseif Thickness==3     % Parabolic thickness form is chosen
        for i = 1:MT
            for j = 1:NP
                t(i,j) = t0oc(i)*c(i)*(1-(2*x1(i,j)/c(i))^2);
            end
        end
    end
    % -------------------------------------------------- CAMBER & THICKNESS
    for i = 1:MT
        for j = 1:NP
            xu(i,j) = x1(i,j)+t(i,j)*sin(atan(dfdx(i,j)));
            xl(i,j) = x1(i,j)-t(i,j)*sin(atan(dfdx(i,j)));        
            yu(i,j) = f(i,j)+t(i,j)*cos(atan(dfdx(i,j)));
            yl(i,j) = f(i,j)-t(i,j)*cos(atan(dfdx(i,j)));        
            if (isreal(yu(i,j))==0)||(isreal(yl(i,j))==0)
                if Single_Flag==1
                    set(Err_Single,'visible','on','enable','on','string','Error in MPVL.');
                    if ishandle(Fig1_S)~=0
                        close(Fig1_S);
                    end
                    return;
                end
            end
        end
    end
    % -------------------------------------------------- PITCH, SKEW & RAKE
    yrake = rake.*D;  % Rake: translation in y direction
    for i = 1:MT
        for j = 1:NP
            xup(i,j,1)=xu(i,j)*cosd(ThetaP(i))-yu(i,j)*sind(ThetaP(i));
            xlp(i,j,1)=xl(i,j)*cosd(ThetaP(i))-yl(i,j)*sind(ThetaP(i));            
            yup(i,j,1)=xu(i,j)*sind(ThetaP(i))+yu(i,j)*cosd(ThetaP(i));
            ylp(i,j,1)=xl(i,j)*sind(ThetaP(i))+yl(i,j)*cosd(ThetaP(i)); 
            z1p(i,j,1)=z1(i,j);
            xus(i,j,1)=xup(i,j)*cosd(skew(i))-z1p(i,j)*sind(skew(i));
            xls(i,j,1)=xlp(i,j)*cosd(skew(i))-z1p(i,j)*sind(skew(i));            
            yus(i,j,1)=yup(i,j);
            yls(i,j,1)=ylp(i,j); 
            z1s(i,j,1)=x1(i,j)*sind(skew(i))+z1p(i,j)*cosd(skew(i));    
            xur(i,j,1)=xus(i,j);
            xlr(i,j,1)=xls(i,j);            
            yur(i,j,1)=yus(i,j)-yrake(i);
            ylr(i,j,1)=yls(i,j)-yrake(i); 
            z1r(i,j,1)=z1s(i,j,1);    
            for k = 2:length(theta)-1
                xur(i,j,k) = xur(i,j,1)*cosd(theta(k))-z1r(i,j,1)*sind(theta(k));
                xlr(i,j,k) = xlr(i,j,1)*cosd(theta(k))-z1r(i,j,1)*sind(theta(k));            
                yur(i,j,k) = yur(i,j,1);
                ylr(i,j,k) = ylr(i,j,1);            
                z1r(i,j,k) = xur(i,j,1)*sind(theta(k))+z1r(i,j,1)*cosd(theta(k));    
            end
        end
    end
    % -------------------------- Create Figure for 2D Propeller Blade Image
    Fig2_S = figure('units','normalized','position',[0.31 .06 .4 .3],'name',...
        'Blade Image','numbertitle','off');
    style=['r' 'g' 'b' 'm' 'k'];
    str_prefix = {'r/R = '};
    flag=1;
    for i = 1:ceil(MT/5):MT
        plot(xur(i,:,1),yur(i,:,1),style(flag));
        str_legend(flag)=strcat(str_prefix,num2str(RC(i)));  
        hold on;
        flag = flag+1;
    end
    flag=1;
    for i = 1:ceil(MT/5):MT
        plot(xlr(i,:,1),ylr(i,:,1),style(flag));
        hold on;
        flag = flag+1;
    end
    legend(str_legend,'location','northwest');
    axis equal;     grid on;    xlabel('X (m)');    ylabel('Y (m)');    hold off;
    % ------------------------------------------- Create 3D Propeller Image
    Fig3_S = figure('units','normalized','position',[.61 .06 .4 .3],...
           'name','Propeller Image','numbertitle','off');
    for k = 1:NBLADE
        surf(xur(:,:,k),yur(:,:,k),z1r(:,:,k));         hold on;
        surf(xlr(:,:,k),ylr(:,:,k),z1r(:,:,k));         hold on;
    end
    tick = 0:15:90;
    [xh0,yh0,zh0] = cylinder(Rhub*sind(tick),50);   
    surf(yh0,zh0.*.3+min(ylp(1,:,1))-.3,xh0);
    [xh1,yh1,zh1] = cylinder(Rhub,50);              
    surf(yh1, zh1+min(ylp(1,:,1)), xh1);    
    hold off;       colormap gray;          grid on;        axis equal;
    xlabel('X');    ylabel('Y');            zlabel('Z');  
    set(New_Single,'visible','on','enable','on');
    figure(Fig_Main);       
    toc
end     % =================================================== Do not delete
% ====================================================== Main Function Code
function [CT,CP,KT,KQ,WAKE,EFFY,RC,G,VAC,VTC,UASTAR,UTSTAR,TANBC,TANBIC,CDC,CD,KTRY]=...
    Main(MT,ITER,IHUB,RHV,NX,NBLADE,ADVCO,CTDES,HR,HT,CRP,XR,XCHD,XCD,XVA,XVT)
    global Parametric_Flag Single_Flag
    % ---------------------------------------------- FORTRAN Function VOLWK
    YW = XR.*XVA;
    YDX = trapz(XR,YW);
    WAKE = 2*YDX/(1-XR(1)^2);
    % -------------------------------------------------------- End of VOLWK
    XRC = 1-sqrt(1-XR);         
    DEL = pi/(2*MT);            % Compute cosine spaced vortex radii
    HRR = 0.5*(XR(NX)-XR(1));
    for i=1:MT+1
        RV(i) = XR(1)+HRR*(1-cos(2*(i-1)*DEL)); 
    end
    VAV = pchip(XR,XVA,RV);
    VTV = pchip(XR,XVT,RV);
    TANBV = VAV./((pi.*RV./ADVCO)+VTV);
    VBAV = VTV.*TANBV./VAV;
    % Cosine spaced control point radii: Evaluate c/D,Va,Vt,tanB,Cd,Vt*,tanB/Va
    for i=1:MT      
        RC(i) = XR(1)+HRR*(1-cos((2*i-1)*DEL));
        RCWG(i) = 1-sqrt(1-RC(i));
    end
    CDC = pchip(XRC,XCHD,RCWG);
    CD = pchip(XR,XCD,RC);
    VAC = pchip(XR,XVA,RC);
    VTC = pchip(XR,XVT,RC);
    TANBC = VAC./(pi.*RC./ADVCO+VTC);
    VBAC = VTC.*TANBC./VAC;
    % First estimation of tanBi based on 90% of actuator disk efficiency
    EDISK = 1.8/(1+sqrt(1+CTDES/WAKE^2));
    TANBXV = TANBV.*sqrt(WAKE./(VAV-VBAV))/EDISK;
    TANBXC = TANBC.*sqrt(WAKE./(VAC-VBAC))/EDISK;
    % Unload hub and tip as specified by HR and HT
    RM = (XR(1)+XR(NX))/2;  
    for i=1:MT+1
        if RV(i)<RM
            HRF=HR;
        else 
            HRF=HT;
        end
        DTANB = HRF*(TANBXV(i)-TANBV(i))*((RV(i)-RM)/(XR(1)-RM))^2;
        TANBXV(i) = TANBXV(i)-DTANB;
    end
    for i=1:MT
        if RC(i)<RM
            HRF=HR;
        else 
            HRF=HT;
        end
        DTANB = HRF*(TANBXC(i)-TANBC(i))*((RC(i)-RM)/(XR(1)-RM))^2;
        TANBXC(i) = TANBXC(i)-DTANB;
    end
    % Iterations to scale tanBi to get desired value of thrust coefficient
    for KTRY=1:ITER     
        if KTRY==1
            T(KTRY) = 1;
        elseif KTRY==2
            T(KTRY) = 1+(CTDES-CT(1))/(5*CTDES);
        elseif KTRY>2
            if CT(KTRY-1)-CT(KTRY-2)==0
                break
            else
                T(KTRY)=T(KTRY-1)+(T(KTRY-1)-T(KTRY-2))*(CTDES-CT(KTRY-1))/...
                    (CT(KTRY-1)-CT(KTRY-2));
            end
        end
        TANBIV = T(KTRY).*TANBXV;                
        TANBIC = T(KTRY).*TANBXC;
        % Compute axial and tangential horseshoe influence coefficients
        for i=1:MT      
            RCW = RC(i);
            for j = 1:MT+1
                RVW = RV(j);
                TANBIW = TANBIV(j);     % induction of trailing vortices shed at RV(N)
                [UAIF,UTIF]=WRENCH(NBLADE,TANBIW,RCW,RVW);
                if (isnan(UAIF)==1)||(isnan(UTIF)==1)
                    if Single_Flag==1
                       set(Err_Single,'visible','on','enable','on','string','Error in MPVL.'); 
                    end
                    return;
                end
                UAW(j) = -UAIF/(2*(RC(i)-RV(j)));
                UTIF = UTIF*CRP;
                UTW(j) = UTIF/(2*(RC(i)-RV(j)));
                % Induction of corresponding hub-image trailing vorticies
                if IHUB==1      
                    RVW = XR(1)^2/RV(j);
                    TANBIW = TANBIV(1)*RV(1)/RVW;
                    [UAIF,UTIF]=WRENCH(NBLADE,TANBIW,RCW,RVW);
                    if (isnan(UAIF)==1)||(isnan(UTIF)==1)
                        if Single_Flag==1
                           set(Err_Single,'visible','on','enable','on',...
                               'string','Error in MPVL.');
                        end
                        return;
                    end
                    UAW(j) = UAW(j)+UAIF/(2*(RC(i)-RVW));
                    UTIF = UTIF*CRP;
                    UTW(j) = UTW(j)-UTIF/(2*(RC(i)-RVW));
                end
            end
            % Final step in building influence functions
            for k=1:MT  
                UAHIF(i,k) = UAW(k+1)-UAW(k);            
                UTHIF(i,k) = UTW(k+1)-UTW(k);
            end
        end
        % Solve simutaneous equations for circulation strengths G(i)
        for m=1:MT  
            B(m) = VAC(m)*((TANBIC(m)/TANBC(m))-1);
            for n=1:MT
                A(m,n) = UAHIF(m,n)-UTHIF(m,n)*TANBIC(m); 
            end
        end
        % ======================================= FORTRAN Subroutine SIMEQN    
        NEQ = length(B);
        IERR = 1;
        % Find |maximum| element in each row and exit if a zero row is detected
        for i=1:NEQ
            IPIVOT(i) = i;
            ROWMAX = 0;
            for j=1:NEQ
                ROWMAX = max(ROWMAX, abs(A(i,j))); 
            end
            if ROWMAX==0
                fprintf('Matrix is Singular-1.\n')
                G = NaN;    % Must return something to avoid error warning
                if Single_Flag==1
                    set(Err_Single,'visible','on','enable','on','string','Error in MPVL.');
                end
                return;
            end
            D(i) = ROWMAX;       
        end
        NM1=NEQ-1;
        if NM1>0        % Otherwise special case of one equation
            for k=1:NM1
                j = k;
                KP1 = k+1;
                IP = IPIVOT(k);
                COLMAX = abs(A(IP,k))/D(IP);
                for i=KP1:NEQ
                    IP = IPIVOT(i);
                    AWIKOV = abs(A(IP,k))/D(IP);
                    if AWIKOV>COLMAX
                        COLMAX = AWIKOV;
                        j=i;
                    end
                end
                if COLMAX==0
                    fprintf('Matrix is Singular-2.\n')
                    G = NaN;   % Must return something to avoid error warning
                    if Single_Flag==1
                        set(Err_Single,'visible','on','enable','on','string','Error in MPVL.');
                    end
                    return;
                end
                IPK = IPIVOT(j);
                IPIVOT(j) = IPIVOT(k);
                IPIVOT(k) = IPK;
                for i=KP1:NEQ
                    IP = IPIVOT(i);
                    A(IP,k) = A(IP,k)/A(IPK,k);
                    RATIO = -A(IP,k);
                    for j=KP1:NEQ
                        A(IP,j) = RATIO*A(IPK,j)+A(IP,j); 
                    end
                end
            end
            if A(IP,NEQ)==0
                fprintf('Matrix is Singular-3.\n')
                G = NaN;  % Must return something to avoid error warning
                if Single_Flag==1
                    set(Err_Single,'visible','on','enable','on','string','Error in MPVL.');
                end                
                return;
            end
        end
        IERR = 0;       % Matrix survived singular test
        if NEQ==1       % Back substitute to obtain solution (G)
            G(1) = B(1)/A(1,1);
        else
            IP = IPIVOT(1);
            G(1) = B(IP);
            for k=2:NEQ
                IP = IPIVOT(k);
                KM1 = k-1;
                SUMM = 0;
                for j=1:KM1
                    SUMM = A(IP,j)*G(j)+SUMM; 
                end
                G(k) = B(IP)-SUMM;
            end
            G(NEQ) = G(NEQ)/A(IP,NEQ);
            k = NEQ;
            for NP1MK=2:NEQ
                KP1 = k;
                k = k-1;
                IP = IPIVOT(k);
                SUMM = 0;
                for j=KP1:NEQ
                    SUMM = A(IP,j)*G(j)+SUMM; 
                end
                G(k) = (G(k)-SUMM)/A(IP,k);
            end
        end
        % =================================================== End of SIMEQN    
        if IERR==1  % Matrix is singular
            if Single_Flag==1
                set(Err_Single,'visible','on','enable','on','string','Error in MPVL.');
            end
            return;
        end
        % Evalutate the induced velocities from the circulation G(i)
        for p=1:MT      
            UASTAR(p) = 0;                      
            UTSTAR(p) = 0;
            for q=1:MT
               UASTAR(p) = UASTAR(p)+G(q)*UAHIF(p,q);
               UTSTAR(p) = UTSTAR(p)+G(q)*UTHIF(p,q);
            end
        end
        % ======================================= FORTRAN Subroutine FORCES
        LD = 0;     % Default: Input is Cd, not L/D
        if CD>1
            LD = 1;  % CD> 1 means the input is L/D
        end
        CT(KTRY) = 0;
        CQ(KTRY) = 0;
        for m=1:MT
            DR = RV(m+1)-RV(m);
            VTSTAR = VAC(m)/TANBC(m)+UTSTAR(m);
            VASTAR = VAC(m)+UASTAR(m);
            VSTAR = sqrt(VTSTAR^2+VASTAR^2);
            if LD==0
                DVISC = (VSTAR^2*CDC(m)*CD(m))/(2*pi);
            else
                FKJ = VSTAR*G(m);
                DVISC = FKJ/CD(m);
            end
            CT(KTRY) = CT(KTRY)+(VTSTAR*G(m)-DVISC*VASTAR/VSTAR)*DR;
            CQ(KTRY) = CQ(KTRY)+(VASTAR*G(m)+DVISC*VTSTAR/VSTAR)*RC(m)*DR;
        end
        if IHUB~=0
            CTH = .5*(log(1/RHV)+3)*(NBLADE*G(1))^2;
        else
            CTH = 0;
        end
        CT(KTRY) = CT(KTRY)*4*NBLADE-CTH;
        CQ(KTRY) = CQ(KTRY)*2*NBLADE;
        CP(KTRY) = CQ(KTRY)*2*pi/ADVCO;
        KT(KTRY) = CT(KTRY)*ADVCO^2*pi/8;
        KQ(KTRY) = CQ(KTRY)*ADVCO^2*pi/8;
        EFFY(KTRY) = CT(KTRY)*WAKE/CP(KTRY);
        for i=1:length(RC)
            if (isreal(TANBIC(i))==0)||(isreal(EFFY(KTRY))==0)||(EFFY(KTRY)<=0)
                TANBIC(i) = NaN;
                EFFY(KTRY) = NaN;
            end
        end
        % =================================================== End of FORCES
        if abs(CT(KTRY)-CTDES)<(5e-6)   
            break
        end
    end             % For KTRY=1:ITER.  Do not delete
    if IERR==1      % Stop run if matrix is singular
       fprintf('Matrix is Singular. Run Terminated.\n');     
       return;
    else
        if Single_Flag==1
            TANBC = atand(TANBC);                    
            TANBIC = atand(TANBIC);                   
            fid = fopen('MPVL_Output.txt','w');      
            fprintf(fid,'\t\t\t\t\t MPVL_Output.txt\n');      
            fprintf(fid,'\t\t\t\t\tMPVL Output Table\n');
            fprintf(fid,'Ct= % 5.4f\n' ,CT(KTRY));   
            fprintf(fid,'Cp= % 5.4f\n' ,CP(KTRY));
            fprintf(fid,'Kt= % 5.4f\n' ,KT(KTRY));   
            fprintf(fid,'Kq= % 5.4f\n' ,KQ(KTRY));
            fprintf(fid,'Va/Vs= % 5.4f\n' ,WAKE);    
            fprintf(fid,'Efficiency= %5.4f\n' ,EFFY(KTRY));
            fprintf(fid,' r/R\t  \tG\t\t  Va\t  Vt\t  Ua\t  \tUt\t \tBeta\tBetaI\t c/D\t  Cd\t\n');
            for i = 1:length(RC)               
            fprintf(fid,'%5.5f  %5.6f  %5.5f  %5.4f  %5.5f  %5.5f  %5.3f  %5.3f  %5.5f  %5.5f\n',...
                RC(i),G(i),VAC(i),VTC(i),UASTAR(i),UTSTAR(i),TANBC(i),TANBIC(i),CDC(i),CD(i));
            end
            fclose(fid);
        end
    end
% ==================================================== End of Main Function    
% =============================================== FORTRAN Subroutine WRENCH    
function [UAIF,UTIF]=WRENCH(NBLADE,TANBIW,RCW,RVW)
    if NBLADE>20    % Return infinite blade result if NBLADE>20
        if RCW>RVW
            UAIF = 0;
            UTIF = NBLADE*(RCW-RVW)/RCW;
        else
            UAIF = -NBLADE*(RCW-RVW)/(RVW*TANBIW);
            UTIF = 0;
        end
        return;
    end
    XG = 1/TANBIW;    % End of infinite blade patch
    ETA = RVW/RCW;
    H = XG/ETA;
    XS = 1+H^2;
    TW = sqrt(XS);
    V = 1+XG^2;
    W = sqrt(V);
    AE = TW-W;
    U = exp(AE);
    R = (((TW-1)/H*(XG/(W-1)))*U)^NBLADE;
    XX = (1/(2*NBLADE*XG))*((V/XS)^0.25);
    Y = ((9*XG^2)+2)/(V^1.5)+((3*H^2-2)/(XS^1.5));
    Z = 1/(24*NBLADE)*Y;
    if H>=XG
        AF = 1+1/(R-1);
        if AF==0
            UAIF = NaN;
            UTIF = NaN;
            return;
        else
            AA = XX*(1/(R-1)-Z*log(AF));
            UAIF = 2*NBLADE^2*XG*H*(1-ETA)*AA;
            UTIF = NBLADE*(1-ETA)*(1+2*NBLADE*XG*AA);
        end
    else
        if R>1e-12
            RATIO = 1/(1/R-1);
        else
            RATIO = 0;
        end
        AG = 1+RATIO;
        if AG==0
            UAIF = NaN;
            UTIF = NaN;
            return;
        else
            AB = -XX*(RATIO+Z*log(AG));
            UAIF = NBLADE*XG*(1-1/ETA)*(1-2*NBLADE*XG*AB);
            UTIF = 2*NBLADE^2*XG*(1-ETA)*AB;
        end
    end   