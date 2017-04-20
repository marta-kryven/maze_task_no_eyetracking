% the keybuffer will have repeated entries for the key for as long as it
% was held down; 
% we only want to know which key was pressed first
% ESCAPE has priority - if ESC was pressed even once then exit the loop
%
% scanList - a list of keys to look for, we do not care if any otehr keys were
% pessed
%

function [keyCode] = readKeyboardBufferAndFlush(scanList, ikeyCode, keyCode_input)
    keyCode = keyCode_input;
    flush = 0;
    escapeKey = KbName('ESCAPE');
                       
    while ~flush
       [ keyIsDown, t, k ] = KbCheck([], scanList);
       ik = find(k);

       if ~isempty(ik)
            %fprintf('read key %d\n', ik);
            if k(escapeKey)
              flush = 1;
              keyCode = k;
            elseif ik ~= ikeyCode
                flush = 1;
                %fprintf('read a different key %d\n', ik, ikeyCode);
            end
       else
            flush = 1;
       end
    end
   
end