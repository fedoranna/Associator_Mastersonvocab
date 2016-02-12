function newmatrix = itemselector5(P, whatset)

%% Parameters

if strcmp(whatset, 'train')
    oldmatrix = P.testingmatrix;
    method = P.train_selectionmethod; 
    toselect = P.train_selected;
    inorout = P.train_inorout;
end

if strcmp(whatset, 'int')
    oldmatrix = P.testingmatrix;
    method = P.int_selectionmethod;
    toselect = P.int_selected;
    addornew = P.int_addornew;
end

%% Select items

numval = numel(P.inputvalues);
darab = round(numval*numval * toselect/100); % number of items to be included/excluded

if strcmp(method, 'random')
    selected = randchoose(1:numval*numval, darab);     
end

if strcmp(method, 'gui')    
        f = warndlg(['Click on ' num2str(darab), ' items!'], 'User input needed');
        waitfor(f);
        plotmatrix4(oldmatrix, 1:ncols(oldmatrix), 1:nrows(oldmatrix));
        title('Target activations')
        xlabel('Input 1')
        ylabel('Input 2')
        [x,y] = ginput(darab);
        close
        x = floor(x);
        y = floor(y);
        selected = coordinates2indices(x,y, numel(P.inputvalues), numel(P.inputvalues));
end

if strcmp(method, 'preselected')
    selected = toselect;       
end

if strcmp(method, 'frompic')
    
    file = [P.folder, toselect, '.png'];
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
    
    selected = [];
    for i=1:numel(matrix)
        if isnan(matrix(i)) == 0
            selected = [selected, i];
        end
    end
end

%%

chosen = selected;

if strcmp(whatset, 'train')
    if strcmp(inorout, 'in')     
        newmatrix = NaN(size(oldmatrix));
        newmatrix(chosen) = oldmatrix(chosen);
    end
    if strcmp(inorout, 'out')
        newmatrix = oldmatrix;
        newmatrix(chosen) = NaN;
    end      
end

if strcmp(whatset, 'int')
    if strcmp(addornew, 'add')     
        newmatrix = P.trainingmatrix_before;
        newmatrix(chosen) = P.testingmatrix(chosen);
    end
    if strcmp(addornew, 'new')
        newmatrix = NaN(size(P.trainingmatrix_before));
        newmatrix(chosen) = P.testingmatrix(chosen);
    end      
end

