data_handle = findobj(gcf,'Tag','data_box')
data_value = str2num(get(data_handle,'String'))
set(data_handle,'String','')
