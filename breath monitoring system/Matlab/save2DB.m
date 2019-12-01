function save2DB(amp, freqId, psd, time, brate)
    incre_time_Str = sprintf('%.2f,',time);
    incre_time_Str = ['[' , incre_time_Str , ']'];
    incre_time_Str = strrep(incre_time_Str, ',]', ']');
    
    incre_amp_Str = sprintf('%.5f,',amp);
    incre_amp_Str = ['[' , incre_amp_Str , ']'];
    incre_amp_Str = strrep(incre_amp_Str, ',]', ']');
    
    incre_freq_Str = sprintf('%.2f,',freqId);
    incre_freq_Str = ['[' , incre_freq_Str , ']'];
    incre_freq_Str = strrep(incre_freq_Str, ',]', ']');
    
    incre_psd_Str = sprintf('%.7f,',psd);
    incre_psd_Str = ['[' , incre_psd_Str , ']'];
    incre_psd_Str = strrep(incre_psd_Str, ',]', ']');
    
    output = '{\"amp\":AMPINFO, \"freq\":FREQ, \"psd\":PSD, \"time\":TIMEINFO, \"brate\":BRATE}';
    output = strrep(output, 'AMPINFO', incre_amp_Str);
    output = strrep(output, 'FREQ', incre_freq_Str);
    output = strrep(output, 'PSD', incre_psd_Str);
    output = strrep(output, 'TIMEINFO', incre_time_Str);
    output = strrep( output, 'BRATE', sprintf('"%.0f"',brate));
    
    system(['python C:\Users\czxlesh\Desktop\lab\BreathDemo\save2DB.py ', '"', output, '"'] );
end