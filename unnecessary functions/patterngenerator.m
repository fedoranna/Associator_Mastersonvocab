function P = patterngenerator(P)

meret = [numel(P.inputvalues), numel(P.inputvalues)];
radius = P.inp_pattern_radius;
neighborhood = P.inp_pattern_neigh;

if strcmp(P.inp_pattern, 'diagonal')
    
    direction = P.inp_param;
    matrix = zeros(meret);
    
    % left diagonal
    for i = 1:nrows(matrix)
        for j = 1:ncols(matrix)
            if i == j
                matrix(i,j) = 1;
            end
            if P.size_O == 3 % the upper trianngle = 3
                if i < j
                    matrix(i,j) = 2;
                end
            end
        end
    end
    
    % right diagonal
    if strcmp(direction, 'right') % mirror
        mirrored = matrix;
        for i = 1:nrows(matrix)
            for j = 1:ncols(matrix)
                mirrored(i, end-(j-1)) = matrix(i,j);
            end
        end
        matrix = mirrored;
    end
    
    matrix2 = spreading_diag(matrix, radius, neighborhood);
    
end

if strcmp(P.inp_pattern, 'islands')
    
    darab = P.inp_param;
    matrix = zeros(meret);
    
    chosen = randchoose(1:numel(matrix), darab);
    if P.size_O == 2
        matrix(chosen) = 1;
    end
    if P.size_O == 3
        half = round(darab/2);
        matrix(chosen(1:half)) = 1;
        matrix(chosen(half+1:end)) = 2;
    end
    
    matrix2 = spreading_islands(matrix, radius, neighborhood);
    
end

if strcmp(P.inp_pattern, 'frompic')
    
    file = [P.folder, num2str(P.inp_param), '.png'];
    pic = imread(file);  
    
    if numel(pic(:,:,1)) ~= numel(P.inputvalues)*numel(P.inputvalues)
        f = warndlg(['Resolution of picture and input values does not match! Change the input range or bin so that resolution = ', num2str(numel(pic(:,1,1))), '!'], 'Warning!');
        waitfor(f);
        prompt = {'Enter input range lower limit:','Enter input range upper limit:','Enter input bin:'};
        dlg_title = 'Change values';
        num_lines = 1;
        default = {num2str(P.inputrange(1)), num2str(P.inputrange(2)), num2str(P.inputbin)};
        answer = inputdlg(prompt, dlg_title, num_lines, default);
        P.inputrange(1) = str2num(answer{1});
        P.inputrange(2) = str2num(answer{2});
        P.inputbin = str2num(answer{3});    
        P.inputvalues = P.inputrange(1) : P.inputbin : P.inputrange(2);
        meret = [numel(P.inputvalues), numel(P.inputvalues)];
    end
    
    matrix = zeros(meret);
    for i = 1:numel(matrix)
        if pic(i)==63 && pic(numel(matrix)+i)==72 && pic(numel(matrix)*2+i)==204 % blue
            matrix(i) = 0;
        elseif pic(i)==34 && pic(numel(matrix)+i)==177 && pic(numel(matrix)*2+i)==76 % green
            matrix(i) = 1;
        elseif pic(i)==237 && pic(numel(matrix)+i)==28 && pic(numel(matrix)*2+i)==36 % red
            matrix(i) = 2;
        end
    end
    
    matrix2 = matrix;
    
end

P.testingmatrix = matrix2;
