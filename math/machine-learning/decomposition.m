%% init
clear, clc

%% SVD
X=randn(5,3);
[U,S,V1]=svd(X);
[Uhat,Shat,V2]=svd(X,"econ");