function [keyCode] = readKeyboardBufferAndFlushAllKeys(ikeyCode, keyCode_input)
    flush = 0;
    keyCode = keyCode_input;
    
    while ~flush

           [ keyIsDown, t, k ] = KbCheck([]);
           ik = find(k);      % what is the next key on the buffer?

           if isempty(ik)
                flush = 1;    % if there is nothing then the buffer is flushed
           else
                if k(KbName('ESCAPE'))
                  %flush = 1;    % if there is ESC terminate whatever we are doing
                  keyCode = k;  % override the key
                elseif ik ~= ikeyCode
                  flush = 1;  % if it is a key we have not seen before
                end
           end
    end
   
end