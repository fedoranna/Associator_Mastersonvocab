%% Script for making error surface plot based on IH weight and bias
% 2D input space
% Perceptron model should be run first if you want to plot the trajectory
% on the surface

clear
addpath(genpath('C:\Matlab_functions'))

folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\_symm\diag, perceptron\';

res = 0.1;
range = 10;
bin = 0.2;
LR = 0.1;

pattern = 1;
measure_toplot = 'error';

%     1. abs(error)
%     2. abs(delta)
%     3. incrW
%     4. incrB
%     5. scores (1:5: summed for the epoch)

%% IO

if strcmp(measure_toplot, 'error')
    toplot = 1;
end
if strcmp(measure_toplot, 'delta')
    toplot = 2;
end
if strcmp(measure_toplot, 'incrW')
    toplot = 3;
end
if strcmp(measure_toplot, 'incrB')
    toplot = 4;
end

temp = 1; % temperature
offset = 0; % offset
upperTH = 0.6;
lowerTH = 0.4;

    inputvalues = bin : bin : 1;
    %inputvalues = [-0.5+bin/2 : bin : 0.5-bin/2];
    
    inputs = zeros(length(inputvalues)*length(inputvalues),2);
    k = 0;
    for j = 1:length(inputvalues)
        for i = 1:length(inputvalues)
            k = k+1;
            inputs(k, 1) = inputvalues(end-i+1); % y value
            inputs(k, 2) = inputvalues(j); % x value
        end
    end
    
    targets = zeros(length(inputvalues),length(inputvalues));
    
diag_left = [1,7,13,19,25];
lower_left = [2:5, 8:10, 14:15, 20];
upper_right = [6,11:12,16:18,21:24];

diag_right = [5,9,13,17,21];
lower_right = [10, 14:15, 18:20, 22:25];
upper_left = [1:4,6:8,11:12,16];

if pattern == 1
    activeones = lower_left;
    patternname = 'lower left triangle';
end
if pattern == 3
    activeones = upper_right;
    patternname = 'upper right triangle';
end
if pattern == 2
    activeones = lower_right;
    patternname = 'lower right triangle';
end
if pattern == 4
    activeones = upper_left;
    patternname = 'upper left triangle';
end

targets(activeones) = 1;

%% Test weights

values = -range : res : range;

Z = NaN(numel(values));
for i = 1:numel(values)
    for j = 1:numel(values)
        W1 = values(j);
        W2 = values(i);
        
        %         W = 5.7334;
        %         B = -1.5527;
        
        storage = zeros(1,6);
        for sweep = 1 : length(inputs)
            
            I = inputs(sweep, :);
            target = targets(sweep);
            
            %O = transferfn_logsig(I(1)*W1 + I(2)*W2 + B, temp, offset); % with bias
            O = transferfn_logsig(I(1)*W1 + I(2)*W2, temp, offset); % no bias
            error = target-O;
            delta = O * (1-O) * error;
            %delta = delta_logsig_withT(O, target, 'output', temp, offset);
            incrW1 = LR * I(1) * delta;
            incrW2 = LR * I(2) * delta;
            incrB = LR * 1 * delta;
            
            storage(1) = storage(1) + error*error;
            storage(2) = storage(2) + delta;
            storage(3) = storage(3) + incrW1;
            storage(4) = storage(4) + incrW2;
            storage(5) = storage(5) + incrB;
            storage(6) = storage(6) + is_correct(target, O, upperTH, lowerTH);
            
        end
        storage;
        
        Z(i,j) = storage(toplot);
        
    end
end

% W = [0, storage1(6,:)];
% B = [0, storage1(7,:)];
% T = [NaN, storage1(toplot,:)];
%% Plot flat surface

% Flat surface plot
%if plottype == 1
plottype = 1;
    f=figure;
    hold all
    surface('XData',values, 'YData',values, 'ZData',zeros(size(Z)), 'CData',Z)%, ...
    %  'EdgeColor','none')
    %set(gca, 'CLim', [0, 4]) % for error
    %set(gca, 'CLim', [-0.02, 0.06]) % for delta
    %plot(W,B, '.k')
    
    view(0, 90)
    xlabel('W1 weight')
    ylabel('W2 weight')
    axis square
    
    plottitle = [patternname, ' - ', measure_toplot, '-2D']
    title(plottitle)
    saveas(f,[folder, plottitle, '.fig'])
    print('-dpng', [folder, plottitle, '.png'])
    close
%end

% 3D plot
%if plottype == 2
plottype = 2;
    g=figure;
    hold all
    surface('XData',values, 'YData',values, 'ZData',Z, 'CData',Z)%, ...
    %  'EdgeColor','none')
    %set(gca, 'CLim', [0, 4]) % for error
    %set(gca, 'CLim', [-0.02, 0.06]) % for delta
    %scatter3(W,B,T, '.k')
    
    view(-146, 26)
    xlabel('IH weight')
    ylabel('bias')
    axis square
    grid on
    
    plottitle = [patternname, ' - ', measure_toplot, '-3D']
    title(plottitle)
    saveas(g,[folder, plottitle, '.fig'])
    print('-dpng', [folder, plottitle, '.png'])
    close
%end
%view(-164, 26)
