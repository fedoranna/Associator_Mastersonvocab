function L = ActivateAssociator22(L, W, P, mode, input)

if strcmp(mode, 'S')
    L(1).state = input; % SI
    L(2).state = P.transferfn([L(1).state, P.bias] * W(1).state + randomnoise(P.noise(1), [1, L(2).size]), P.temperatures(1), P.offset); % SH
    L(3).state = P.transferfn([L(2).state, P.bias] * W(2).state + randomnoise(P.noise(1), [1, L(3).size]), P.temperatures(1), P.offset); % SO
end
if strcmp(mode, 'P')
    L(4).state = input; % PI
    L(5).state = P.transferfn([L(4).state, P.bias] * W(3).state + randomnoise(P.noise(2), [1, L(5).size]), P.temperatures(2), P.offset); % PH
    L(6).state = P.transferfn([L(5).state, P.bias] * W(4).state + randomnoise(P.noise(2), [1, L(6).size]), P.temperatures(2), P.offset); % PO
end
if strcmp(mode, 'R')
    L(1).state = input; % SI
    L(2).state = P.transferfn([L(1).state, P.bias] * W(1).state + randomnoise(P.noise(1), [1, L(2).size]), P.temperatures(1), P.offset); % SH
    L(7).state = P.transferfn([L(2).state, P.bias] * W(5).state + randomnoise(P.noise(3), [1, L(7).size]), P.temperatures(3), P.offset); % AR from SH
    L(5).state = P.transferfn([L(7).state, P.bias] * W(6).state + randomnoise(P.noise(3), [1, L(5).size]), P.temperatures(3), P.offset); % PH from AR
    L(6).state = P.transferfn([L(5).state, P.bias] * W(4).state + randomnoise(P.noise(2), [1, L(6).size]), P.temperatures(2), P.offset); % PO
end
if strcmp(mode, 'L')
    L(4).state = input; % PI
    L(5).state = P.transferfn([L(4).state, P.bias] * W(3).state + randomnoise(P.noise(2), [1, L(5).size]), P.temperatures(2), P.offset); % PH
    L(8).state = P.transferfn([L(5).state, P.bias] * W(7).state + randomnoise(P.noise(4), [1, L(8).size]), P.temperatures(4), P.offset); % AL from PH
    L(2).state = P.transferfn([L(8).state, P.bias] * W(8).state + randomnoise(P.noise(4), [1, L(2).size]), P.temperatures(4), P.offset); % SH from AL
    L(3).state = P.transferfn([L(2).state, P.bias] * W(2).state + randomnoise(P.noise(1), [1, L(3).size]), P.temperatures(1), P.offset); % SO
end





