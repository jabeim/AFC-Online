%AbsProbe_set - setup function of experiment 'AbsProbe' -
%
% This function is called by afc_main when starting
% the experiment 'Abs'. It defines elements
% of the structure 'setup'. The elements of 'setup' are used 
% by the function 'Abs_user.m'.

function Stripes_set

global def
global work
global set

%% Condition dependant vocoder parameters
set.spread = work.exppar1; % current spread in dB/oct
set.nElec = work.exppar2;

%% Static vocoder parameters
set.carrierLo = 250;
set.carrierHi = 16000;
set.carrierDensity = 1;
set.freqShift = work.exppar4;
set.dr = work.exppar3;
end



