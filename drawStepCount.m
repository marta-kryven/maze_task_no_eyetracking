function drawStepCount(trial_type, steps, window, offy, next_map_index, number_of_test_trials, ...
    number_of_prior_trials,  total_trials)
      if trial_type == 0
        stepStr=sprintf('Please use arrow keys to move. [Demo] Steps: %d', steps);
      elseif trial_type == 1
        stepStr=sprintf('Please use arrow keys to move. [Practice] Steps: %d', steps);
      else
        stepStr=sprintf('Please use arrow keys to move. [%d out of %d] Steps: %d', ...
            number_of_prior_trials+next_map_index, total_trials, steps);
      end
      DrawFormattedText( window, stepStr, 'center', offy-60, [255,0,0]);
      
      if trial_type <2 && next_map_index == 4
          DrawFormattedText( window, 'Please notice how the rooms open as you approach.', 'center', offy-30, [255,0,0]);
      end
end