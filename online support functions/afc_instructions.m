function afc_instructions(app)
%AFC_INSTRUCTIONS Display text in the main window of Launcher.m before
%control is handed off to the AFC function.  Currently supports only text
%instructions. Redefine the instructions variable below to best fit the
%needs of your experiment.


instructions = 'Enter your pre-experiment instructions here. (afc_instructions.m)';

app.TextArea.Value = instructions;
app.TextArea.Visible = 'on';


end

