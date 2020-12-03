function [success] = validateUser(id)
%%% validate user id string and return status 
%%% Inputs:
%%%     id: a numeric string corresponding to the participants database ID.
%%%     This may change depending on how this function is re-engineered for your specific
%%%     use case.
%%% Outputs:
%%%     success: [0,1, or 2] a numeric value that is used to control logical flow in
%%%     Launcher.m
%%%         0: validation failed, do not proceed
%%%         1: partial validation, display consent form within the app
%%%         2: full validation, bypass consent form display. proceed to
%%%         experiment.
if isempty(str2double(id)) || isnan(str2double(id))
    % screen out any ID's that are not numeric or process them without redcap
    % validation
    success = 0;
else
    % Add custom validation code here
    success = 2; 

end
    
end

