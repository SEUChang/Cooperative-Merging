clear;
clc;
%% 初始化各种仿真参数
[lambda, T ] =...
deal(0.33, 40 );

[ dis , vmin, vmax, amin, amax] = ...
deal(250 , 0 ,   15,    -5,  3);

[dt1, dt2] = ...
deal(1.5, 2);

 [initState,size1, size2] = creatInitState(lambda, T , dis, vmin, vmax, amin, amax);
% initState = importdata('initStateV1_0428.mat');
% initState = initState(1:4,:);
%% fifo
fifoTassign = fifo( initState, dt1, dt2 );
%% dp
[dp1,dp2, sol,DPAssignTime,DPrunTime,roadDecsion] = dpMethod(dt1, dt2,initState);
%% milp
[MILPAssignTime,MILPrunTime] = milpMethod(initState,dt1,dt2);