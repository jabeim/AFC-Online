function [wavOut,envMean, envLo, envHi]= spiral(wavIn, nElectrodes, carrierDensity,carrierLo,carrierHi, currentSpread, dynamicRange, freqShift, sampleRate)
% function out = spiral(ipwave, n_electrodes, n_carriers, spread, sf)
%
% args in: input wave (:,1); number of electrodes; number of tone carriers;
% current spread [in -dB/Oct (negative!!)]; sampling frequency (Hz).
%
%       EXAMPLE: out = spiral(audioread('_wavefilename_'), 20, 80, -8, 44100);
%
% Typical current spread (Oxenham & Kreft 2014 + Nelson etal 2011) = -8 dB/octave.
%
% Author: Jacques Grange, Cardiff Uni, John Culling group, 2017; grangeja@cardiff.ac.uk.

% Modified by: Jordan Beim, University of Minnesota, Auditory Perception and
% Cognition lab, 2020; beimx004@umn.edu

                                                                            %
%                                                                           % could change spread to dB per ERB instead
    analysisLo=333;                                                         % lower bound of analysis filters (Hz) [120 ](Friesen et al.,2001)
    analysisHi=6665;                                                        % upper bound of analysis filters (Hz)[8658]
%     carrierLo = 333;                                                         % lower bound of carriers (Hz)
%     carrierHi = 16000;                                                      % higher bound of carriers (Hz) change to 16000?
    lp_filter = make_fir_filter(0, 50, sampleRate);                         % generate low-pass filter,  default 50Hz
%     analysisFreqs = generate_cfs(analysisLo, analysisHi, nElectrodes);      % electrodes' centre frequencies
    analysisFreqs = [333 455 540 642 762 906 1076 1278 1518 1803 2142 2544 3022 3590 4264 6665];
    carrierFreqs = generate_cfs2(carrierLo, carrierHi, carrierDensity);           % tone carrier frequencies
    nCarriers = length(carrierFreqs);
    toneCarriers = zeros(length(wavIn), nCarriers);
    analysisBands = generate_bands(analysisLo, analysisHi, nElectrodes);    % lower/upper limits of each analysis band
    analysisFilterbank = zeros(nElectrodes,512);
    envelope = zeros(length(wavIn),nElectrodes);                            % envelopes extracted per electrode
    compressedEnvelope = zeros(length(wavIn),nElectrodes);
    mixedEnvelope = zeros(length(wavIn),nCarriers);                         % mixed envelopes to modulate carriers
                                         
    t = 0:1/sampleRate:(length(wavIn)-1)/sampleRate;
                    
    load('nfMeasurements.mat')
    
    % per Stafford et al 2014, Ear & Hearing                                      
    envMin = sigMax;   % set this to 95% CI for channel envelope magnitudes
    envMax = nfMean;   % set this to approximate noise floor 
    
    if not(all(dynamicRange))
        error('Dynamic Range must be nonzero for all electrodes (range: (0 Inf])')
    end
    
    %% Create per-channel values for current spread, dynamic range, frequency shift
    if isscalar(currentSpread)
        currentSpread = currentSpread*ones(1,nElectrodes); % set current spread per electrode
    end
    
    if isscalar(dynamicRange)
        dynamicRange = dynamicRange*ones(1,nElectrodes); % set dynamic range per electrode
    end
    
    if isscalar(freqShift)
        freqShift = freqShift*ones(1,nElectrodes); % offset each electrode by 500 Hz for the purposes of mixed envelope summation
    end
    
    lowerBound = mean(envMax).*10.^(0.5*dynamicRange/20);   % matching envelope power to DR requires 50% dynamic range scaling here?
    
    
    for j=1:nElectrodes            % extraction of envelopes, per analysis band
        analysisFilterbank(j,:) = make_fir_filter(analysisBands(j,1), analysisBands(j,2), sampleRate);      % analysis filterbank
        speechband = conv(wavIn(:,1),analysisFilterbank(j,:),'same')';                                      % speech band filtering
        speechband = speechband.*(speechband>0);                                                            % envelope extraction by half-wave rectification
        %% Add dynamic range compression to each envelope here
        envelope(:,j) = conv(speechband,lp_filter,'same')';                                                 % low-pass filter envelope
        
        if dynamicRange(j) < inf % rescale only if dynamic range set
            compressedEnvelope(:,j) = rescale(envelope(:,j),lowerBound(j),mean(envMax));  % rescale envelope to [envMax-dynamicRange envMax)
            compressedEnvelope(envelope(:,j) >= 50*envMax(j),j) = 0; % zero points above envMax to reduce signal noise
        else
            compressedEnvelope(:,j) = envelope(:,j);                   
        end
    end
    

    envelope = compressedEnvelope;
    
    for i=1:nCarriers              % contribution of each envelope to each mixed envelope
        for j=1:nElectrodes
            mixedEnvelope(:,i) = mixedEnvelope(:,i) + ...
          10^(currentSpread(j)/10*abs(log2(erb2hz(hz2erb(analysisFreqs(j))+freqShift(j))/carrierFreqs(i))))*envelope(:,j).^2;  % weights applied to power envelopes
        end
    end
    mixedEnvelope = mixedEnvelope.^0.5;                                   % sqrt to get back to amplitudes
    wavOut = zeros(length(wavIn),1);
    for i=1:nCarriers
        toneCarriers(:,i) = sin(2*pi*(carrierFreqs(i)*t+rand))';                 % randomise tone phases (particularly important for binaural!)
        wavOut = wavOut + mixedEnvelope(:,i).*toneCarriers(:,i);                    % modulate carriers with mixed envelopes
    end
    wavOut = wavOut*0.05*sqrt(length(wavOut))/norm(wavOut);                             % rms scaled, to avoid saturation
end



