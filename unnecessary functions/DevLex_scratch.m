%% DevLex model, code from scratch

%% Parameters

clear
vocabsize=3;
Pmapsize=5;
Smapsize=4;

%% Initialize

% Architecture - layers
PIN=zeros(1,vocabsize); % phonological input layer
SIN=zeros(1,vocabsize); % semantic input layer
PAP=zeros(1,Pmapsize); % phonological map
SAP=zeros(1,Smapsize); % semantic map

% Weights
PW=rand(vocabsize, Pmapsize); % phonological input -> map
SW=rand(vocabsize, Smapsize); % semantic input -> map
PSW=rand(Pmapsize,Smapsize); % phonological map -> semantic map
SPW=rand(Smapsize,Pmapsize); % semantic map -> phonological map 

% Input
INPUTS=lexicongenerator_random(vocabsize);

%%


