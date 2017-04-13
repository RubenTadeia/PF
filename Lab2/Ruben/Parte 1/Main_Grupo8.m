%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Instituto Superior Técnico          % 
%                                              %
%             Speech Processing                %
%                                              %
%               Laboratório - 2                %
%                                              %
%                  Grupo 8                     %
%                                              %
%      Student - José  Diogo    - Nº 75255     %
%      Student - Rúben Tadeia   - Nº 75268     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Welcome Menu
clear all; close all;clc

%Caminho Relativo da toolbox Voice Box
currentFolder = pwd;
voiceBoxPath = strcat(currentFolder,'\voiceBox\');

addpath(genpath(voiceBoxPath));
userOption = 0;

while(userOption ~= 4)
   
   disp('Welcome to the 2nd Laboratory');
   disp('Brought To You By Group 8');fprintf('\n');
   disp('Please insert a valid Option Number');fprintf('\n');
   disp('1 - Part 1 - Fundamental Frequency Estimation');
   disp('2 - Part 2 - Linear Prediction using Octave/Matlab');
   disp('3 - Part 3 - Vocoder Simulation');
   disp('4 - Exit Program!');fprintf('\n');
   
   userOption = input('Your Option - ');
   handler(userOption);
end
