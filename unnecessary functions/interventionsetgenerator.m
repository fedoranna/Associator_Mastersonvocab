function newmatrix = interventionsetgenerator(P)

oldmatrix = P.trainingmatrix_before;
method = P.int_selectionmethod;
selected = P.int_selected;
create = P.int_method;

darab = round(numel(oldmatrix) * selected/100); % number of items to be included

if strcmp(method, 'random')
    chosen = randchoose(1:numel(oldmatrix), darab);
    if strcmp(create, 'add')
        newmatrix = P.trainingmatrix_before;
        newmatrix(chosen) = P.testingmatrix(chosen);
    end
    if strcmp(create, 'new')
        newmatrix = NaN(size(P.trainingmatrix_before));
        newmatrix(chosen) = P.testingmatrix(chosen);
    end
end

if strcmp(method, 'gui')
    if strcmp(create, 'add')
        f = warndlg(['Click on ' num2str(darab), ' items that should be added to the training set!'], 'User input needed');
        waitfor(f);
        plotmatrix(oldmatrix, 1:ncols(oldmatrix), 1:nrows(oldmatrix));
        title('Target activations')
        xlabel('Input 1')
        ylabel('Input 2')
        [x,y] = ginput(darab);
        close
        x = floor(x);
        y = floor(y);
        newmatrix = P.trainingmatrix_before;
        for i = 1:darab
            newmatrix(y(i), x(i)) = P.testingmatrix(y(i), x(i));
        end
    end
    if strcmp(create, 'new')
        f = warndlg(['Click on ' num2str(darab), ' items that should be in the intervention training set!'], 'User input needed');
        waitfor(f);
        plotmatrix(oldmatrix, 1:ncols(oldmatrix), 1:nrows(oldmatrix));
        title('Target activations')
        xlabel('Input 1')
        ylabel('Input 2')
        [x,y] = ginput(darab);
        close
        x = floor(x);
        y = floor(y);
        newmatrix = NaN(size(P.trainingmatrix_before));
        for i = 1:darab
            newmatrix(y(i), x(i)) = P.testingmatrix(y(i), x(i));
        end
    end
end

if strcmp(method, 'preselected')
    if strcmp(create, 'add')
        newmatrix = P.trainingmatrix_before;
        newmatrix(selected) = P.testingmatrix(selected);
    end
    if strcmp(create, 'new')
        newmatrix = NaN(size(P.trainingmatrix_before));
        newmatrix(selected) = P.testingmatrix(selected);
    end
end

if strcmp(method, 'frompic')
    picfile = [P.folder, num2str(P.int_selected), '.png'];
    pic = imread(picfile);    
    matrix = NaN(size(pic, 1), size(pic, 2));
    selected = [];
    
    for i = 1:numel(matrix)
        if pic(i)==255 && pic(numel(matrix)+i)==255 && pic(numel(matrix)*2+i)==255 % white
            matrix(i) = NaN;
        else
            selected = [selected, i]; 
        end
    end
    
    if strcmp(create, 'add')
        newmatrix = P.trainingmatrix_before;
        newmatrix(selected) = P.testingmatrix(selected);
    end
    if strcmp(create, 'new')
        newmatrix = NaN(size(P.trainingmatrix_before));
        newmatrix(selected) = P.testingmatrix(selected);
    end
end



