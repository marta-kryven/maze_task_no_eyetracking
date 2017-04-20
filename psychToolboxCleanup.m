function psychToolboxCleanup(oldVisualDebugLevel, oldSupressAllWarnings)
    Screen('CloseAll');
    ShowCursor;
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
end