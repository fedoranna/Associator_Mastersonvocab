% Melyik structure-t hívják így?
% INPUT: structure array; a fieldname ahol keressük; és a field tartalma, amit keresünk
% fieldname must be a string
% OUTPUT: annak a structure-nek a sorszáma, aminél a megadott field-nél a
% keresett adat szerepel

function sorszam = which_struct(structarray, fieldname, content)

for i = 1:length(structarray)
    x = getfield(SA(i), FN);
    if isequal(x, content)
        sorszam =i;
    end
end