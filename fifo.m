function tassign = fifo(initState, dt1, dt2)
%���ڼ��� FIFO �����¸���������������ʱ��
% ����ֵ�� ��һ�� �����������ʱ��
%          �ڶ��� �� ����������ʱ��
% ����ֵ�� initState �� ��ʼ״̬����ʼʱ�̣�������·����ʼ�ٶȣ����絽��ʱ�̣�������ʱ�̣�
%           dt1 ��ͬ��������ʱ����
%           dt2 ���쳵������ʱ����
vehNum = length(initState(:,1));%��������
tmin = initState( :, 4 );
tmax = initState( :, 5 );
roadIdx = initState( : ,2);%������·
tassign = zeros(vehNum , 1);%��������ʱ��
FIFOrunTime = zeros( vehNum, 1 );%��������ʱ��

tassign(1) = tmin(1);%��ʼ����һ��������ʱ�̣��������Ҫ�õ����ܵ������ѿ죬��ʱֱ�Ӱ�tmin������

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

