%% Main optimization routine
clc; close all; clear all;
% alpha = input('Ingress the angle value [rad]: ');
% x1 = -20:0.5:20;
% x2 = -20:0.5:20;
% 
% y = zeros(length(x1), length(x2));
% 
% for ii = 1 : length(x1)
%     for jj = 1 : length(x2)
%         y(ii,jj) = testModel([x1(ii) x2(jj)]); 
%     end
% end
% alpha = 0;
% estimateVolume = testModel(alpha)

ObjectiveFunction = @reachablevolume;
alpha0 = 0;   % Starting point
rng default % For reproducibility
[x,fval,exitFlag,output] = simulannealbnd(ObjectiveFunction,alpha0)