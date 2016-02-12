% Checks whether a character is part of a string or a number is part of a matrix

function answer = is_partof(string, char)
x = sum(string == char);
if x>0
    answer = 1;
else answer = 0;
end
