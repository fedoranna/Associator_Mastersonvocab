%% Script for making error surface plot based on IH weight and bias
% 1D input space
% Perceptron model should be run first if you want to plot the trajectory
% on the surface

%clear
addpath(genpath('C:\Matlab_functions'))

res = 0.1;
range = 10;
bin = 0.2;
LR = 0.1;
type = 'logsig';

%pattern = 1;
plottype = 0; % 1=flat; 2=3D
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

%inputs = bin : bin : 1;
targets = zeros(length(inputs));

if pattern == 1
    activeones = 2:length(inputs);
    %plottitle = 'All +, but left one';
end
if pattern == 2
    activeones = 1:length(inputs)-1;
    %plottitle = 'All +, but right one';
end
if pattern == 3
    activeones = 1;
    %plottitle = 'All -, but left one';
end
if pattern == 4
    activeones = length(inputs);
    %plottitle = 'All -, but right one';
end
targets(activeones) = 1;

%% Test weights

values = -range : res : range;

Z = NaN(numel(values));
for i = 1:numel(values)
    for j = 1:numel(values)
        W = values(j);
        B = values(i);
        
        %         W = 5.7334;
        %         B = -1.5527;
        
        storage = zeros(1,5);
        for sweep = 1 : length(inputs)
            
            I = inputs(sweep);
            target = targets(sweep);
            
            O = transferfn_logsig(I*W + B, temp, offset);
            error = target-O;
            delta = O * (1-O) * error;
            incrW = LR * I * delta;
            incrB = LR * 1 * delta;
            score = is_correct(target, O, upperTH, lowerTH);
            
            storage(1) = storage(1) + error*error;
            storage(2) = storage(2) + delta;
            storage(3) = storage(3) + incrW;
            storage(4) = storage(4) + incrB;
            storage(5) = storage(5) + score;
            
        end
        storage;
        
        Z(i,j) = storage(toplot);
        
    end
end

W = [0, storage1(6,:)];
B = [0, storage1(7,:)];
T = [NaN, storage1(toplot,:)];
%% Plot flat surface

% Flat surface plot
%if plottype == 1
plottype = 1;
    f=figure;
    hold all
    surface('XData',values, 'YData',values, 'ZData',zeros(size(Z)), 'CData',Z)%, ...
    %  'EdgeColor','none')
    set(gca, 'CLim', [0, 4]) % for error
    %set(gca, 'CLim', [-0.02, 0.06]) % for delta
    plot(W,B, '.k')
    
    view(0, 90)
    xlabel('IH weight')
    ylabel('bias')
    axis square
    
    plottitle = ['pattern', num2str(pattern), '-', measure_toplot, '-2D']
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
    set(gca, 'CLim', [0, 4]) % for error
    %set(gca, 'CLim', [-0.02, 0.06]) % for delta
    scatter3(W,B,T, '.k')
    
    view(-146, 26)
    xlabel('IH weight')
    ylabel('bias')
    axis square
    grid on
    
    plottitle = ['pattern', num2str(pattern), '-', measure_toplot, '-3D']
    title(plottitle)
    saveas(g,[folder, plottitle, '.fig'])
    print('-dpng', [folder, plottitle, '.png'])
    close
%end
%view(-164, 26)
