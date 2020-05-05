% dp1 �� S��X, X ,1�� ѡ��Ϊ��·Ϊ1��state�� dp2 ͬ��
% sol �� ���һ������ͨ��ʱ�̣� 
%dpAssignTime : ������ͨ����ʱ��
%roadDecision : ÿ��ѡ����еĵ�
function [dp1,dp2, DPmaxAssignTime,DPAssignTime,DPrunTime,roadDecision] = dpMethod(dt1, dt2,initState)

vehInfoRoad1 = initState( initState( : , 2 ) == 1, : );
vehInfoRoad2 = initState( initState( : , 2 ) == 2, : );
minBound1 = vehInfoRoad1(:, 4); % 1�����������絽��ʱ��
maxBound1 = vehInfoRoad1(:, 5); % 1��������������ʱ��
minBound2 = vehInfoRoad2(:, 4); % 2�����������絽��ʱ��
maxBound2 = vehInfoRoad2(:, 5); % 2��������������ʱ��
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
MAX_STAGE = vehNumOnRoad1 + vehNumOnRoad2; %�ܹ�stage��
for nowStage = 2:1:MAX_STAGE
    for m = 1 : 1 : nowStage-1 % (0,X) �� ��X,0��������Ҫ��
        n = nowStage - m;
        if m <= vehNumOnRoad1 && n <= vehNumOnRoad2 
            %����dp1
            %��һ��ѡ����1�����Դ�dp1������ from up
            if dp1( m-1 +1, n +1 ) ~= Inf
                updateVal = min( max( minBound1( m ), dp1( m-1 +1, n +1) + dt1 ) , maxBound1( m ) );
                dp1(m +1, n +1) = min (dp1( m +1, n +1 ) , updateVal );
            end
            %��һ��ѡ����2�����Դ�dp2������ from up
             if dp2( m-1 +1, n +1 ) ~= Inf
                 updateVal = min( max( minBound1( m ), dp2( m-1 +1, n +1) + dt2 ) , maxBound1( m ) );
                 dp1(m +1, n +1) = min (dp1( m +1, n +1 ) , updateVal); 
             end
            
             %����dp2
            %��һ��ѡ����1�����Դ�dp1������ from left
            if dp1( m +1, n-1 +1 ) ~= Inf
                updateVal = min( max( minBound2( n ), dp1( m +1, n-1 +1) + dt2 ) , maxBound2( n ) );
                dp2(m +1, n +1) = min (dp2( m +1, n +1 ) ,updateVal );
            end
            %��һ��ѡ����2�����Դ�dp2������ from left
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
%% �Ե����ϻ��ݾ���
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

