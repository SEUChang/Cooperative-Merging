%%
%�������㲴�ɷֲ��ĳ���ʱ��ĳ������״̬
%���ɹ��̲ο���https://blog.csdn.net/COCO56/article/details/99714313
%===========================����˵��===========================%
% initiState:
% N*6���󣬵�һ��Ϊ����ʱ�̣��ڶ���Ϊ������·,������Ϊ��ʼ�ٶȣ��������������ʱ�̣��������������ʱ��,�����У�����ID�ţ�
% size1��size2 ��·/��·�ϳ�������
% lambda �� ��λʱ�䳵���ﵽ�� Lam veh/ (s* lane)
% Tmax : ��������ֵ�����ʱ�� (��λ��s)��Ҳ���Ƿ�����ʱ��
% dis ���������򳤶�
% Vmin , Vmax ������������С�ٶȣ�mps��
%%
function [initState, size1, size2] = creatInitState(lambda,Tmax, dis ,vmin, vmax, amin, amax)
    %=====���ɵ�һ�飬��·�ϳ�������ʱ��====%
    i = 1;
    initState1(1,1) =  exprnd(1/lambda);
    while(initState1(i,1)< Tmax)
        initState1(i + 1,1) = initState1(i,1) +  exprnd(1/lambda);%������һ�����ĳ���ʱ��
        i = i +1;
    end
    initState1(:,2) = 1;%��һ�б�ʾ����ʱ�䣬�ڶ���Ϊ������·
    initState1 = initState1(initState1(:,1) <=Tmax,:);%�޳���Tmax֮����ֵĳ���
    size1 = length(initState1(:,1));%road1����ʻ�ĳ�����
    %=====���ɵڶ��飬��·�ϳ�������ʱ��====%
    i = 1;
    initState2(1,1) =  exprnd(1/lambda);
    while(initState2(i,1)< Tmax)
        initState2(i + 1,1) = initState2(i,1) +  exprnd(1/lambda);
        i = i +1;
    end
    initState2(:,2) = 2;
    initState2 = initState2(initState2(:,1) <=Tmax,:);
    size2 = length(initState2(:,1));
    %=====���ظ���������Ϣ====%
%     initState = [initState1(initState1(:,1) < Tmax, :);
%         initState2(initState2(:,1) < Tmax, :)] ;%�޳�����ʱ������Tmax�ĳ�
    initState = [initState1;initState2];
    size_ = size1 + size2;
    initState(:,3) = vmin + (vmax - vmin) * rand(size_,1);%��������ٶ�
    initState = sortrows(initState);%���ݳ���ʱ������
    
%%  ����tmin tmax �߽�ֵ ID��
for i = 1: 1: size_
    initState(i, 6) = i;%����ID��
    t0 = initState(i, 1);
    v0 = initState(i , 3);
    [tmin, tmax] = timeBound(t0, dis , v0, vmin, vmax, amin, amax);
    initState( i, 4 ) = tmin;
    initState( i, 5 ) = tmax;
end
%���������������ĳ�����Ϣ
% initStateOnRoad1 = initState( initState(:,2) == 1,: );
% initStateOnRoad2 = initState( initState(:,2) == 2,: );
end


