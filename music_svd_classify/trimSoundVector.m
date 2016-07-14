function [output] = trimSoundVector(input, fs, new_length, startInd, gate_start, gate_end)
% trims a vector by the length in seconds specified by new_length 
% (starting from 'start') and gates the trimmed ends to prevent popping
% takes new_length in seconds
% assumes a vector is passed

[m,n] = size(input);
assert(n == 1, 'trimSoundVector must be passed single column vector');

new_length = floor(new_length * fs); % convert to samples

%cut
input = input(startInd:end);

[rows, cols] = size(input);
if rows < new_length
    temp = zeros(new_length, 1); % add zeros to the end
    for k = 1:rows
        temp(k) = input(k);
    end
    output = temp;
else
    output = input(1:new_length); % truncate vector at row new_length
end

output = createGate(output, fs, gate_start, gate_end);
[rows, cols] = size(output);
assert((rows == new_length), 'error in trimletters: not all letters equal to new_length') 
end
