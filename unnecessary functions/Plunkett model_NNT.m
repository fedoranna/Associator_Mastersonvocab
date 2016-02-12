%% Model based on Plunkett et al. 1992 - with the Neural Network Toolbox
% training algorithm: back-propagation
% training regime: traditional (simultaneous presentation of label and
% image)
% functions: C:\Program Files (x86)\MATLAB\R2007b\toolbox\nnet\nnet
%% Parameters

clear
path('E:\Matlab_functions',path);

% Training

% incremental training witg conjugate gradient descent backpropagation
% traincgp - epoch=12 - show=1 - few sec
% trainr - epoch=1200 - show=10 - 16 minutes
adaptepochs=12;
adaptshow=1;

LF_nw = 'traincgp'; %traincgp gyors, b nem mukodik, c-r plottol, s mukodik     % help nntrain
LF_ilb = 'learngd'; % learningfunction for net.biases{i}.learnFcn, net.inputWeights{i}.learnFcn and net.layerWeights{i,j}.learnFcn
% only used when LF_nw = trainb,c,r,s   % help nnlearn

adaptpasses=1;
trainpasses=10;
trainepochs=10;

% Input
vocabsize = 97; % originally 32; it equals with the nb of labels and the nb of prototypes
sizeof_batch = vocabsize; % number of training examples in the training set
%nbof_pixels = 2100; % nb of image pixels
%nbof_distortionlevels = 3;
%nbof_reps = 2; % number of distorted pictures/ distortionlevels
%grain = 12; % the grain of the retina

% Size of layers
RI = vocabsize; % Input1; retinal input layer: originally 171; 175*12=2100
RH = 20; % Layer1; retinal hidden layer: originally 30
RO = RI; % Layer4; retinal output layer
LI = vocabsize; % Input2; label input layer
LH = vocabsize; % Layer2; label hidden layer
LO = vocabsize; % Layer5; label output layer
CH = 30; % Layer3; common hidden layer: originally 50

% Given
nbof_inputs = 2; % number of input layers
nbof_layers = 5;
nbof_outputs = 2;
nbof_timesteps = 1; 

%% Training data

vocab=lexicongenerator_random(vocabsize);
pictures=vocab{1};
labels=vocab{2};

INPUTS=cell(nbof_inputs, nbof_timesteps);
INPUTS{1,1}=pictures(1:sizeof_batch,:)';
INPUTS{2,1}=labels(1:sizeof_batch,:)';

TARGETS=cell(nbof_outputs, nbof_timesteps); % number of layers x nb of timesteps
TARGETS{1,1}=pictures(1:sizeof_batch,:)';
TARGETS{2,1}=labels(1:sizeof_batch,:)';

% TODO: 
% - distributed representation for images
% - generate distortions
% - retinal representations

%% Setup

net=network;

% I. Architecture

net.numInputs = nbof_inputs;
net.numLayers = nbof_layers;
net.biasConnect = [1; 1; 1; 1; 1];
net.inputConnect = [1 0; 0 1; 0 0; 0 0; 0 0];
net.layerConnect = [0 0 0 0 0; 0 0 0 0 0; 1 1 0 0 0; 0 0 1 0 0; 0 0 1 0 0];
net.outputConnect = [0 0 0 1 1];
net.numOutputs; % read-only
net.numInputDelays; % read-only
net.numLayerDelays; % read-only

% II. Subobject structures

% II/1. Inputs
net.inputs{1}.exampleInput = INPUTS{1}; % ??? Is it the training examples?; this changes net.inputs{i}.size!!! = nb of units (elements) in the ith input; examples have to be in columns!
net.inputs{1}.processFcns = {}; % ??? What is this? help nnprocess
net.inputs{2}.exampleInput = INPUTS{2}; % ??? Is it the training examples?
net.inputs{2}.processFcns = {};

% II/2. Layers
    %net.layers{1}; DEFAULTS
% net.layers{1}.distanceFcn; 
% net.layers{1}.distances; % read-only
% net.layers{1}.initFcn = 'initwb';
% net.layers{1}.netInputFcn = 'netsum';
% net.layers{1}.netInputParam; % parameters of the input function; help(net.layers{i}.netInputFcn)
% net.layers{1}.positions; % read-only
% net.layers{1}.size=RI; % changes the dimensions!
% net.layers{1}.dimensions; % =[4 4]
% net.layers{1}.topologyFcn = 'hextop';
% net.layers{1}.transferFcn = 'purelin';
% net.layers{1}.transferParam; % parameters of the transferfunction; help(net.layers{i}.transferFcn)
    
net.layers{1}.size=RI;
net.layers{2}.size=LI;
net.layers{3}.size=CH;
net.layers{4}.size=RO;
net.layers{5}.size=LO;

for i=1:5
    net.layers{i}.transferFcn = 'logsig';
end

% II/3. Outputs
net.outputs{4}.exampleOutput = TARGETS{1}; % ??? Is it the training examples?
net.outputs{4}.processFcns = {}; % ??? What is this?
%net.outputs{1}.processParams;
net.outputs{5}.exampleOutput = TARGETS{2}; % ??? Is it the training examples?
net.outputs{5}.processFcns = {};
%net.outputs{2}.processParams;

% II/4. Biases
for i=1:5    
    net.biases{i}.initFcn = 'rands';
    net.biases{i}.learn = 1;
    net.biases{i}.learnFcn = LF_ilb;
    net.biases{i}.learnParam;
    net.biases{i}.size; % read-only
end

% II/5. Input weights
net.inputWeights{1,1}.delays;
net.inputWeights{1,1}.initFcn = 'rands'; % help nninit
net.inputWeights{1,1}.learn = 1;
net.inputWeights{1,1}.learnFcn = LF_ilb; % help nnlearn
net.inputWeights{1,1}.learnParam; % has default values
net.inputWeights{1,1}.size; % read-only
net.inputWeights{1,1}.weightFcn = 'dotprod'; % help nnweight; The weight function is used to transform layer inputs during simulation and training.
net.inputWeights{1,1}.weightParam; % parameters of the current weight function

net.inputWeights{2,2}.delays;
net.inputWeights{2,2}.initFcn = 'rands'; % help nninit
net.inputWeights{2,2}.learn = 1;
net.inputWeights{2,2}.learnFcn = LF_ilb; % help nnlearn
net.inputWeights{2,2}.learnParam; % parameters of the current learning function; has defaults
net.inputWeights{2,2}.size; % read-only
net.inputWeights{2,2}.weightFcn = 'dotprod'; % help nnweight; The weight function is used to transform layer inputs during simulation and training.
net.inputWeights{2,2}.weightParam; % parameters of the current weight function

% II/6. Layer weights

for i=1:nrows(net.layerWeights)
    for j=1:ncols(net.layerWeights)
        if (length(net.layerWeights{i,j}) ~=0 )  
            net.layerWeights{i,j}.delays;
            net.layerWeights{i,j}.initFcn = 'rands'; % help nninit
            net.layerWeights{i,j}.learn = 1;
            net.layerWeights{i,j}.learnFcn = LF_ilb; % help nnlearn
            net.layerWeights{i,j}.learnParam; % parameters of the current learning function; has defaults
            net.layerWeights{i,j}.size; % read-only
            net.layerWeights{i,j}.weightFcn = 'dotprod'; % help nnweight; The weight function is used to transform layer inputs during simulation and training.
            net.layerWeights{i,j}.weightParam; % parameters of the current weight function
        end
    end
end

% III. Functions
% changing these functions changes the corresponding parameters

net.adaptFcn = LF_nw; % help nntrain; trains=incrmental training
net.divideFcn = 'dividerand'; % help nnformat; dividerand
net.gradientFcn = 'calcgrad'; %
net.initFcn = 'initlay'; % help nninit; 
net.performFcn = 'mse'; % help nnperformance; only used with train
net.trainFcn = LF_nw; % help nntrain; 

% IV. Parameters: all have default values

net.adaptParam; % help(net.adaptFcn)
net.divideParam; % help(net.divideFcn)
net.gradientParam; % help(net.gradientFcn)
net.initParam; % help(net.initFcn)
net.performParam; % help(net.performFcn)
net.trainParam; % help(net.trainFcn)

% V. Weight and bias values
%all are calculated from previously defined values

% net.IW{1,1}
% net.IW{2,2}
% net.LW{3,1}
% net.LW{3,2}
% net.LW{4,3}
% net.LW{5,3}
% net.b{1}
% net.b{2}
% net.b{3}
% net.b{4}
% net.b{5}

%% Initialize

net = init(net);
% If sizeof_batch < sizeof_input there is a warning. No problem!

%% Validate

% Miért nem tudom megadni a targetet?

% simoutputs=sim(net, INPUTS);
% 
% E=simoutputs{1}-TARGETS{1};
% errorsbysweeps=NaN(1,sizeof_batch);
% for i=1:ncols(E)
%     errorsbysweeps(i)=mse(E(:,i));
% end
% retinal_firsterror=errorsbysweeps;
% 
% E=simoutputs{2}-TARGETS{2};
% errorsbysweeps=NaN(1,sizeof_batch);
% for i=1:ncols(E)
%     errorsbysweeps(i)=mse(E(:,i));
% end
% label_firsterror=errorsbysweeps;

%% Train
% My input data is in concurrent format, so "adapt" will perform batch training; "train" performs batch training anyway.
%net.trainParam.epochs = 1000; % trainb-hez
net.adaptParam.passes = adaptpasses; % trains-hez; 5000 passes = kb fél perc
net.adaptParam.epochs = adaptepochs;
net.trainParam.passes = trainpasses;
net.trainParam.epochs = trainepochs;

net.adaptParam.show = adaptshow;

tic
[net, outputs, errors, tr] = adapt(net, INPUTS, TARGETS);
toc

%[net, trainingrecord, outputs, errors] = train(net, INPUTS, TARGETS);
% DOES NOT WORK: net = adapt(net, con2seq(INPUTS), con2seq(TARGETS));


%% Validate

% simoutputs=sim(net, INPUTS);
% 
% E=simoutputs{1}-TARGETS{1};
% errorsbysweeps=NaN(1,sizeof_batch);
% for i=1:ncols(E)
%     errorsbysweeps(i)=mse(E(:,i));
% end
% retinal_lasterror=errorsbysweeps;
% 
% E=simoutputs{2}-TARGETS{2};
% errorsbysweeps=NaN(1,sizeof_batch);
% for i=1:ncols(E)
%     errorsbysweeps(i)=mse(E(:,i));
% end
% label_lasterror=errorsbysweeps;
% 
% retinal_lasterror-retinal_firsterror
% label_lasterror-label_firsterror

%% Questions

% nntool
% glossary (Neural network Toolbox)
% con2seq: átalakítja batch-es targetb?l sequential targetté

net.numOutputs;
net.outputs;
net.outputs{4};
   
% mi a különbség dimensions és size között?
% lehet, hogy azért nem megy a train, mert rossz fcn-t használok

%% Notes

% JELMAGYARÁZAT: Code notes / Dimensions

% STATIC AND DYNAMIC NETWORKS (TIMESTEPS)
% static network = has no feedback or delays; order of inputs does not matter, can be treated as concurrent, but can be treated with sequential input too
%   Concurrent inputs in static nw:
%       Q = batch size = number of concurrent inputs (trainingsetsize)
%       input is a matrix: sizeofinput x Q (training examples are in columns)
%       target is a matrix: sizeofoutput x Q
%   Sequential inputs in static nw:
%       input is a cell array: nbofinputs x Q (training examples are in different cells)
%           each cell contains a matrix: sizeofinput x 1
%       can be used for incremental training with adapt(NET, p, t)
% dynamic network: trained with e.g. words order in sentences;  can be trained sequentially or concurrently

% INCREMENTAL AND BATCH TRAINING
% incremental training: adapt(net, P, T): 
%   if the input is concurrent (matrix) -> batch training (after the whole matrix was presented
%   if the input is sequential (cell array) -> incremental training (after each input cell)
% batch training: adapt or train
%   if the input is sequential -> train transforms it to concurrent
%   if you use adapt, the input has to be concurrent (otherwise incremental learning occurs)

% ADAPT AND TRAIN
% With static networks, the adapt function can implement incremental or batch training, depending on the format of the input data. If the data is presented as a matrix of concurrent vectors, batch training occurs. If the data is presented as a sequence, incremental training occurs. This is not true for train, which always performs batch training, regardless of the format of the input.
% adapt: calling it invokes adaptFcn in Functions
% train: calling it invokes trainFcn in Functions
% both invokes:
%   net.biases{i}.learnFcn and
%   net.inputWeights{i}.learnFcn
%   net.layerWeights{i,j}.learnFcn
% types: help nntrain
% net.biases/layerWeights/inputWeights{i}.learnFcn is used if
%   train -> net.trainFcn is: trainb, trainc, or trainr
%   adapt -> net.adaptFcn is: trains.
%   types: help nnlearn (all starts with learn!)
%
% NETWORK AND INPUT-BIAS-LAYER LEARNING FUNCTIONS
% network learning functions: net.adaptFcn and net.trainFcn
%     they either train the nw directly, or call the I-B-L learning functions (trainb, c, r, s)
%     help nntrain
% I-B-L learning functions: net.biases/layerWeights/inputWeights{i}.learnFcn
%     help nnlearn


%% Trash

