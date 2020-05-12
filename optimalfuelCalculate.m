clc;
clear;
timeStep = 0.01;
fuelRate = importdata('fuelRate.mat');
newFuelRate = zeros(8000,45);
allVehFuelRate = zeros(8000,1);
sumFuel = zeros(8000,1);

for i = 1:1:8000
    for j = 1:1:45
        if fuelRate(i,j) < 0
            newFuelRate(i,j) = 0;
        else
            newFuelRate(i,j) = fuelRate(i,j);
        end
    end
end

for i = 1:1:8000
    allVehFuelRate(i) = sum( newFuelRate(i,:) );
end

for i = 2:1:8000
   sumFuel(i) = sumFuel(i-1) + timeStep*allVehFuelRate(i) ;
end
time = 0 :timeStep :80-timeStep;
figure(1);
plot(time,sumFuel);
            