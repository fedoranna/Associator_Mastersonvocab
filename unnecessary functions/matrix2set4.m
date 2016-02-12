%% Generates a training or testing set from a pattern matrix
% matrix should contain 0,1,2 values
% 0=blue, 1=green, 2=red
% Output neurons: A learns 0 (blue); B learns 1 (green), C learns red (2)
% set will have as many rows as many elements in the matrix
% set(i, 1) = y input value
% set(i, 2) = x input value in a coordinate system
% set(i, 3) = output of A neuron (blue)
% set(i, 4) = output of B neuron (green)
% set(i, 5) = output of C neuron (red)

function set = matrix2set4(matrix, values, outputs)

matrix = flipit(matrix);
if outputs == 2
    set = NaN(numel(matrix), 4);
    k = 0;
    for j = 1:ncols(matrix)
        for i = 1:nrows(matrix)
            k = k+1;
            set(k, 1) = values(i);
            set(k, 2) = values(j);
            set(k, 3) = matrix(i,j);
            set(k, 4) = abs(set(k, 3) - 1);
        end
    end
end

if outputs == 3
    set = zeros(numel(matrix), 5);
    k = 0;
    for j = 1:ncols(matrix)
        for i = 1:nrows(matrix)
            k = k+1;
            set(k, 1) = values(i);
            set(k, 2) = values(j);
            if isnan(matrix(i,j))
                set(k, 3:5) = NaN;
            else                
                set(k, 2+matrix(i,j)+1) = 1;
            end
        end
    end    
end



    