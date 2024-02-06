% Exercise: 100car Naturalistic data analysis
% Contact: Alexander Rasch - alexander.rasch@chalmers.se
%          Pierluigi Olleja - pierluigi.olleja@chalmers.se
% Author: Marco Dozza - marco.dozza@chalmers.se
% Date: September 2022
% Institution: Chalmers
% Course: IDEA League summer school (Analysis and modelling road user behaviour)

% Odds ration CI from Agresti according to odds ratio=(n11*n22)/(n12*n21)
%
% n11 = A
% n12 = B
% n21 = C
% n22 = D

function [CI95,OR,CI90] = getOddsRatioCI(contingencytable)

contingencytable = table2array(contingencytable);

n11 = contingencytable(1, 1);
n12 = contingencytable(1, 2);
n21 = contingencytable(2, 1);
n22 = contingencytable(2, 2);

OR = (n11*n22)/(n12*n21);
% standard error for logs odds ratio

SE = (1/n11+1/n22+1/n12+1/n21)^(1/2);

% (1 - alfa)*100 CI 

p = normcdf([-1.96 1.96]);

% alfa =0.05
alfa = p(2)-p(1);

CI95(1)=exp(log(OR)-1.96*SE);
CI95(2)=exp(log(OR)+1.96*SE);

%90% CI
p = normcdf([-1.645 1.645]);

% alfa =0.1
alfa = p(2)-p(1);

CI90(1)=exp(log(OR)-1.645*SE);
CI90(2)=exp(log(OR)+1.645*SE);