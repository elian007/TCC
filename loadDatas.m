
%% Initialize variables.
filename = 'E:\TCC\TCC2\DatasetEditado\Friday-WorkingHours-Morning.pcap_ISCX.csv';
delimiter = ';';
startRow = 2;
 endRow = 529919;
%endRow = 100000;
%% Read columns of data as text:
formatSpec = '%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,4,6,7]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using the
% specified date format.
try
%     dates{5} = datetime(dataArray{5}, 'Format', 'MM/dd/yyyy HH:mm', 'InputFormat', 'MM/dd/yyyy HH:mm');
    dates{5} = datetime(dataArray{5}, 'Format', 'dd/MM/uuuu HH:mm', 'InputFormat', 'dd/MM/uuuu HH:mm');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{5} = cellfun(@(x) x(2:end-1), dataArray{5}, 'UniformOutput', false);
%         dates{5} = datetime(dataArray{5}, 'Format', 'MM/dd/yyyy HH:mm', 'InputFormat', 'MM/dd/yyyy HH:mm');
         dates{5} = datetime(dataArray{5}, 'Format', 'dd/MM/uuuu HH:mm', 'InputFormat', 'dd/MM/uuuu HH:mm');
    catch
        dates{5} = repmat(datetime([NaN NaN NaN]), size(dataArray{5}));
    end
end

dates = dates(:,5);

%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [2,4,6,7]);
rawStringColumns = string(raw(:, [1,3,8]));


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
for catIdx = [1,2,3]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% Create output variable
tableDatas = table;
tableDatas.Timestamp = dates{:, 1};
tableDatas.SourceIP = categorical(rawStringColumns(:, 1));
tableDatas.SourcePort = cell2mat(rawNumericColumns(:, 1));
tableDatas.DestinationIP = categorical(rawStringColumns(:, 2));
tableDatas.DestinationPort = cell2mat(rawNumericColumns(:, 2));
tableDatas.FlowBytess = cell2mat(rawNumericColumns(:, 3));
tableDatas.FlowPacketss = cell2mat(rawNumericColumns(:, 4));
tableDatas.Label = categorical(rawStringColumns(:, 3));
% tableDatas.SerieTemporal = dates{:, 1};

% writetable (tableDatas, 'loadDatas.csv');
% 
% tableDatas = readtimetable('loadDatas.csv');
% tableDatas(1:999,:)

% %% Add dummyvar 
%tableDatas.AdaptLabel = dummyvar(tableDatas.Label);

%% Clear temporary variables
clearvars filename delimiter startRow endRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp dates blankDates anyBlankDates invalidDates anyInvalidDates rawNumericColumns rawStringColumns R catIdx idx;