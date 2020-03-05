%% Conversion Error Code
% Hezekiah Austin
% Last Modification: 2020-02-24
% Parts to work on are marked with ???

% Purpose
% This code is to create a reference point to compare the conversion error
% of the Simulink Singles vs Simulink Doubles vs a standard singles to
% doubles conversion of a vector in MATLAB


%% Code

% Clear out everything
clear all;
close all;
clc;


% Generate and test one million 1000 point vectors

% Number of test vectors
number_tests = 1000000;

% Number of points in the vector
number_points = 1000;

% Matrix of doubles with random magitudes
doubles = rand(number_tests, number_points);

% Matrix of singles converted from the doubles matrix
singles = single(doubles);

% Matrix with the error between the doubles and singles
conversion_error = minus(doubles, singles);
norm_error = norm(conversion_error);

% Plot the matrix to see the results
figure()
plotmatrix(conversion_error);