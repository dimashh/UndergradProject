%The following script can be used post motion analysis to further
%investigate the data. It is designed for the output of realTimeAnalysis.m
%to process the data collected for two objects. However it can be adapted
%to fit the number needed. All it does is split the results of turn angles
%into into four sets. It separates the values of left and right turns into
%the ranges of 0<angle<90 and 90<angle<180. For the results acquired,
%fitdist() function is applied. This returns the mean and standard
%deviation numbers for the ranges of angles. Afterwards, they are plotted
%on a graph as a histogram distribution with normal distribution line
%fitted. The normal distribution line represents the values of fitdist()
%function. Finally, this is also done for the all the results of two
%objects together. It produces nine graphs in total, four for each robot
%corresponding to right and left turns, and one for the overall results.

robot1Turns = sort(angleTurns);
robot2Turns = sort(angleTurns2);

robot1GreatLeftTurns = angleTurns(find(angleTurns>90));
robot2GreatLeftTurns = angleTurns2(find(angleTurns2>90));
pd1GL = fitdist(robot1GreatLeftTurns,'normal');
pd2GL = fitdist(robot2GreatLeftTurns, 'normal');
figure
title('Distribution fit of robot1 for left turns greater than 90'); 
xlabel('Theta');
ylabel('Frequency');
hold on
h1 = histfit(robot1GreatLeftTurns,10,'normal');
set(h1(1),'facecolor','b'); set(h1(2),'color','red');
figure
title('Distribution fit of robot2 for left turns greater than 90');
xlabel('Theta');
ylabel('Frequency');
hold on;
h2 = histfit(robot2GreatLeftTurns,10,'normal'); 
set(h2(1),'facecolor','r'); set(h2(2),'color','blue');

robot1SmallLeftTurns = angleTurns(find((angleTurns>0)& angleTurns<90));
robot2SmallLeftTurns = angleTurns2(find((angleTurns2>0)& angleTurns2<90));
pd1SL = fitdist(robot1SmallLeftTurns,'normal');
pd2SL = fitdist(robot2SmallLeftTurns, 'normal');
figure
title('Distribution fit of robot1 for left turns between 0 and 90'); 
xlabel('Theta');
ylabel('Frequency');
hold on
h3 = histfit(robot1SmallLeftTurns,10,'normal');
set(h3(1),'facecolor','b'); set(h3(2),'color','red');
figure
title('Distribution fit of robot2 for left turns between 0 and 90');
xlabel('Theta');
ylabel('Frequency');
hold on;
h4 = histfit(robot2SmallLeftTurns,10,'normal'); 
set(h4(1),'facecolor','r'); set(h4(2),'color','blue');


robot1GreatRightTurns = angleTurns(find(angleTurns<-90));
robot2GreatRightTurns = angleTurns2(find(angleTurns2<-90));
pd1GR = fitdist(robot1GreatRightTurns,'normal');
pd2GR = fitdist(robot2GreatRightTurns, 'normal');
figure
title('Distribution fit of robot1 for right turns greater than 90'); 
xlabel('Theta');
ylabel('Frequency');
hold on
h5 = histfit(robot1GreatRightTurns,10,'normal');
set(h5(1),'facecolor','b'); set(h5(2),'color','red');
figure
title('Distribution fit of robot2 for rigth turns greater than 90');
xlabel('Theta');
ylabel('Frequency');
hold on;
h6 = histfit(robot2GreatRightTurns,10,'normal'); 
set(h6(1),'facecolor','r'); set(h6(2),'color','blue');




robot1SmallRightTurns = angleTurns(find((angleTurns<0)& (angleTurns>-90)));
robot2SmallRightTurns = angleTurns2(find((angleTurns2<0)& (angleTurns2>-90)));
pd1SR = fitdist(robot1SmallRightTurns,'normal');
pd2SR = fitdist(robot2SmallRightTurns, 'normal');
figure
title('Distribution fit of robot1 for right turns between 0 and 90'); 
xlabel('Theta');
ylabel('Frequency');
hold on
h7 = histfit(robot1SmallRightTurns,10,'normal');
set(h7(1),'facecolor','b'); set(h7(2),'color','red');
figure
title('Distribution fit of robot2 for right turns between 0 and 90');
xlabel('Theta');
ylabel('Frequency');
hold on;
h8 = histfit(robot2SmallRightTurns,10,'normal'); 
set(h8(1),'facecolor','r'); set(h8(2),'color','blue');

pdR1 = fitdist(angleTurns,'normal');
pdR2 = fitdist(angleTurns2, 'normal');

figure
hold on
title('Distribution fit of two robots for all turns'); 
xlabel('Theta');
ylabel('Frequency');
h9 = histfit(angleTurns,100,'normal');
set(h9(1),'facecolor','b'); set(h9(2),'color','green');
hold on;
h10 = histfit(angleTurns2,100,'normal'); 
set(h10(1),'facecolor','r'); set(h10(2),'color','yellow');


