% dp1 ： S（X, X ,1） 选择为道路为1的state， dp2 同理
% sol ： 最后一辆车的通过时刻， 
%dpAssignTime : 各个车通过的时刻
%roadDecision : 每次选择放行的道
function [dp1,dp2, DPmaxAssignTime,DPAssignTime,DPrunTime,roadDecision] = dpMethod(dt1, dt2,initState)

vehInfoRoad1 = initState( initState( : , 2 ) == 1, : );
vehInfoRoad2 = initState( initState( : , 2 ) == 2, : );
minBound1 = vehInfoRoad1(:, 4); % 1车道车辆最早到达时刻
maxBound1 = vehInfoRoad1(:, 5); % 1车道车辆最晚到达时刻
minBound2 = vehInfoRoad2(:, 4); % 2车道车辆最早到达时刻
maxBound2 = vehInfoRoad2(:, 5); % 2车道车辆最晚到达时刻
vehNumOnRoad1 = length( vehInfoRoad1 );
vehNumOnRoad2 = length( vehInfoRoad2 );
%% init dp table

dp1 = zeros(vehNumOnRoad1 + 1, vehNumOnRoad2 + 1);
dp1(:, :) = Inf;
dp2= zeros(vehNumOnRoad1 + 1, vehNumOnRoad2 + 1);
dp2(:, :) = Inf;
%dp1 init
dp1(1 + 1, 0 +1) = minBound1(1);
for i = 2:1:vehNumOnRoad1
    dp1(i + 1, 0 + 1) = min( max( minBound1( i ) , dp1( i - 1 + 1, 0 +1) + dt1 ) , maxBound1( i ) );
end
% dp2 init
dp2(0 + 1, 1 + 1) = minBound2(1);
for i = 2:1:vehNumOnRoad2
    dp2(0 + 1, i + 1) = min( max( minBound2( i ) , dp2( 0 +1 , i - 1 + 1) + dt1 ) , maxBound2( i ) );
end


%% dp calculate
tic;
MAX_STAGE = vehNumOnRoad1 + vehNumOnRoad2; %总共stage数
for nowStage = 2:1:MAX_STAGE
    for m = 1 : 1 : nowStage-1 % (0,X) 和 （X,0）都不需要算
        n = nowStage - m;
        if m <= vehNumOnRoad1 && n <= vehNumOnRoad2 
            %更新dp1
            %上一次选得是1，尝试从dp1来更新 from up
            if dp1( m-1 +1, n +1 ) ~= Inf
                updateVal = min( max( minBound1( m ), dp1( m-1 +1, n +1) + dt1 ) , maxBound1( m ) );
                dp1(m +1, n +1) = min (dp1( m +1, n +1 ) , updateVal );
            end
            %上一次选得是2，尝试从dp2来更新 from up
             if dp2( m-1 +1, n +1 ) ~= Inf
                 updateVal = min( max( minBound1( m ), dp2( m-1 +1, n +1) + dt2 ) , maxBound1( m ) );
                 dp1(m +1, n +1) = min (dp1( m +1, n +1 ) , updateVal); 
             end
            
             %更新dp2
            %上一次选得是1，尝试从dp1来更新 from left
            if dp1( m +1, n-1 +1 ) ~= Inf
                updateVal = min( max( minBound2( n ), dp1( m +1, n-1 +1) + dt2 ) , maxBound2( n ) );
                dp2(m +1, n +1) = min (dp2( m +1, n +1 ) ,updateVal );
            end
            %上一次选得是2，尝试从dp2来更新 from left
             if dp2( m +1, n-1 +1 ) ~= Inf
                 updateVal = min( max( minBound2( n ), dp2( m +1, n-1 +1) + dt1 ) , maxBound2( n ) );
                 dp2(m +1, n +1) = min (dp2( m +1, n +1 ) , updateVal); 
            end
             
        end
    end
end
DPmaxAssignTime = min( dp1( vehNumOnRoad1 + 1,vehNumOnRoad2 + 1 ),dp2(vehNumOnRoad1 + 1 ,vehNumOnRoad2 + 1 ) );
toc;
DPrunTime = toc;
%% 自底向上回溯决策
roadDecision = zeros( MAX_STAGE, 1 );
DPAssignTime = zeros( MAX_STAGE, 1 );
M = vehNumOnRoad1 ;
N = vehNumOnRoad2 ;
m = M;
n = N;
for i = MAX_STAGE: -1 : 1
    if dp1( m + 1, n + 1 ) < dp2 ( m +1, n + 1 )
        roadDecision(i) = 1;
        DPAssignTime(i) = dp1( m + 1, n + 1);
        m = m - 1;
    else
        roadDecision(i) = 2;
        DPAssignTime(i) = dp2( m + 1, n + 1);
        n = n -1 ;
    end
end
end

