function [] = handler( user_input )
% handler Function
% This function receives the number that the user 

fprintf('\n' );

switch(user_input) 
    
    case 1 % Part 1 - Fundamental Frequency Estimation
      
      fprintf('Part 1 - Fundamental Frequency Estimation\n');
      %Lets do The first Question
      Question1;
      %Now we write the answer in the output file
      myAverage;
      
   case 2 % Part 2 - Linear Prediction using Octave/Matlab   
      
      fprintf('Part 2 - Linear Prediction using Octave/Matlab\n');
      
      
   case 3 % Part 3 - Vocoder Simulation
      
      fprintf('Part 3 - Vocoder Simulation\n');
      
      
   case 4 % Exit Program
      fprintf('Welcome come again! :)\n');
    otherwise
      fprintf('Please insert a valid option!\n');
end

end

