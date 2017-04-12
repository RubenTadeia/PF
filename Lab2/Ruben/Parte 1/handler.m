function [] = handler( user_input )
% handler Function
% This function receives the number that the user 

fprintf('\n' );

switch(user_input) 
    
    case 1 % Part 1 - Fundamental Frequency Estimation
      clc
      fprintf('Part 1 - Fundamental Frequency Estimation\n');
      
      
      clc
  
   case 2 % Part 2 - Linear Prediction using Octave/Matlab   
       clc
      fprintf('Part 2 - Linear Prediction using Octave/Matlab\n');
      clc
   case 3 % Part 3 - Vocoder Simulation
      clc
      fprintf('Part 3 - Vocoder Simulation\n');
      clc
   case 4 % Exit Program
      fprintf('Welcome come again! :)\n');
      clc
    otherwise
      fprintf('Please insert a valid option!\n');
      clc
end

end

