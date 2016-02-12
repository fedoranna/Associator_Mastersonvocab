% Hebbian learning rule for layersm of neurons

function w = Hebbian(a1, a2, w, LR)
for i = 1:length(a1)
    for j = 1:length(a2)
        w(i,j) = w(i,j) + LR * (a1(i) * a2(j));
    end
end
    
    



