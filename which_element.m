% finds the last location of element in vector

function sorszam = which_element(element, vector)

sorszam = 0;
for i = 1: length(vector)
    if element == vector(i)
        sorszam = i;
    end
end
