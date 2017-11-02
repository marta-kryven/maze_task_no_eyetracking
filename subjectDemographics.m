
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Collect Subject Data                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
function subjectDemographics(fileIDSubject)
    
     prompt={'Birthday:', 'Gender:'};
     title= 'Participant';

     answer=inputdlg(prompt,title); % The main title of your input dialog interface.

     form = sprintf('Birthday:%s\nGender:%s\n', answer{1}, answer{2});
     fprintf(fileIDSubject, form);

end