
%------------------------------------------------------------------------------
% AFC for Mathwork’s MATLAB
%
% Version 1.40.0
%
% Author(s): Stephan Ewert
%
% Copyright (c) 1999-2014, Stephan Ewert. 
% All rights reserved.
%
% This work is licensed under the 
% Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License (CC BY-NC-ND 4.0). 
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to Creative
% Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
%------------------------------------------------------------------------------

% last modified 19-04-2013 13:18:00
% revision 0.94 beta, modified 18/03/02

function afc_win_forWebapp(action)

global def
global work
global msg

% h = def.afc_win;
% if the window is not enabled just leave here
if ( def.afcwinEnable == 0 )
	return;
end

% check whether window is still existing
% if we attempt to call a dead window with any action other than 'open'
% shut the whole thing down
if ( strcmp(action, 'open') == 0 & ~isvalid(def.afc_win))
	work.terminate = 1;
	work.abortall = 1;
% 	warning('AFC:afcwin', 'Attempt to access non existing response window. Run terminated');
	%warning('Attempt to access non existing response window. Run terminated');
	return;	
end

switch action
   case 'open'

num=getfield(def,'intervalnum');

def.afc_win.BusyAction = 'cancel';
def.afc_win.KeyPressFcn = ['afc_pressfcn(' num2str(num) ',0)'];
def.afc_win.WindowKeyPressFcn = ['afc_pressfcn(' num2str(num) ',0)'];
% h.Tag = 'afc_win';
def.afc_win.MenuBar = 'none';
def.afc_win.Color = [0.75 0.75 0.75];
def.afc_win.Interruptible = 'off';
% h.HandleVisibility = 'on';
% h.CloseRequestFcn = 'afc_close';
def.afc_win.Name = ['AFC-measurement (' def.version ')'];

windowSize = repmat(def.afc_win.Position(3:end),1,2);

% 08.11.2006 09:43
% some position adjustments
yShift = 0;
yShiftButtons = 0; 

switch def.winButtonConfiguration
case 1
	% open start and end button, too
	
	def.afc_startbutton = uibutton('Parent',def.afc_win, ...										% create start button
		'BusyAction','cancel', ...
		'ButtonPushedFcn',['afc_pressfcn(' num2str(num) ',''s'')'], ...
		'FontSize',18, ...
		'Position',[0.1 0.85 0.35 0.1].*windowSize, ...
		'BackgroundColor',[0.75 0.75 0.75],...
		'String',msg.startButtonString);
	      
	 % 15-04-2005 14:15 check version for >=7 and add keypressfcn to buttons
%    if ( work.matlabVersion > 6 ) 
%    	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
%    end
%    
%    if ( (def.mouse == 0) )
%    		set(b,'Enable','off');
%    end
% 	
	def.afc_endbutton = uibutton('Parent',def.afc_win, ...										% create end button
		'BusyAction','cancel', ...
		'ButtonPushedFcn',['afc_pressfcn(' num2str(num) ',''e'')'], ...
		'FontSize',18, ...
		'Position',[0.55 0.85 0.35 0.1].*windowSize, ...
		'BackgroundColor',[0.75 0.75 0.75],...
		'String',msg.endButtonString);
		
		% 15-04-2005 14:15 check version for >=7 and add keypressfcn to buttons
%    if ( work.matlabVersion > 6 ) 
%    	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
%    end
%    
%    if ( (def.mouse == 0) )
%    		set(b,'Enable','off');
%    end
   
   % some position adjustments
   yShift = 0.125;
   yShiftButtons = 0.05; 

end

switch def.windetail
case 0
def.afc_message = uitextarea('Parent',def.afc_win, ...										% create message display
    'BackgroundColor',[0.9 0.9 0.9], ...
  	'HorizontalAlignment','center',...
    'FontSize',24, ...
    'Position',[0.1 0.4 0.8 0.5-yShift].*windowSize, ...
    'Value',' ', ...
    'Editable','off');
	
	% some position adjustments
   yShift = 0;
   yShiftButtons = 0; 
case 1
   def.afc_t1 = uitextarea('Parent',def.afc_win, ...										% create message display
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'HorizontalAlignment','center',...
    'FontSize',12, ...
   'Position',[0.1 0.85-yShift 0.35 0.075].*windowSize, ...
   'Value',' ', ...
   'Editable','off');

	def.afc_t2 = uitextarea('Parent',def.afc_win, ...										% create message display
   'BackgroundColor',[0.9 0.9 0.9], ...
   'HorizontalAlignment','center',...
    'FontSize',12, ...
   'Position',[0.55 0.85-yShift 0.35 0.075].*windowSize, ...
   'Value',' ', ...
   'Editable','off');

   def.afc_message = uitextarea('Parent',def.afc_win, ...										% create message display
   'BackgroundColor',[0.9 0.9 0.9], ...
   'HorizontalAlignment','center',...
   'FontSize',24, ...
    'Position',[0.1 0.4-(yShift-yShiftButtons) 0.8 0.4-yShiftButtons].*windowSize, ...
   'Value',' ', ...
   'Editable','off');
end 

for i = 1:num															% create buttons
   bwidth = 0.8/(num+(0.5*(num-1)));
   bsepar=bwidth/4;
   
    def.afc_button(i) = uibutton ...
   ('Parent',def.afc_win, ...
	'BusyAction','cancel', ...
    'ButtonPushedFcn',['afc_pressfcn(' num2str(num) ',' num2str(i) ')'], ...
	'FontSize',18, ...
	'Position',[0.1+(i-1)*(1.5*bwidth) 0.1-yShiftButtons bwidth 0.2].*windowSize, ...
    'BackgroundColor',[0.75 0.75 0.75],...
	'Text',msg.buttonString{i});
   
    % 15-04-2005 14:15 check version for >=7 and add keypressfcn to buttons
%    if ( work.matlabVersion > 6 ) 
%    	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
%    end
%    
   if ( (def.mouse == 0) | ~( isempty(def.acceptButton) | ismember(i, def.acceptButton ) ) )
   		set(def.afc_button(i),'Enable','off');
   end
   
end

% generate the audioplayer html component.
def.webAudioPlayer = uihtml...
    ('Parent',def.afc_win,...
    'HTMLSource',[def.webAudioPath 'webAudioPlayer.html'],...
    'Interruptible','off',...
    'Position',[100 210 640 80],...,
    'DataChangedFcn',@(src,event)webAudioChange(src,event)...
    );

if isfield(def,'htmlDebug')
    if def.htmlDebug == 1

    else
        def.webAudioPlayer.Visible = 'off';
    end
else
    def.webAudioPlayer.Visible = 'off';
end

% def.afc_win.Visible = 'off';
% def.afc_win.Visible = 'on';

figure(def.afc_win);

% refresh(h)

%------------------------ end of action 'open'----------------------------

case 'close'
% 	h=findobj('Tag','afc_win');
   	
	% snd_pc
	%if ( def.bits > 16 )
   	%	if ( isfield(work, 'soundres' ) )
   	%		if ( sum(work.soundres) ~= 0 )
        % 			snd_stop(work.soundres);
        % 			work.soundres = 0;
   	%		end
      	%	end
   	%end
   
% 	delete(h);
	%close(h);
   if isvalid(def.afc_win)
       afc_close;
%         delete(def.afc_win)
   end
case 'start_ready'
%   hm=findobj('Tag','afc_message');					% handle to message box
% 	h=findobj('Tag','afc_win');						%
% 	ht2=findobj('Tag','afc_t2');
% 	ht1=findobj('Tag','afc_t1');
   
   % Was Andy request
   % 01-08-2005 10:30 SE introduce config var for this screen skip because the start_msg
   % might be used for different msg during the experiment run
   % are we really starting the exp or do we start the next measurement?
   % 08.09.2005 14:34 added def.skipStartMessage
   if ( (work.terminate > 0) & (def.skipStartMessage == 1) )
%    	set(h,'UserData',0);
        def.afc_win.UserData = 0;
		pause( 0.25);	
   else
%    	set(hm,'Value',msg.start_msg);
% 		set(h,'UserData',4);
        def.afc_message.Value = msg.start_msg;
        def.afc_win.UserData = 4;
        
   end
   
%    set(ht1,'Value',sprintf(msg.experiment_windetail, work.filename));
%    set(ht2,'Value',sprintf(msg.measurementsleft_windetail, size(work.control,1) + 1 - work.numrun, size(work.control,1)));
   
   def.afc_t1.Value = sprintf(msg.experiment_windetail, work.filename);
   def.afc_t2.Value = sprintf(msg.measurementsleft_windetail, size(work.control,1) + 1 - work.numrun, size(work.control,1));
   
   figure(def.afc_win);
   drawnow;
   
case 'start'
%    hm=findobj('Tag','afc_message');
%    ht2=findobj('Tag','afc_t2');
% 
%    set(hm,'Value','');
%    set(ht2,'Value',sprintf(msg.measurement_windetail, work.numrun, size(work.control,1)));
    def.afc_message.Value = '';
    def.afc_t2.Value = sprintf(msg.measurement_windetail, work.numrun, size(work.control,1));
   
case 'finished'
%    hm=findobj('Tag','afc_message');
%    h=findobj('Tag','afc_win');
% 	set(hm,'Value',msg.finished_msg);				% called if experiment is already finished
% 	set(h,'UserData',-2);								% ready to get only end command

    def.afc_message.Value = msg.finished_msg;
    def.afc_win.UserData = -2;

case 'correct'
%    hm=findobj('Tag','afc_message');
%    set(hm,'Value',msg.correct_msg);

    def.afc_message.Value = msg.correct_msg;

   drawnow; % flush event que 15-04-2005 13:38

case 'false'
%    hm=findobj('Tag','afc_message');
%    set(hm,'Value',msg.false_msg);
    def.afc_message.Value = msg.false_msg;
   drawnow; % flush event que 15-04-2005 13:38

case 'clear'
%    hm=findobj('Tag','afc_message');
%    set(hm,'Value','');
    def.afc_message.Value = '';
   drawnow; % flush event que 15-04-2005 13:38

case 'measure'
    
%    hm=findobj('Tag','afc_message');
%    set(hm,'Value',msg.measure_msg);
    def.afc_message.Value = msg.measure_msg;
   
case 'maxvar'
% 	hm=findobj('Tag','afc_message');
%    set(hm,'Value',msg.maxvar_msg);
  def.afc_message.Value = msg.maxvar_msg; 
case 'minvar'
%    hm=findobj('Tag','afc_message');
% 	set(hm,'Value',msg.minvar_msg);
def.afc_message.Value = msg.minvar_msg;
 
case 'markint'						% must be a blocking action !!!
   tic;

	inter=max(0,def.intervallen/def.samplerate-0.02);
	paus=max(0,def.pauselen/def.samplerate-0.02);
	
	% 1.00.1
	%if ( ~(strcmp(def.externSoundCommand, 'sndmex') & def.sndmexmark) & ~((strcmp(def.externSoundCommand, 'soundmex') | strcmp(def.externSoundCommand, 'soundmexfree') | strcmp(def.externSoundCommand, 'soundmex2') | strcmp(def.externSoundCommand, 'soundmex2free') | strcmp(def.externSoundCommand, 'soundmexpro') ) & def.soundmexMark) )
	%if ((def.sndmex == 0) | (def.sndmexmark == 0))
	if ( ~afc_sound('isSoundmexMarking') )
		switch def.markinterval
	   	case 1
			pause(def.presiglen/def.samplerate)
	
			for i=1:def.intervalnum-1
% 	   			h=findobj('Tag',['afc_button' num2str(i)]);
% 	   			if ( ~isempty(h) )
% 	   				set(h,'backgroundcolor',[1 0 0])
% 	   			end
                def.afc_button(i).BackgroundColor = [1 0 0];
	   			pause(inter)
% 	   			if ( ~isempty(h) )
% 					set(h,'backgroundcolor',[0.75 0.75 0.75])
%                 end	
                def.afc_button(i).BackgroundColor = [.75 .75 .75];
	   			pause(paus)
            end
            
%             h=findobj('Tag',['afc_button' num2str(def.intervalnum)]);
% 			if ( ~isempty(h) )
% 				set(h,'backgroundcolor',[1 0 0])
% 	   		end
            def.afc_button(def.intervalnum).BackgroundColor = [1 0 0];
	   		pause(inter)
% 	   		if ( ~isempty(h) )
% 	   			set(h,'backgroundcolor',[0.75 0.75 0.75])
% 	  		end
            def.afc_button(def.intervalnum).BackgroundColor = [.75 .75 .75];
	  		pause(def.postsiglen/def.samplerate)
	   
	   	case 0
	      	%pause((def.presiglen+def.postsiglen+def.intervalnum*def.intervallen+ ...
	      	%(def.intervalnum-1)*def.pauselen)/def.samplerate)   
		end
	end

	elapsed = toc;												% blocking until end of signal presentation is reached
	%while elapsed < def.bgsiglen/def.samplerate+0.1	% plus 0.1 sec safety margin 
   	while elapsed < work.blockButtonTime
   		pause(0.02);
   		elapsed = toc;
    end
   
% ------------------------- end of action 'markint' -------------------
   
case 'markpressed'
%    hb=findobj('Tag',['afc_button' num2str(work.answer{work.pvind}(work.stepnum{work.pvind}(end)))]);
%    
%    if ( ~isempty(hb) )
%    	set(hb,'backgroundcolor',[0 0 0.75]);
%    	pause(0.2);
% 	set(hb,'backgroundcolor',[0.75 0.75 0.75]);
% 	pause(0.0001);
%    end
    def.afc_button(work.answer{work.pvind}(work.stepnum{work.pvind}(end))).BackgroundColor = [0 0 .75];
    pause(0.2)
    def.afc_button(work.answer{work.pvind}(work.stepnum{work.pvind}(end))).BackgroundColor = [.75 .75 .75];
    pause(.0001)

case 'markcorrect'
%    hb=findobj('Tag',['afc_button' num2str(work.position{work.pvind}(work.stepnum{work.pvind}(end)))]);
   
   if def.markpressed
   	pause(0.2);
   end
   
%    if ( ~isempty(hb) )
% 	   set(hb,'backgroundcolor',[0.5 0.5 0]);
% 	   pause(0.2);
% 	   set(hb,'backgroundcolor',[0.75 0.75 0.75]);
% 	   pause(0.0001);
%    end
    def.afc_button(work.position{work.pvind}(work.stepnum{work.pvind}(end))).BackgroundColor = [.5 .5 0];
    pause(0.2)
    def.afc_button(work.position{work.pvind}(work.stepnum{work.pvind}(end))).BackgroundColor = [.75 .75 .75];
    pause(.0001)
    
case 'response_ready'
%    hm=findobj('Tag','afc_message');
% 	set(hm,'Value',msg.ready_msg);
    def.afc_message.Value = msg.ready_msg;

end	% end switch

% eof