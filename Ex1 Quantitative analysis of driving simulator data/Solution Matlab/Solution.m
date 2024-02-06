close all
clear all
clc

EV_length = 4.5; % Length of ego vehicle [m]
LV_length = 4.1; % Length of lead vehicle [m]
EV_Distance_Cog_Ls = 1.9; % Distance between center of gravity and leading surface of vehicle for ego vehicle [m]
LV_Distance_Cog_Ls = 1.7; % Distance between center of gravity and leading surface of vehicle for ego vehicle [m]
load('C:\Users\fgiulio\OneDrive - Chalmers\Documents\PhD course\Driver behaviour course\IDEA League\2022\Exercises\Exercise 1\MATLAB\Data_DSS');  

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

Perception_Response_time = cell2mat(Data_DSS(Response_start)) - cell2mat(Data_DSS(Start_event)); %[s]
Distance_gap = cell2mat(Data_DSS(2:4542,6)) - EV_Distance_Cog_Ls - (LV_length - LV_Distance_Cog_Ls); %[m]

figure(1)
plot(Distance_gap)
grid on


Time_gap = Distance_gap./cell2mat(Data_DSS(2:4542,2)); %[s]

figure(2)
plot(Time_gap)
grid on

Distance_headway_front_front = cell2mat(Data_DSS(2:4542,6)) - EV_Distance_Cog_Ls + LV_Distance_Cog_Ls; %[m]

figure(1)
hold on
plot(Distance_headway_front_front, 'r')
grid on

Time_headway_front_front = Distance_headway_front_front./cell2mat(Data_DSS(2:4542,2));

figure(2)
hold on
plot(Time_headway_front_front, 'k')
grid on

Time_to_collision = Distance_gap./(cell2mat(Data_DSS(2:4542,2))-cell2mat(Data_DSS(2:4542,5)));

figure(3)
plot(Time_to_collision)
 