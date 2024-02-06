close all
clear all
clc

EV_length = 4.5; % Length of ego vehicle [m]
LV_length = 4.1; % Length of lead vehicle [m]
EV_Distance_Cog_Ls = 1.9; % Distance between center of gravity and leading surface of vehicle for ego vehicle [m]
LV_Distance_Cog_Ls = 1.7; % Distance between center of gravity and leading surface of vehicle for ego vehicle [m]
load('Data_DSS.mat');

% Calculation of variables

Index_start_event = find(cell2mat(Data_DSS(2:4542,4)) == 4);
Start_event = Index_start_event(1)+1;
Index_response_time = find(cell2mat(Data_DSS(2:4542,3)) == 1);
   
    for i = 1:length(Index_response_time)
        
        if (Index_response_time(i)) > Start_event
            
            Response_start = Index_response_time(i) + 1;
           
            break
          
        end
       
    end

