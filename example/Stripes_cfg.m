% Stripes_cfg 
%
% This matlab script is called by afc_main when starting
% the experiment 'Stripes'.

rng('shuffle');

def=struct(...
    'expname','Stripes',         ...    % name of experiment
    'intervalnum',3,			 ...	% number of intervals
    'ranpos',0,                  ...    % interval which contains the test signal: 1 = first interval ..., 0 = random interval
    'rule',[1 2],                ...    % [up down]-rule: [1 3] = 1-up 3-down
    'varstep',-[1.25 0.5 0.2],     ...  % [starting stepsize ... minimum stepsize] of the tracking variable
    'steprule',1,               ...     % stepsize is changed after each upper (-1) or lower (1) reversal
    'reversalnum', 6,            ...    % number of reversals in measurement phase
    'repeatnum', 3,              ...    % number of repeatitions of the experiment
    'startvar', 1.5,             ...    % starting value of the tracking variable
    'expvarunit','density',      ...    % unit of the tracking variable
    'minvar', 1,                 ...    % minimum value of the tracking variable
    'maxvar', 80,                ...	% maximum value of the tracking variable
    'terminate', 1,              ...	% terminate execution on min/maxvar hit: 0 = warning, 1 = terminate
    'endstop', 6,                ...    % Allows x nominal levels higher/lower than the limits before terminating (if def.terminate = 1)
    'exppar1',[-12 -18 -24],             ...    % spread simulation; rolloff of synthesis filters [-12 -8 -4]
    'exppar1unit','dB/Oct',      ...    % unit of experimental parameter
    'exppar2',[16],  ...                % number of simulated electrodes; signal analysis filtters
    'exppar2unit','n/a',         ...    % unit of experimental parameter
    'exppar3',[Inf 40],...              % channel dynamic range; Inf for no limit, otherwise limited to values specified [Inf 40]
    'exppar3unit','dB',...              %
    'exppar4',[0],...                   % frequency reallocation; shift in frequency content between analysis and synthesis in ERBs [0 5]
    'exppar4unit','ERB',         ...    
    'vocoderEnable',1,          ...
    'sweepDur',1,                ...
    'sweepLo',250,               ...
    'sweepRate',5,               ...
    'sweepRampDur',50,           ...
    'noiseDur',250,              ...    %
    'noiseLo', 100,              ...
    'noiseHi',8700,              ...
    'sigLevel',70,               ...
    'baseStimDur',0.75,...
    'parrand',[1 1 1 1],	     ...	% toggles random presentation of the elements in "exppar" on (1), off(0)
    'maxLevel',104.3,            ...    % max level of signal output; maxLevel = maxRMS-3;
    'samplerate',48000,          ...	% sampling rate in Hz
    'intervallen',240000,         ...    % length of each signal-presentation interval in samples
    'pauselen',28800,            ...	% length of pauses between signal-presentation intervals in samples
    'presiglen',0,               ...	% length of signal leading the first presentation interval in samples
    'postsiglen',0,              ...	% length of signal following the last presentation interval in samples
    'messages','autoSelect',...
    'windetail',1,               ...    % If set to 1, displays number of runs left on message screen.
    'mouse',1,					 ...	% enables mouse control (1), or disables mouse control (0)
    'markinterval',1,			 ...	% toggles visuell interval marking on (1), off(0)
    'feedback',1,				 ...	% visuell feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
    'savefcn','default',		 ...    % function which writes results to disk
    'debug',0					 ...    % set 1 for debugging (displays all changible variables during measurement)
    );


if def.vocoderEnable == 0
    def.exppar1 = 1;
    def.exppar2 = 1;
    def.exppar3 = 1;
    def.exppar4 = 1;
end


noiseOn = cos(linspace(pi/2,0,floor(50/1000*def.samplerate))).^2;
noiseOff = cos(linspace(0,pi/2,floor(125/1000*def.samplerate))).^2;
def.noiseRamp = [noiseOn ones(1,def.noiseDur/1000*def.samplerate-(length(noiseOn)+length(noiseOff))) noiseOff];


%% Webapp required parameters are set here
def.afcwin = 'afc_win_forWebapp';

webDataRoot = [filesep 'labs' filesep 'oxenhamlab' filesep]; % primary directory for storing results
def.control_path = [webDataRoot def.expname filesep 'Control' filesep]; % control file location
def.result_path = [webDataRoot def.expname filesep 'Output' filesep];   % output file location

def.webAudioPath = [filesep 'web' filesep 'catss' filesep 'Audio' filesep]; % location where webAudioPlayer.html and temporary audio files will be stored


def.externSoundCommand = 'webAudio'; % override standard AFC audio using webAudioPlayer.html.
def.htmlDebug = 0;
def.debug = 0; % if debug is not set to 0 afc will produce warnings/errors due to nonstandard parameters stored in the def structure.