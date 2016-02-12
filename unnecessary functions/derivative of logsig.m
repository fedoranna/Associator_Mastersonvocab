a = 1;
temp = 1;
offset = 10;

f = 1/(1+exp(-temp*a+offset));

Anna = f * (1-f); 
Caspar = temp * f * (1-f);
Themis = temp * (f * (1-f) + offset);

[Anna, Caspar, Themis]