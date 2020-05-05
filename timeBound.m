% aminһ��Ҫ�ǵ��Ǵ� ������ֵ���� ��ȥ ���������
%
function [tmin, tmax] = timeBound(t0, dis , v0, vmin, vmax, amin, amax)
% lower bound tmin calculate
if vmax^2 - v0 ^2 > 2 * amax * dis
    tmin = t0 + ( sqrt( v0^2 + 2 * amax * dis ) - v0 ) / amax;
else
    tmin = t0 + ( vmax - v0 ) / amax + ( dis - ( vmax^2 - v0^2 ) * 0.5 / amax ) / vmax ;
end

% upper bound tmax calculate
if (vmin^2 - v0 ^2) * 0.5 / amin  >   dis
    tmax = t0 + ( sqrt( v0^2 + 2 * amin * dis ) - v0 ) / amin;
else
    tmax = t0 + ( vmin - v0 ) / amin + ( dis - ( vmin^2 - v0^2 ) * 0.5 / amin ) / vmin ;
end

end

