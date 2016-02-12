% Various things

clear
addpath(genpath('C:\Matlab_functions'));
folder = 'C:\Matlab_functions\RESULTS\Categorizator model_7\half and half_2H\'; % folder to save results
filename = '';
tol = 'all';
ig = 1;
pattern = 'Left diagonal';

% Weight plots

if isempty(filename)
    
    filenames = dir([folder, '*.mat']);
    final = NaN(10, tol-ig+1);
    sorszam = 0;
    if tol == 'all'
        tol=length(filenames);
    end
    for i = (length(filenames)-tol+1) : length(filenames)-ig+1
        sorszam = sorszam + 1;
        matfile = [folder, filenames(i).name]
        load(matfile, 'W', 'P', 'Q')
        
        collect = NaN(10,P.intended_epochs);
        for j = 1:length(Q)
            collect(1,j) = Q(j).IH(1,1)/Q(j).IH(2,1);
            collect(2,j) = Q(j).IH(1,2)/Q(j).IH(2,2);
            collect(3,j) = Q(j).IH(3,1)/Q(j).IH(1,1);            
            collect(4,j) = Q(j).IH(3,2)/Q(j).IH(1,2);
            collect(5,j) = Q(j).IH(1,1);
            collect(6,j) = Q(j).IH(1,2);
            collect(7,j) = Q(j).IH(2,1);
            collect(8,j) = Q(j).IH(2,2);
            collect(9,j) = Q(j).IH(3,1);
            collect(10,j) = Q(j).IH(3,2);
        end
        final(1,sorszam) = Q(end).IH(1,1)/Q(end).IH(2,1);
        final(2,sorszam) = Q(end).IH(1,2)/Q(end).IH(2,2);
        final(3,sorszam) = Q(end).IH(3,1)/Q(end).IH(1,1);
        final(4,sorszam) = Q(end).IH(3,2)/Q(end).IH(1,2);
        final(5,sorszam) = Q(end).IH(1,1);
        final(6,sorszam) = Q(end).IH(1,2);
        final(7,sorszam) = Q(end).IH(2,1);
        final(8,sorszam) = Q(end).IH(2,2);
        final(9,sorszam) = Q(end).IH(3,1);
        final(10,sorszam) = Q(end).IH(3,2);
        
        hold all
%         for j = 5:8
%             plot(collect(j,:), 'r-') % I-H weights
%         end
%         for j = 9:10
%             plot(collect(j,:), 'b-') % bias - H weights
%         end
        for j = 1:2
              plot(collect(j,:), 'r-') % bias - H weights
        end
        for j = 3:4
              plot(collect(j,:), 'b-') % bias - H weights
        end
        
    end
    
%     title(['Input-hidden weights converge - ', pattern])
%     str1(1) = {'red: IH weights'};
%     str1(2) = {'blue: bias weights'};
%     text(800,8,str1)
%     print('-dpng', [folder, pattern, ' - weights converge.png']);
%     close
    
    title(['Input-hidden weight proportions - ', pattern])
    str1(1) = {'red: w11/w21 and w12/w22'};
    str1(2) = {'blue: b1/w11 and b2/w12'};
    text(800,8,str1)
    set(gca, 'YLim', [-10, 10])
    print('-dpng', [folder, pattern, ' - weight proportions.png']);
    close
    
    hold all   
    for j = 1:10
        plot(j, final(j,:), 'o')
    end
    title(['Input-hidden final weights - ', pattern])
    set(gca, 'XLim', [0, 11])
    set(gca, 'XTickLabel', {'', 'w11/w21', 'w12/w22', 'b1/w11', 'b2/w12', 'w11', 'w12', 'w21', 'w22', 'b1', 'b2', ' '})
    print('-dpng', [folder, pattern, ' - final weights.png']);    
    close
end

%%
if isempty(filename)==0
    
    matfile = [folder, filename, '.mat']
    load(matfile, 'W', 'P', 'Q')
    collect = NaN(4,P.intended_epochs);
    
    for j = 1:length(Q)
        collect(1,j) = Q(j).IH(1,1)/Q(j).IH(2,1);
        collect(2,j) = Q(j).IH(3,1)/Q(j).IH(1,1);
        collect(3,j) = Q(j).IH(1,2)/Q(j).IH(2,2);
        collect(4,j) = Q(j).IH(3,2)/Q(j).IH(1,2);
    end
    
    hold all
    plot(collect(1,:), 'r-')
    %plot(collect(2,:), 'r-')
    plot(collect(3,:), 'b-')
    %plot(collect(4,:), 'b-')
    hold off
    
end




