function text = comment_input(window, prompt)
   
   % keep adding lines until OK
   OK = 0;
   text = cell(0);
   text_idx = 1;
   Screen('TextSize',window,20);
   
   line_height = 40;
   
   % possibly subscribe to event scan list 4-29, 40, 42, 44, 88
   
    txt=1;

    [x,y,buttons]=GetMouse(window);
    while any(buttons)   %If the mouse is already clicked wait until it is unclicked
        [x,y,buttons]=GetMouse(window);
    end

    % this listens to the mouse very nicely, but does not allow typing

    FlushEvents('keyDown');
    [keyIsDown, ~, keyCode]=KbCheck;
    removeCode = zeros(1,256);
    flushed = 0;
    
    while ~any(buttons) && ~OK
        [x,y, buttons]=GetMouse(window);
        OK = drawOKMouse(window, x, y);
        if OK
            if ~any(buttons)
                OK=0;
            end
        end

        DrawFormattedText(window,  prompt, 100, 100, [0 0 0]);

        for i=1:text_idx
            if size(text,2) >= i
               
                if size(text{i},2) > 0
                    DrawFormattedText(window,  text{i}, 100, i*line_height +100, [0 0 0]);
                end
            end
        end

        Screen('Flip', window );

        % listen to the keyboard

        if keyIsDown %&& ~isempty(find(keyCode))           
            
            strName =  KbName(keyCode);
   
            
            for j = 1:size(strName,1)
                
                if iscell(strName)
                    name = strName{j};
                else
                    % if it is not cell it is probabaly just a string
                    name = strName;
                end
                
                if size(name,2) == 1
                    text{text_idx}(txt) = name;
                    txt = txt+1;
                elseif strcmp(name, ',<')
                    text{text_idx}(txt) = ',';
                    txt = txt+1;
                elseif strcmp(name, '.>')
                    text{text_idx}(txt) = '.';
                    txt = txt+1;
                elseif strcmp(name, '1!')
                    text{text_idx}(txt) = '!';
                    txt = txt+1;
                elseif strcmp(name, 'Return')  
                    
                    text_idx = text_idx+1;
                    txt=1;
                    %fprintf('incrementing line...\n\n');
                elseif strcmp(name, 'DELETE') || strcmp(name, 'KeypadBackspace') 
                    
                    %fprintf('Deleting... %s', text{text_idx} );
                    
                    if txt>1
                        text{text_idx}(txt-1) = ' ';
                        txt=txt-1;
                    end
                    
                    %fprintf(' becomes %s\n', text{text_idx});
                else
                    text{text_idx}(txt) = ' ';
                    txt = txt+1;
                end
            end
        end
         
        
        FlushEvents('keyDown');
        [keyIsDown,~,keyCodeNext]=KbCheck;
        c = 1;
        
        if flushed 
            keyCode = zeros(1,256);
        end
        
        while keyIsDown && c < 100
            
            c=  c+1;
            
            ik = find(keyCode); 
            if (size(ik,1) > size(ik,2))
                ik = ik';
            end
            
            ikn = find(keyCodeNext);
            if (size(ikn,1) > size(ikn,2))
                ik = ik';
            end
            
            sizethis = size(ik,2);
            sizenext = size(ikn,2);

           % fprintf('this size %d; next %d\n', sizethis, sizenext);
            flushed = 0;
            
            if sizenext <= 1 && sizethis <=1
                if find(keyCode)==find(keyCodeNext)
                    
                    [keyIsDown,~,keyCodeNext]=KbCheck; % wait
                    if isempty(find(keyCodeNext))
                        flushed = 1;
                        removeCode = zeros(1,256);
                        break;
                    end
                else
                    keyCode = keyCodeNext;
                    break;
                end
                
            else
                if (size(find(keyCodeNext),2) == 2) && size(find(keyCode),2) == 1
                    if isempty(find(removeCode))
                        removeCode = keyCode;
                    end
                    keyCodeNext = and(xor(keyCodeNext,removeCode), not(removeCode));
                else
                    % other cases are too hard to handle
                    [keyIsDown,~,keyCodeNext]=KbCheck;
                    keyCode = keyCodeNext;
                end
            end
        end

        
    end

    while any(buttons)  %again, wait until the mouse is unclicked 
        [x,y,buttons]=GetMouse(window);
    end 
               
   %text = inputdlg(prompt, 'Comments', 5);
end