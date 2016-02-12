% Makes the usual figures

function output = matfileanalyzator_compositefigs(matfile, param)

opengl software
load(matfile, 'P', 'T', 'R')

compositefigs(P, T, R)
output = 'done';