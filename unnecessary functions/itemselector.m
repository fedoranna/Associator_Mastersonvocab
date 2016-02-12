function newmatrix = itemselector(P)

oldmatrix = P.testingmatrix;
method = P.selectionmethod; 
selected = P.selected;
inorout = P.inorout;

darab = round(numel(oldmatrix) * selected/100); % number of items to be included/excluded

if strcmp(method, 'random')
    chosen = randchoose(1:numel(oldmatrix), darab);
    if inorout == 1      
        newmatrix = NaN(size(oldmatrix));
        newmatrix(chosen) = oldmatrix(chosen);
    end
    if inorout == 0
        newmatrix = oldmatrix;
        newmatrix(chosen) = NaN;
    end        
end

if strcmp(method, 'gui')
    if inorout == 1
        f = warndlg(['Click on ' num2str(darab), ' items that should be included in the training set!'], 'User input needed');
        waitfor(f);
        plotmatrix(oldmatrix, 1:ncols(oldmatrix), 1:nrows(oldmatrix));
        title('Target activations')
        xlabel('Input 1')
        ylabel('Input 2')
        [x,y] = ginput(darab);
        close
        x = floor(x);
        y = floor(y);
        newmatrix = NaN(size(oldmatrix));
        for i = 1:darab
            newmatrix(y(i), x(i)) = oldmatrix(y(i), x(i));
        end
    end
    if inorout == 0
        f = warndlg(['Click on ' num2str(darab), ' items that should be excluded from the training set!'], 'User input needed');
        waitfor(f);
        plotmatrix(oldmatrix, 1:ncols(oldmatrix), 1:nrows(oldmatrix));
        title('Target activations')
        xlabel('Input 1')
        ylabel('Input 2')
        [x,y] = ginput(darab);
        close
        x = floor(x);
        y = floor(y);
        newmatrix = oldmatrix;
        for i = 1:darab
            newmatrix(y(i), x(i)) = NaN;
        end
    end
end

if strcmp(method, 'preselected')
    if inorout == 1
        newmatrix = NaN(size(oldmatrix));
        newmatrix(selected) = oldmatrix(selected);
    end
    if inorout == 0
        newmatrix = oldmatrix;
        newmatrix(selected) = NaN;
    end        
end

if strcmp(method, 'check')
    for i = 1:nrows(newmatrix)
        for j = 1:ncols(newmatrix)
            if gcd(i, 2) == 1 && gcd(j, 2) == 1
                newmatrix(i, j) = NaN;
            end
            if gcd(i, 2) == 2 && gcd(j, 2) == 2
                newmatrix(i, j) = NaN;
            end            
        end
    end
end

if strcmp(method, 'corners')
    perc = selected(2);
    darab = round(nrows(oldmatrix)*perc/100);
    TL = []; % top left corner
    for i = 1:darab
        TL = [TL, ((i-1)*nrows(oldmatrix) + 1) : ((i-1)*nrows(oldmatrix) + 1) + darab-(i-1)-1];
    end
    BR = numel(oldmatrix)-TL+1; % bottom right corner
    
    if selected(1) == 1
        chosen = TL;
    elseif selected(1) == 2
        chosen = BR;
    elseif selected(1) == 3
        chosen = [TL, BR];
    end
    
    if inorout == 1      
        newmatrix = NaN(size(oldmatrix));
        newmatrix(chosen) = oldmatrix(chosen);
    end
    if inorout == 0
        newmatrix = oldmatrix;
        newmatrix(chosen) = NaN;
    end     
end

if strcmp(method, 'fromfile')
    
    file = [P.folder, selected, '.png'];
    pic = imread(file);

    matrix = NaN(size(pic, 1), size(pic, 2));
    for i = 1:numel(matrix)
        if pic(i)==63 && pic(numel(matrix)+i)==72 && pic(numel(matrix)*2+i)==204 % blue
            matrix(i) = 0;
        elseif pic(i)==34 && pic(numel(matrix)+i)==177 && pic(numel(matrix)*2+i)==76 % green
            matrix(i) = 1;
        elseif pic(i)==237 && pic(numel(matrix)+i)==28 && pic(numel(matrix)*2+i)==36 % red
            matrix(i) = 2;
        end
    end
    newmatrix = matrix;
end



