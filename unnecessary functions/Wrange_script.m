clear
addpath(genpath('C:\Matlab_functions'));

t = 0.05;
b = 0.01;
x = 0.9;


Wrange(t,b,x);
[Wrange_left(t,b,x), Wrange_right(t,b,x)];

[(-t)/(x-b), (-t)/(x+b), t/x]


