function interface_niveaux()

% GUI INTERFACE: Mot-NonMot with confidence levels
%
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

load interface_niveaux                 

a = figure('Units','points', ...
	'Color',[0 0 0], ...
   'menubar','none', ...
   'Colormap',mat0, ...
	'PointerShapeCData',mat1, ...
	'Position',[0 0 600 435.75], ...
	'Tag','Fig1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','answer = 1;', ...
   'FontSize',16, ...
	'FontWeight','bold', ...
	'Position',[359.25 210.75 120 168], ...
	'String','Mot', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','answer = 2;', ...
	'FontSize',16, ...
	'FontWeight','bold', ...
	'Position',[121.5 210.75 117.75 167.25], ...
	'String','Non-mot', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','confidence = 5;', ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'Position',[408.75 126.75 63.75 41.25], ...
	'String','5', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','confidence = 4;', ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'Position',[339 126.75 63.75 41.25], ...
	'String','4', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','confidence = 3;', ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'Position',[269.25 126.75 63.75 41.25], ...
	'String','3', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','confidence = 2;', ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'Position',[199.5 126.75 63.75 41.25], ...
	'String','2', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'FontName','Time', ...
   'Callback','confidence = 1;', ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'Position',[129.75 126.75 63.75 41.25], ...
	'String','1', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0 0.7 0.7], ...
	'FontName','time', ...
	'Position',[132 99 338.25 12], ...
	'String',mat2, ...
	'Style','text', ...
	'Tag','StaticText1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','debut=1;', ...
   'Fontname','times', ...
	'Position',[420.75 21 167.25 19.5], ...
	'String','Lancer l''expérience', ...
	'Tag','Pushbutton_Debut');
