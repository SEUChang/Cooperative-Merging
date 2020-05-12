clear;
clc;
%% 初始化各种仿真参数
[lambda, T ] =...
deal(0.5, 20);

[ dis , vmin, vmax, amin, amax] = ...
deal(250 , 0 ,   20,    -5,  3);

[dt1, dt2] = ...
deal(1.5, 2.0);
%  [initState,size1, size2] = creatInitState(lambda, T , dis, vmin, vmax, amin, amax);
[initState,size1, size2] = creatInitState_v2( T , dis, vmin, vmax, amin, amax);
%  initTemp = initState;
%   initState = importdata('initStateV2_0512.mat');
%  initState = initState(1:4,:);
%% fifo
fifoTassign = fifo( initState, dt1, dt2 );
%% dp
[dp1,dp2, sol,DPAssignTime,DPrunTime,roadDecision] = dpMethod(dt1, dt2,initState);
%% milp
%   [MILPAssignTime,MILPrunTime] = milpMethod(initState,dt1,dt2);