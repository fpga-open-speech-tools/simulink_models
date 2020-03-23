%% Conversion Error Code
% Hezekiah Austin
% Last Modification: 2020-03-09

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
number_tests = 100000;

% Number of points in the vector
number_points = 1000;

% Matrix of doubles with random magitudes
doubles = rand(number_points, number_tests);

% Matrix of singles converted from the doubles matrix
singles = single(doubles);

% Matrix with the error between the doubles and singles
% Matrix is sorted based on the size of the element
conversion_error = sort(abs(minus(doubles, singles)));

% Returns the norm of the matrix
norm_error = norm(conversion_error)

% Returns the max value in a matrix
max_error = max(max(conversion_error))

% Plot the matrix to see the results
figure()
stem(conversion_error);
grid on;
title({'Conversion Error from Double to Single';['Number of Tests = ' num2str(number_tests), ' Length of Inputs = ' num2str(number_points)]})
ylabel('Absolute Error from Conversion');
xlabel('Samples Sorted by Amplitude');
