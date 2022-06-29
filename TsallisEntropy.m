function [entropy] = TsallisEntropy(data, valorQ)
%% ENTROPY
%   Function calculates Tsallis entropy
if isa(data,'categorical')
    filler = '-1';
else
    filler = -1;
end

sizeData = length(data);
uniqueValues = unique(data);
sizeUnique = length(uniqueValues);

for i=1:(sizeData - sizeUnique)
    uniqueValues(sizeUnique + i) = filler;
end

uniqueValues = sort(uniqueValues);
q = valorQ;
P = hist(data, uniqueValues);
P = P/sizeData;

entropy = (1-sum((P).^q))/(q-1);


end

