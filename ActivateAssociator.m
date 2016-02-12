% Forward activation propagation in the Associator model in 4 different
% modes (tasks)

function L = ActivateAssociator(L, W, P, mode, input)

if P.trainingmode % batch training
    
    if strcmp(mode, 'S')
        L(1).state = input; % SI
        L(2).state = [L(1).state, zeros(size(L(1).state,1),1)+P.bias] * W(1).state;
        L(2).state = P.transferfn(L(2).state + randomnoise(P.noise(1), size(L(2).state)), P.temperatures(1), P.offset); % SH
        L(3).state = [L(2).state, zeros(size(L(2).state,1),1)+P.bias] * W(2).state;
        L(3).state = P.transferfn(L(3).state + randomnoise(P.noise(1), size(L(3).state)), P.temperatures(1), P.offset); % SO
    end
    if strcmp(mode, 'P')
        L(4).state = input; % PI
        L(5).state = [L(4).state, zeros(size(L(4).state,1),1)+P.bias] * W(3).state;
        L(5).state = P.transferfn(L(5).state + randomnoise(P.noise(2), size(L(5).state)), P.temperatures(2), P.offset); % PH
        L(6).state = [L(5).state, zeros(size(L(5).state,1),1)+P.bias] * W(4).state;
        L(6).state = P.transferfn(L(6).state + randomnoise(P.noise(2), size(L(6).state)), P.temperatures(2), P.offset); % PO
    end
    if strcmp(mode, 'R')
        L(1).state = input; % SI
        L(2).state = [L(1).state, zeros(size(L(1).state,1),1)+P.bias] * W(1).state;
        L(2).state = P.transferfn(L(2).state + randomnoise(P.noise(1), size(L(2).state)), P.temperatures(1), P.offset); % SH
        L(7).state = [L(2).state, zeros(size(L(2).state,1),1)+P.bias] * W(5).state;
        L(7).state = P.transferfn(L(7).state + randomnoise(P.noise(3), size(L(7).state)), P.temperatures(3), P.offset); % AR from SH
        L(5).state = [L(7).state, zeros(size(L(7).state,1),1)+P.bias] * W(6).state;
        L(5).state = P.transferfn(L(5).state + randomnoise(P.noise(3), size(L(5).state)), P.temperatures(3), P.offset); % PH from AR
        L(6).state = [L(5).state, zeros(size(L(5).state,1),1)+P.bias] * W(4).state;
        L(6).state = P.transferfn(L(6).state + randomnoise(P.noise(2), size(L(6).state)), P.temperatures(2), P.offset); % PO
    end
    if strcmp(mode, 'L')
        L(4).state = input; % PI
        L(5).state = [L(4).state, zeros(size(L(4).state,1),1)+P.bias] * W(3).state;
        L(5).state = P.transferfn(L(5).state + randomnoise(P.noise(2), size(L(5).state)), P.temperatures(2), P.offset); % PH
        L(8).state = [L(5).state, zeros(size(L(5).state,1),1)+P.bias] * W(7).state;
        L(8).state = P.transferfn(L(8).state + randomnoise(P.noise(4), size(L(8).state)), P.temperatures(4), P.offset); % AL from PH
        L(2).state = [L(8).state, zeros(size(L(8).state,1),1)+P.bias] * W(8).state;
        L(2).state = P.transferfn(L(2).state + randomnoise(P.noise(4), size(L(2).state)), P.temperatures(4), P.offset); % SH from AL
        L(3).state = [L(2).state, zeros(size(L(2).state,1),1)+P.bias] * W(2).state;
        L(3).state = P.transferfn(L(3).state + randomnoise(P.noise(1), size(L(3).state)), P.temperatures(1), P.offset); % SO
    end
    
else % online training
    
    if strcmp(mode, 'S')
        L(1).state = input; % SI
        L(2).state = P.transferfn([L(1).state, P.bias] * W(1).state + randomnoise(P.noise(1), size(L(2).state)), P.temperatures(1), P.offset); % SH
        L(3).state = P.transferfn([L(2).state, P.bias] * W(2).state + randomnoise(P.noise(1), size(L(3).state)), P.temperatures(1), P.offset); % SO
    end
    if strcmp(mode, 'P')
        L(4).state = input; % PI
        L(5).state = P.transferfn([L(4).state, P.bias] * W(3).state + randomnoise(P.noise(2), size(L(5).state)), P.temperatures(2), P.offset); % PH
        L(6).state = P.transferfn([L(5).state, P.bias] * W(4).state + randomnoise(P.noise(2), size(L(6).state)), P.temperatures(2), P.offset); % PO
    end
    if strcmp(mode, 'R')
        L(1).state = input; % SI
        L(2).state = P.transferfn([L(1).state, P.bias] * W(1).state + randomnoise(P.noise(1), size(L(2).state)), P.temperatures(1), P.offset); % SH
        L(7).state = P.transferfn([L(2).state, P.bias] * W(5).state + randomnoise(P.noise(3), size(L(7).state)), P.temperatures(3), P.offset); % AR from SH
        L(5).state = P.transferfn([L(7).state, P.bias] * W(6).state + randomnoise(P.noise(3), size(L(5).state)), P.temperatures(3), P.offset); % PH from AR
        L(6).state = P.transferfn([L(5).state, P.bias] * W(4).state + randomnoise(P.noise(2), size(L(6).state)), P.temperatures(2), P.offset); % PO
    end
    if strcmp(mode, 'L')
        L(4).state = input; % PI
        L(5).state = P.transferfn([L(4).state, P.bias] * W(3).state + randomnoise(P.noise(2), size(L(5).state)), P.temperatures(2), P.offset); % PH
        L(8).state = P.transferfn([L(5).state, P.bias] * W(7).state + randomnoise(P.noise(4), size(L(8).state)), P.temperatures(4), P.offset); % AL from PH
        L(2).state = P.transferfn([L(8).state, P.bias] * W(8).state + randomnoise(P.noise(4), size(L(2).state)), P.temperatures(4), P.offset); % SH from AL
        L(3).state = P.transferfn([L(2).state, P.bias] * W(2).state + randomnoise(P.noise(1), size(L(3).state)), P.temperatures(1), P.offset); % SO
    end
    
end
    
