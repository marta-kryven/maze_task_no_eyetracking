function [ movies ] = loadAllMaps( s )
% Load all files from this directory into a movie array
% do not load the system file called DS_Store

  fprintf(s);
  fprintf('\n');
  fileList = getAllFiles(s);
  ptrials = size(fileList,1);
  numMovies = 0;
  
  for i=1:ptrials
      
      if size(strfind(fileList{i}, '.DS_Store')) == 0
          numMovies = numMovies + 1;
      end
  end
  
  movies = cell(numMovies,1);
  movieIndex = 1;
  
  for i=1:ptrials
      fprintf(fileList{i});
      fprintf('\n');
      if size(strfind(fileList{i}, '.DS_Store')) > 0
          fprintf('skipping %s\n', fileList{i}); 
      else
          movies{movieIndex} = fileList{i};
          movieIndex = movieIndex + 1;
      end
  end


end

