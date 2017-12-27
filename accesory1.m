function output_txt = myfunction(obj,event_obj)
% Eliminate strings from datatips
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   This are the strings displayed, must remain empty

pos = get(event_obj,'Position');
output_txt = {[]};
