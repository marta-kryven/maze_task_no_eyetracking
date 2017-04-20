
function [ gridworld, worldw, worldh ] = readWorld( s )

  %fprintf('reading world %s\n', s);
  f =  textread(s, '%s');
  
  worldw = str2num(f{1}); 
  worldh = str2num(f{2}); 

  gridworld = zeros(worldh, worldw);

  for i = 3:size(f,1) 
    
     line = f{i};
     %fprintf('line %d, %s\n', i, line); 
     for j = 1:size(line,2)
        c = str2num(line(j));
       gridworld(i-2,j) = c;
     end
  end
end