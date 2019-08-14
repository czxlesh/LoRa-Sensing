function save2DB(amp, time, status, actID)
    incre_time_Str = sprintf('%.2f,',time);
    incre_time_Str = ['[' , incre_time_Str , ']'];
    incre_time_Str = strrep(incre_time_Str, ',]', ']');
    
    incre_amp_Str = sprintf('%.4f,',amp);
    incre_amp_Str = ['[' , incre_amp_Str , ']'];
    incre_amp_Str = strrep(incre_amp_Str, ',]', ']');
    
    incre_status_Str = sprintf('%d,',status);
    incre_status_Str = ['[' , incre_status_Str , ']'];
    incre_status_Str = strrep(incre_status_Str, ',]', ']');
    
    incre_actid_Str = sprintf('%d,',actID);
    incre_actid_Str = ['[' , incre_actid_Str , ']'];
    incre_actid_Str = strrep(incre_actid_Str, ',]', ']');
    
    output = '{\"amp\":AMPINFO, \"time\":TIMEINFO, \"status\":STATUS, \"actid\":ACTID}';
    output = strrep(output, 'AMPINFO', incre_amp_Str);
    output = strrep(output, 'TIMEINFO', incre_time_Str);
    output = strrep(output, 'STATUS', incre_status_Str);
    output = strrep(output, 'ACTID', incre_actid_Str);
    
    system(['python C:\Users\czxlesh\Desktop\lab\walkDemo\code\save2DB.py ', '"', output, '"'] );
end