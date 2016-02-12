function sequence = modesequence(type, nbof_S_epochs, nbof_P_epochs, nbof_R_epochs, nbof_L_epochs)

if strcmp(type, 'fourphase')
    sequence = [repmat('S', 1, nbof_S_epochs), repmat('P', 1, nbof_P_epochs), repmat('R', 1, nbof_R_epochs), repmat('L', 1, nbof_L_epochs)];
end

if strcmp(type, 'random')
    modes = [repmat('S', 1, nbof_S_epochs), repmat('P', 1, nbof_P_epochs), repmat('R', 1, nbof_R_epochs), repmat('L', 1, nbof_L_epochs)];
    sequence = reorder(modes);
end

if strcmp(type, 'fourcycle')
    if isequal(nbof_S_epochs, nbof_P_epochs, nbof_R_epochs, nbof_L_epochs)
        sequence = [repmat('SPRL', 1, nbof_S_epochs)];
    else
        'Warning! All 4 parameters must be equal!'    
    end
end

if strcmp(type, 'twophase')
    modes1 = [repmat('S', 1, nbof_S_epochs), repmat('P', 1, nbof_P_epochs)];
    sequence1 = reorder(modes1);
    modes2 = [repmat('R', 1, nbof_R_epochs), repmat('L', 1, nbof_L_epochs)];
    sequence2 = reorder(modes2);
    sequence = [sequence1, sequence2];    
end

if strcmp(type, 'pretrainP')
    sequence1 = [repmat('P', 1, nbof_P_epochs)];
    if isequal(nbof_S_epochs, nbof_R_epochs, nbof_L_epochs)
        sequence2 = [repmat('SRL', 1, nbof_S_epochs)];
    else
        'Warning! All 4 parameters must be equal!'    
    end
    sequence = [sequence1, sequence2]; 
end


    

    

    
    
