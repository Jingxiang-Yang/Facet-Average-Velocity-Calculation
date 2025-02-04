%% This code is used to plot the knockdown time and average velocity curves.
clc;
clear;
%% Figure 4
Delta = readtable('D. melanogaster_DMdusts KT.xlsx','Range','B2:F111');%read the dataset of knockdown time.
ax1 = subplot(2,1,2);
x1=Delta{:,2};
x2=Delta{:,3};
x3=Delta{:,4};
x4=Delta{:,5};
y=Delta{:,1};
plot(ax1, x1,y,'.', x2,y,'.', x3,y,'.', x4,y,'.','MarkerSize',20)
pbaspect([2 1 1]) % relative lengths of each axis.
ax = gca;%ax. FontName= arial;
ax.FontSize = 25;% axis fontsize.
ax.LineWidth = 2;% axis LineWidth
xlabel('Time (min)','FontSize',25) %label fontsize
ylabel('Percentage Knockdown','FontSize',25) %label fontsize
xlim([100 700])
xticks(100:100:700)
yticks(0:25:100)
%% Figure 3
load 'D. melanogaster_DMdusts_velocity.mat'%read the dataset of average velocity.The data can be generated by  'Act_anals.m'
start=1;
final=700;
period=180;
xxx=(start:final);
yy1=sum(reshape(actv_velocity_m(1+(start-1)*period:final*period,2),period,final-start+1));
yy2=sum(reshape(actv_velocity_m(1+(start-1)*period:final*period,3),period,final-start+1));
yy3=sum(reshape(actv_velocity_m(1+(start-1)*period:final*period,4),period,final-start+1));
yy4=sum(reshape(actv_velocity_m(1+(start-1)*period:final*period,5),period,final-start+1));
yy5=sum(reshape(actv_velocity_m(1+(start-1)*period:final*period,6),period,final-start+1));
sy1=smoothdata(yy1,'gaussian');%smooth data
sy2=smoothdata(yy2,'gaussian');
sy3=smoothdata(yy3,'gaussian');
sy4=smoothdata(yy4,'gaussian');
sy5=smoothdata(yy5,'gaussian');
%% Figure 3A
ax1 = subplot(5,1,1);
plot(ax1,xxx,yy1,'.')
plot(ax1,xxx,yy1/4.6,'.',xxx,sy1/4.6,'-','MarkerSize',12, 'LineWidth',4)
pbaspect([3 1 1])
xlabel('Time (min)','FontSize',8)
ylabel('Average Velocity (cm/min)','FontSize',8)
xlim([0 700])
xticks(0:100:700)
ylim([0 0.4])
yticks(0:0.1:0.4)
%% Figure 3B
ax2 = subplot(5,1,2);
plot(ax2,xxx,yy2/4.6,'.',xxx,sy2/4.6,'-','MarkerSize',12, 'LineWidth',4)
pbaspect([3 1 1])
xlabel('Time (min)','FontSize',8)
ylabel('Average Velocity (cm/min)','FontSize',8)
xlim([0 700])
xticks(0:100:700)
ylim([0 0.2])
yticks(0:0.05:0.2)
%% Figure 3C
ax3 = subplot(5,1,3);
plot(ax3,xxx,yy3/4.6,'.',xxx,sy3/4.6,'-','MarkerSize',12, 'LineWidth',4)
pbaspect([3 1 1])
xlabel('Time (min)','FontSize',8)
ylabel('Average Velocity (cm/min)','FontSize',8)
xlim([0 700])
xticks(0:100:700)
ylim([0 0.4])
yticks(0:0.1:0.4)
%% Figure 3D
ax4 = subplot(5,1,4);
plot(ax4,xxx,yy4/4.6,'.',xxx,sy4/4.6,'-','MarkerSize',12, 'LineWidth',4)
pbaspect([3 1 1])
xlabel('Time (min)','FontSize',8)
ylabel('Average Velocity (cm/min)','FontSize',8)
xlim([0 700])
xticks(0:100:700)
ylim([0 0.3])
yticks(0:0.05:0.3)
%% Figure 3E
ax5 = subplot(5,1,5);
plot(ax5,xxx,yy5/4.6,'.',xxx,sy5/4.6,'-','MarkerSize',12, 'LineWidth',4)
pbaspect([3 1 1])
xlabel('Time (min)','FontSize',8)
ylabel('Average Velocity (cm/min)','FontSize',8)
xlim([0 700])
xticks(0:100:700)
ylim([0 0.4])
yticks(0:0.1:0.4)
%%
print -r300 Figure_3_4.tif
