% Exercise: 100car Naturalistic data analysis
% Contact: Alexander Rasch - alexander.rasch@chalmers.se
%          Pierluigi Olleja - pierluigi.olleja@chalmers.se
% Author: Alberto Morando - alberto.morando@chalmers.se
%         Alexander Rasch - alexander.rasch@chalmers.se
%         Marco Dozza - marco.dozza@chalmers.se
% Date: September 2022
% Institution: Chalmers
% Course: IDEA League summer school (Analysis and modelling road user behaviour)

close all
clear all
clc

%% --- Task 1 ---
% For this first task you do NOT need to write any code or text.
% You need, instead, to use the SAFER100car software (including the documentation), and the 100car's dictionaries.
%
% Follow the steps below:
% 1) Start the SAFER100car GUI in Matlab: execute the file 'SAFER100car.m'
% 2) Load a 'crash' event
% 3) Plot the speed signal (and check its quality)
% 4) Read the narrative of the event
% 5) Explore and understand the video annotations (more info in the dictionaries)
% 6) Explore and understand the glance behavior (more info in the dictionaries)
% 7) Can you make a story? For example: What was the event's contributing factor? Was the driver distracted? Were there other vehicles involved in the event?
% 8) Repeat for some more events, including near-crashes.

%% The follwing tasks require to complete the script. We used [] as placeholder for the commands to be completed.

%% --- Task 2 ---
% This task is about understanding the relation between crash severity and
% distracting activities. 

% Load 'Event.mat'. When the data is loaded, the variable "Event", which includes 
% the information on all events in the 100car dataset is available in the workspace.
load('Event.mat');

% Count "Crashes" with "Talking/listening on cell phone" as _first_ distraction.
% Look at the dictionary "ResearcherDictionaryVideoReductionDatav1_1" to understand how to extract
% this information. You may also want to use the function 'strcmpi' to query the dataset.
Crashes_with_talking_on_cellphone = []

% Count "Crashes" without "Talking/listening on cell phone" as _first_ distraction.
Crashes_without_talking_on_cellphone = []

% Count "Near Crashes" with "Talking/listening on cell phone" use as _first_ distraction.
NearCrashes_with_talking_on_cellphone = []

% Count "Near Crashes" without "Talking/listening on cell phone" use as _first_ distraction.
NearCrashes_without_talking_on_cellphone = []

% Fill in the contingency table. You should oraganize the table as follow:
% +-------------------------------------+---------+--------------+
% |                                     | Crashes | Near-crashes |
% +-------------------------------------+---------+--------------+
% | Talking/listening on cell phone     | x       | x            |
% | Not Talking/listening on cell phone | x       | x            |
% +-------------------------------------+---------+--------------+

Contingency_table = table([], [], ...
    'RowNames', {'Talking/listening on cell phone', 'Not Talking/listening on cell phone'}, ...
     'VariableNames', {'Crashes', 'Near-crashes'})

% Calculate Odd ratios (ORs) and Confidence Intervals (CIs) (you may want to use the given function 'getOddsRatioCI.m')
[CI95, OR, ~] = getOddsRatioCI([]);

fprintf('-------------------------------------------\n')
fprintf('Odds ratio: %3.2f\n', OR)
fprintf('95%% Confidence interval: %3.2f -- %3.2f\n', CI95)
fprintf('-------------------------------------------\n')

% Interpret the results and discuss with your colleague.
% No code needed for this, simply write your conclusion here.

%% --- Task 3 ---
% Task 3 is similar to what you did in Task 2. However, here you decide
% what odds ratio to calculate. It can be another type of distracting 
% activity or another attribute of the event. Then, interpret the results 
% and discuss with your colleague. Write your discussion in this comment.

%% --- Task 4 ---
% This task is about understanding the relation between crash severity and
% glance behaviour. The code for solving this task is a bit more involved,
% because we need to inspect the glance time series for each event
% separately. Feel free to modify it to your needs.

Crashes_with_eyes_on_road = 0;
NearCrashes_with_eyes_on_road = 0;

Crashes_with_eyes_off_road = 0;
NearCrashes_with_eyes_off_road = 0;

% We loop through all the single events included in `Events`
for i = 1:numel(Event)
    
    % Extract the variable that defines the beginning of the `precipitating event`.
    % Look at the dictionary "ResearcherDictionaryVideoReductionDatav1_1"
    % to understand how to extract and interpret this information. 
    precipitating_event_start = [];
    
    % For each event, loop through the glances time-series...
    for j = 1 : numel(Event(i).Glance)
        
        % Identify the glance that include the beginning of the
        % precipitating event. You may want to use the variable `start` and
        % `stop` for each glance.
        if []
            
            % Check if the glance is valid. That is, exclude when the video
            % was not available
            if []
                
                % Check if the glance was on road (consult the glance 
                % dictionary to decide about the appropriate glance 
                % location variable name)
                if []
                    
                    % Count Crashes and Near-crashes with eyes on-road at precipitating event
                    if []
                        Crashes_with_eyes_on_road = Crashes_with_eyes_on_road + 1;
                    else
                        NearCrashes_with_eyes_on_road = NearCrashes_with_eyes_on_road + 1;
                    end
                else % The glance was not on road
                    
                    % Count Crashes and Near-crashes with eyes off-road at precipitating event
                    if []
                        Crashes_with_eyes_off_road = Crashes_with_eyes_off_road + 1;
                    else
                        NearCrashes_with_eyes_off_road = NearCrashes_with_eyes_off_road + 1;
                    end
                end
            end
        end
    end
end

% Fill in the contingency table. You should oraganize the table as follow:
% +---------------+---------+--------------+
% |               | Crashes | Near-crashes |
% +---------------+---------+--------------+
% | Eyes on-road  | x       | x            |
% | Eyes off-road | x       | x            |
% +---------------+---------+--------------+

Contingency_table = table([], [], ...
    'RowNames', {'Eyes on-road', 'Eyes off-road'}, ...
    'VariableNames', {'Crashes', 'Near-crashes'})

% Calculate Odd ratios (ORs) and Confidence Intervals (CIs)
[CI95, OR, CI90] = getOddsRatioCI([]);

fprintf('-------------------------------------------\n')
fprintf('Odds ratio: %3.2f\n', OR)
fprintf('95%% Confidence interval: %3.2f -- %3.2f\n', CI95)
fprintf('-------------------------------------------\n')

% Interpret the results
% No code needed for this, simply write your conclusion in a comment here.
