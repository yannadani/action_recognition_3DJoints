% Setparams

addpath(genpath('SPAMS'));
%
load params
%% Parameters setting
par.mu = par.mu*1;
x = 50;
par.K 	= x;
param.K = x;
par.L	= x;
param.L = x;
param.lambda        = par.lambda1; % not more than 20 non-zeros coefficients
param.lambda2       = par.lambda2;
param.mode          = 2;       % penalized formulation
param.approx=0;
%par.lambda1 = .1;
%par.lambda2 = .1;
