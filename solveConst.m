function res = solveConst(P0,Pf,T0,Tm,V0,Vf)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
T = [1/6*T0^3,0.5*T0^2,T0,1;
    0.5*T0^2,T0,1,0;
    1/6*Tm^3,0.5*Tm^2,Tm,1;
    0.5*Tm^2,Tm,1,0];
q = [P0;V0;Pf;Vf];
res = T\q;
end

 