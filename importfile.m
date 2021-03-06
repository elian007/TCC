function [dataByColumn1] = importfile(fileToRead1)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

%  Auto-generated by MATLAB on 29-Oct-2019 02:06:22

% Import the file
newData1 = importdata(fileToRead1);

% Break the data up into a new structure with one field per column.
colheaders = matlab.lang.makeUniqueStrings(matlab.lang.makeValidName(newData1.colheaders), {}, namelengthmax);
len = size(colheaders,2);
for i = 1:len
    dataByColumn1.(colheaders{1,i}) = newData1.data(:, i);
end

