function tassign = fifo(initState, dt1, dt2)
%用于计算 FIFO 策略下各车辆到达合流点的时刻
% 返回值： 第一列 ：到达合流点时刻
%          第二列 ： 计算所花费时长
% 参数值： initState ： 初始状态（初始时刻，所属道路，初始速度，最早到达时刻，最晚到达时刻）
%           dt1 ：同车道合流时间间隔
%           dt2 ：异车道合流时间间隔
vehNum = length(initState(:,1));%车辆数量
tmin = initState( :, 4 );
tmax = initState( :, 5 );
roadIdx = initState( : ,2);%所属道路
tassign = zeros(vehNum , 1);%车辆合流时刻
FIFOrunTime = zeros( vehNum, 1 );%程序运行时长

tassign(1) = tmin(1);%初始化第一辆车到达时刻，后面递推要用到，跑的贼几把快，耗时直接把tmin安排上

for idx = 2:1:vehNum
    tic;
    if roadIdx( idx ) == roadIdx (idx - 1)
        dt = dt1;
    else
        dt = dt2;
    end
    tassign( idx ) = min( max( tmin( idx ) , tassign( idx - 1 ) + dt ) , tmax( idx ) );
    toc;
    FIFOrunTime( idx ) = toc + FIFOrunTime( idx - 1 );
end
    tassign = [tassign, FIFOrunTime];
end

