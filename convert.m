function [table_time] = convert()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
table_time = readtimetable('DataSetIntervals.csv');
table_time(1:5,:)
table_time
end

