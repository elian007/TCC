function [tableTime] = calculateTimeInterval_(sampleSize,initialTable, valorQ)
%% Calculate Source Port
%   Function receives a table and a sample size, thereby selects the
%   relevant data.

%% Adjust sample
sampleSize = duration(sampleSize, 'Format', 'hh:mm:ss');

horario = datetime(initialTable.Timestamp,'InputFormat','yyyy-MM-dd HH:mm:ss.SSS');

a = horario(1);


%% Add 12 hours
% find the wrong time indexes
k = find(initialTable.Timestamp.Hour >= 1 & initialTable.Timestamp.Hour < 7);

initialTable.Timestamp(k) = initialTable.Timestamp(k) + hours(12);

%% Sort the table
initialTable = sortrows(initialTable,'Timestamp','ascend');
%% From the first timestamp sets the duration
initialTable.Timestamp = initialTable.Timestamp - initialTable.Timestamp(1);

%% Add one minute in all timestamps
initialTable.Timestamp = initialTable.Timestamp + minutes(1);


t1 = duration('00:07:00', 'Format', 'hh:mm:ss');
t2 = sampleSize;


tf = initialTable.Timestamp(height(initialTable)) + minutes(1);

tf
%% Set table settings
i=1;
N=round(minutes(tf)/minutes(sampleSize))+1
tableTime = table;

tableTime.Timestamp = cell(N,1);
%tableTime.SourcePort = cell(N,1);
tableTime.SourceIP = cell(N,1);
%tableTime.DestinationPort = cell(N,1);
%tableTime.DestinationIP  = cell(N,1);
% tableTime.FlowBytess = cell(N,1);
% tableTime.FlowPacketss = cell(N,1);
count = 0;



while tf>t2
    k = find(initialTable.Timestamp > t1 & initialTable.Timestamp <= t2); 
    t1 = t2;
    t2 = t2 + sampleSize;
   
    if k ~= 0
        tableTime.Timestamp{i, :} = a;
        %tableTime.SourcePort{i, :} = TsallisEntropy(initialTable.SourcePort(k, :), valorQ);
        tableTime.SourceIP{i, :} = TsallisEntropy(initialTable.SourceIP(k, :), valorQ);
        %tableTime.DestinationPort{i, :} = TsallisEntropy(initialTable.DestinationPort(k, :), valorQ);
        %tableTime.DestinationIP{i, :} = TsallisEntropy(initialTable.DestinationIP(k, :), valorQ);
        %tableTime.FlowBytess{i, :} = mean(initialTable.FlowBytess(k, :), 'omitnan'); 
        %tableTime.FlowPacketss{i,:} = mean(initialTable.FlowPacketss(k, :), 'omitnan');
        count = count + 1;
        i = i+1;
        a = a + minutes(7);
       
    end
    
end

writetable (tableTime, 'DataSetIntervals.csv');


end