% ti ... kij... maxAssignTime
function [MILPAssignTime,MILPrunTime] = milpMethod(initState,dt1,dt2)
vehInfoRoad1 = initState( initState( : , 2 ) == 1, : );
vehInfoRoad2 = initState( initState( : , 2 ) == 2, : );
[M, ~] = size( vehInfoRoad1 );
[N, ~] = size( vehInfoRoad2 );
decisionVarNum = M + N + M * N + 1;
%目标函数
f = zeros(decisionVarNum, 1);
f(decisionVarNum) = 1;
%二进制变量
intcon =  M + N + 1 : 1 : M + N + M * N;
%最小时刻约束
lb = zeros(decisionVarNum, 1);
lb( 1:1:M + N ) = initState(:, 4);
%最大时刻约束
ub = zeros(decisionVarNum, 1);
ub(:) = Inf;% continue var time
ub( M + N + 1 : 1 : M + N + M * N ) = 1;% bin var kij

A = [];
b = [];
%同车道1约束
for i = 1:1:M - 1
    frontVehIdx = vehInfoRoad1( i , 6 ) ;
    backVehIdx = vehInfoRoad1( i+1 , 6 );
    tempA = zeros( 1, decisionVarNum);
    tempA(frontVehIdx) = 1;
    tempA(backVehIdx) = -1;
    A = [A;tempA];
    b = [b; -dt1];
end
%同车道2约束
for i = 1:1:N - 1
    frontVehIdx = vehInfoRoad2( i , 6 ) ;
    backVehIdx = vehInfoRoad2( i+1 , 6 );
    tempA = zeros( 1, decisionVarNum);
    tempA(frontVehIdx) = 1;
    tempA(backVehIdx) = -1;
    A = [A;tempA];
    b = [ b;-dt1 ];
end

ijIdx = M + N + 1;
BIG_NUM = 10000;
for i = 1: 1 : M
    for j = 1: 1: N
%         eq 8
        road1VehIdx = vehInfoRoad1( i , 6 ) ;
        road2VehIdx = vehInfoRoad2( j , 6 ) ;
        tempA = zeros( 1, decisionVarNum);
        tempA(road1VehIdx) = -1;
        tempA(road2VehIdx) = 1;
        tempA( ijIdx ) = -1 * BIG_NUM;
        A = [A ; tempA];
        b = [b ; -dt2];
        %eq 9
        tempA = zeros( 1, decisionVarNum);
        tempA(road1VehIdx) = 1;
        tempA(road2VehIdx) = -1;
        tempA( ijIdx ) =  BIG_NUM;
        A = [A ; tempA];
        b = [b ; -dt2 + BIG_NUM];
        ijIdx = ijIdx + 1;
    end   
end

%  xi - x <= 0
for i = 1: 1: M + N
    tempA = zeros( 1, decisionVarNum);
    tempA(i) = 1;
    tempA(decisionVarNum) = -1;
    A = [A ; tempA];
    b = [b ; 0];
end
Aeq = []; beq = [];
tic;
MILPAssignTime = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
toc;
MILPrunTime = toc;
end

