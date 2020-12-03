% AbsProbe_user - stimulus generation function of experiment 'AbsProbe' -
%
% This function is called by afc_main when starting
% the experiment 'AbsProbe'. It generates the stimuli which
% are presented during the experiment.
% The stimuli must be elements of the structure 'work' as follows:
%
% work.signal = def.intervallen by 2 times def.intervalnum matrix.
%               The first two columns must contain the test signal
%               (column 1 = left, column 2 = right) ...
% 
% work.presig = def.presiglen by 2 matrix.
%               The pre-signal. 
%               (column 1 = left, column 2 = right).
%
% work.postsig = def.postsiglen by 2 matrix.
%                The post-signal. 
%               ( column 1 = left, column 2 = right).
%
% work.pausesig = def.pausesiglen by 2 matrix.
%                 The pause-signal. 
%                 (column 1 = left, column 2 = right).

function Stripes_user

global def
global work
global set

density = work.expvaract; % Signal level
sweepHi = def.sweepLo*2^(def.sweepRate*def.sweepDur);
cycleDur = def.sweepDur/density;
delaySamps = fix(cycleDur*def.samplerate);
totalDur = def.baseStimDur+1*cycleDur;
totalSamps = fix(totalDur*def.samplerate);




% sigLevelAtten = def.sigLevel-def.maxLevel;  % The amount that the stimuli will be attenuated by

t = [0:def.sweepDur*def.samplerate-1]/def.samplerate;
rampT = linspace(0,pi/2,floor(def.sweepRampDur/1000*def.samplerate));
sweepRamp = cos(rampT).^2;
fullRamp = [fliplr(sweepRamp) ones(1,length(t)-2*length(rampT)) sweepRamp];
sweptTone = fullRamp.*chirp(t,def.sweepLo,def.sweepDur,sweepHi,'logarithmic');

totalSweeps = ceil((totalSamps+density*delaySamps+def.sweepDur*def.samplerate)/delaySamps);

sweepComplex = [sweptTone zeros(1,fix((1+def.baseStimDur+(3+density)*cycleDur)*def.samplerate-length(sweptTone)))];
for i = 1:totalSweeps
    delay = fix(i*delaySamps);
    if delay+length(sweptTone) <= length(sweepComplex)
        sweepComplex = sweepComplex+[zeros(1,delay) sweptTone zeros(1,length(sweepComplex)-(delay+length(sweptTone)))];
    elseif delay < length(sweepComplex)
        sweepComplex = sweepComplex+[zeros(1,delay) sweptTone(1:end-(length(sweptTone)-(length(sweepComplex)-delay)))];       
    end
end


for i = 1:def.intervalnum
randomPhase = fix(density*cycleDur*def.samplerate)+randi(def.sweepDur*def.samplerate);
singleInterval = [zeros(1,9000) sweepComplex(randomPhase+1:randomPhase+totalSamps) zeros(1,9000)];
noiseStim = gnoise(def.noiseDur,def.noiseLo,def.noiseHi,0,0,def.samplerate);
noiseFinal = noiseStim.*def.noiseRamp;

% noiseFinal = zeros(size(noiseFinal));

singleInterval(1:length(noiseFinal)) = singleInterval(1:length(noiseFinal))+noiseFinal;
singleInterval(end-length(noiseFinal)+1:end) = singleInterval(end-length(noiseFinal)+1:end) + fliplr(noiseFinal);
singleInterval = 10^((def.sigLevel-def.maxLevel)/20)*singleInterval/rms(singleInterval);

if def.vocoderEnable == 1
    singleInterval = spiral(singleInterval',set.nElec,set.carrierDensity,set.carrierLo,set.carrierHi,set.spread,set.dr,set.freqShift,def.samplerate);
else
    singleInterval = singleInterval';
end

def.intervallen = length(singleInterval); % assign interval length dynamically to acommodate stimulus duration chaing based on glide density

if i == 1
    work.signal = [flipud(singleInterval) zeros(size(singleInterval))];
else
    work.signal = [work.signal singleInterval zeros(size(singleInterval))];
end

end



presig = zeros(def.presiglen,2); % nothing
postsig = zeros(def.postsiglen,2); % silence; duration defined in AbsProbe_cfg.m
pausesig = zeros(def.pauselen,2); % nothing

% work.signal = [ref' sig' ref' ref'];	% First two columns holds the test signal (left right); note that the signal is only presented to the right ear
work.presig = presig;					% must contain the presignal
work.postsig = postsig;                 % must contain the postsignal
work.pausesig = pausesig;               % must contain the pausesignal

% eof
