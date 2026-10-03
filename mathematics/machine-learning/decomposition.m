%% init
clear, clc

%% SVD
X=[3 2 2; 2 3 -2];
[U,S,V1]=svd(X);
[Uhat,Shat,V2]=svd(X,"econ");