function Launcher(app)
% Launcher.m is the primary code executed by the app 'onlineExperiment' as
% the primary callback for the UIs primary interactable user input button.
% Launcher updates the UI based on the experiment workflow state (id validation, consent,
% experiment) 
%
% This function must be customized to launch the specific experimental code
% (AFC or speech or other) desired by the researcher. See the section
% "Modify startup command for your experiment here" below.
%
%Inputs:
%   app: the handle to the main 'onlineExperiment' app window, used for
%   controlling window elements. Does not need to be modified by user.
persistent success consent consentElement

if isempty(consent) 
    consent = 0; 
end

figHandle = app.UIFigure;
figureElements = app.UIFigure.Children;
id = app.EditField.Value;

if isempty(success) || success < 1
    success = validateUser(id);

end

if success >= 1 && strcmp(app.NextButton.Text,'Begin Experiment')
    delete(figureElements); % delete start button (and other UI elements) before AFCTakeover
    figure(app.UIFigure);
    
    %% Modify afc startup command for your experiment here

    afc_main('Stripes',id,'n640','0','l','EXAMPLE',figHandle) % figHandle must be the final input argument.

    return
end

if consent && success == 1  % display this after users click 'I agree' from the consent form page.
    delete(consentElement);
    delete(app.IdonotconsentButton);
    afc_instructions(app);  
    app.NextButton.Text = 'Begin Experiment';
elseif success == 2    % validation returned that consent has already been gathered, skip consent form display.
    consent = 1;
    app.EditField.Visible = 'off';
    afc_instructions(app)
    app.NextButton.Text = 'Begin Experiment';
elseif success == 1 % ID is valid, but no consent record was found, display consent form PDF.
    app.EditField.Visible = 'off';
    [consent, consentElement] = afc_consentInfo(app);
elseif success == 0
    app.TextArea.Value = 'Invalid User ID. Please try again';
    app.EditField.Value = '';
elseif success == -1
    app.TextArea.Value = 'Invalid User ID. Please try again;';
    app.EditField.Value = '';
end




% 