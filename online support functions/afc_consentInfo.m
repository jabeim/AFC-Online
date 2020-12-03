function [consent, consentElement] = afc_consentInfo(app)
%AFC_CONSENTINFO Creates an html inset in the current figure window for displaying a pdf file consent
%form using the html code stored in consentDisplay.html. 
%
%consentDisplay.html must be updated in order to specify the name of the
%pdf file to be loaded.
%
%Inputs:
%   app: the handle to the main app (onlineExperiment) window, used to
%   specify the parent of the new consent display inset.
%
%Outputs:
%   consent: logical status indicating that consent has been given. this is
%   broadcast forward when the user clicks the 'I agree' button.
%   consentElement: the handle to the consent display inset, useful for
%   deleting the consent window after consent is given


consentFile = '/web/catss/Audio/consentDisplay.html';

consentElement = uihtml(app.UIFigure);
windowSize = repmat(app.UIFigure.Position(3:4),1,2);
consentElement.Position  = [0.0156    0.3125    0.9688    0.6458].*windowSize; % [10 150 620 310]
consentElement.Visible = 'on';
consentElement.HTMLSource = consentFile;



app.TextArea.Visible = 'off';
app.NextButton.Text = 'I Agree';
app.IdonotconsentButton.Visible = 'on';
consent = 1;
end

