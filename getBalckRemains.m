function blackremains = getBalckRemains(visible)
    blackremains = 0;
        for i = 1:size(visible,2)
            for j = 1:size(visible,1)
                if ~visible(j,i)
                    blackremains = blackremains+1;
                end
            end
        end
end