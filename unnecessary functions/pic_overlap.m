clear
pic_int = 'islands3_7';
pic_base = 'islands3_1';
folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\4_intervention\';
addpath(genpath('C:\Matlab_functions'));

file_int = [folder, pic_int, '.png'];
file_base = [folder, pic_base, '.png'];

[comp_int, matrix_int] = pic_analyzator(file_int);
[comp_base, matrix_base] = pic_analyzator(file_base);

added = 0;
for i = 1:numel(matrix_base)
    if isnan(matrix_base(i)) && isnan(matrix_int(i))==0
        added = added+1;
    end
end
addedperc = (added/numel(matrix_base))*100;

[comp_int, addedperc]

