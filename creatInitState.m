%%
%生成满足泊松分布的出现时间的车辆输出状态
%泊松过程参考了https://blog.csdn.net/COCO56/article/details/99714313
%===========================参数说明===========================%
% initiState:
% N*6矩阵，第一列为出现时刻，第二列为所属道路,第三列为初始速度，第四列最早合流时刻，第五列最晚合流时刻,第六列，车辆ID号，
% size1，size2 主路/辅路上车的数量
% lambda ： 单位时间车辆达到率 Lam veh/ (s* lane)
% Tmax : 所允许出现的最晚时刻 (单位：s)，也就是仿真的最长时间
% dis ：控制区域长度
% Vmin , Vmax 所允许的最大最小速度（mps）
%%
function [initState, size1, size2] = creatInitState(lambda,Tmax, dis ,vmin, vmax, amin, amax)
    %=====生成第一组，主路上车辆出现时刻====%
    i = 1;
    initState1(1,1) =  exprnd(1/lambda);
    while(initState1(i,1)< Tmax)
        initState1(i + 1,1) = initState1(i,1) +  exprnd(1/lambda);%计算下一辆车的出现时刻
        i = i +1;
    end
    initState1(:,2) = 1;%第一列表示出现时间，第二列为所属道路
    initState1 = initState1(initState1(:,1) <=Tmax,:);%剔除在Tmax之后出现的车辆
    size1 = length(initState1(:,1));%road1上行驶的车数量
    %=====生成第二组，辅路上车辆出现时刻====%
    i = 1;
    initState2(1,1) =  exprnd(1/lambda);
    while(initState2(i,1)< Tmax)
        initState2(i + 1,1) = initState2(i,1) +  exprnd(1/lambda);
        i = i +1;
    end
    initState2(:,2) = 2;
    initState2 = initState2(initState2(:,1) <=Tmax,:);
    size2 = length(initState2(:,1));
    %=====返回各个车辆信息====%
%     initState = [initState1(initState1(:,1) < Tmax, :);
%         initState2(initState2(:,1) < Tmax, :)] ;%剔除出现时间晚于Tmax的车
    initState = [initState1;initState2];
    size_ = size1 + size2;
    initState(:,3) = vmin + (vmax - vmin) * rand(size_,1);%生成随机速度
    initState = sortrows(initState);%根据出现时刻排序
    
%%  加入tmin tmax 边界值 ID号
for i = 1: 1: size_
    initState(i, 6) = i;%插入ID号
    t0 = initState(i, 1);
    v0 = initState(i , 3);
    [tmin, tmax] = timeBound(t0, dis , v0, vmin, vmax, amin, amax);
    initState( i, 4 ) = tmin;
    initState( i, 5 ) = tmax;
end
%输出各个车道上面的车的信息
% initStateOnRoad1 = initState( initState(:,2) == 1,: );
% initStateOnRoad2 = initState( initState(:,2) == 2,: );
end


