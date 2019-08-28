clc, clear, close all

load 10-simulation.mat

figure
scatter3(qList(1,:), qList(2,:), qList(3,:), 'filled');
hold on
grid on
xlabel('Pull-wire displacement [m]');
ylabel('Axial rotation [rad]');
zlabel('Axial translation [m]');
xlim([0 16e-4]);
title('Configurations generated by RRT');
view(0,0);
set(gca,'FontSize',18);

