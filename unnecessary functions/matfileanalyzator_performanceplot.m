% Makes a performance plot

function matfileanalyzator_performanceplot(matfile, param)


load(matfile, 'T')

opengl software % This should solve the mirrored labels
figure
hold all
plot(T.epoch(1:x), T.scores(1:x))
plot(T.epoch(1:x), T.error(1:x))
axis([0 T.epoch(end) 0 R.sizeof_testset+1])
hold off
title('Performance')
xlabel('Epoch')
ylabel('Performance')

%% Saving

figurefile = [folder, P.ID, '_perf.png'];
print('-dpng', figurefile);

close
end