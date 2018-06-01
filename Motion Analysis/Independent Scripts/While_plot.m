%This script loads the text file produced by SwisTrack as a demonstration.
%It can also load the data collected by the tcp_Con.m script. 
%After loading the data the X and Y coordinates are extracted. 

LabData = readtable('track_00000000.txt');
xData = LabData{:,2};
yData = LabData{:,3};

%Empty variable arrays are defined that will store the results.
results =[];
straightResults=[];

%More empty variable arrays are defined that will store final results
%needed, that will be passed on to turningAngles.m function.
Fitresults = [];
straightLines=[];

%The following variables are initialised to represent the starting and
%ending positions for the line which is going to be tested for linearity.
%It is set as the default length at the start and it will be changing
%within the loop in cases longer straight movements are detected.

i = 1;
c = i+10;
while 1
    %If the ending position of the line being checked is greater than the
    %total elements of coordinates (X and Y are equal) then the loop
    %breaks.
    if (c>length(xData))
        break;
    end
    
    %If the ending position of the line being checked is equal to the
    %total elements of coordinates then details such X,Y coordinates
    %of the last two straight lines are saved to Fitresults[].
    %Line specific data are also obtained from straightResults[] and saved
    %to straightLines[].
    if (c==length(xData))
        xLine = LabData{straightResults(end,1):straightResults(end,2),2};
        yLine = LabData{straightResults(end,1):straightResults(end,2),3};
        LineCoef = polyfit(xLine,yLine,1);
        LineFitY = polyval(LineCoef,xLine);
        Fitresults = [Fitresults; xLine LineFitY];
        straightLines = [straightLines; straightResults(end,:)];
    end
    
    %Main body of the loop which takes the X and Y values for the default
    %lengths defined at the start.
    %For these points the coefficients of best fit are worked out.
    %Next, the Y values corresponding to the coefficients and X points are
    %obtained.
    %Finally, the R-squared value for coefficient determininant and 
    %slope of the line are calculated.
    xdata = xData(i:c);
    ydata = yData(i:c);
    coeffs = polyfit(xdata, ydata, 1);
    fittedY = polyval(coeffs, xdata);
    [r2] = rsquare(ydata, fittedY);
    slope = coeffs(:,1);
    
    %The original points from captured frames are plotted to represent the path.
    plot(xdata, ydata, 'bo', 'LineWidth', 1, 'MarkerSize', 15);
    hold on;
    
    %The if statement compares the r2 value of the line to check if it is
    %straight. Value of 1 indicates complete linearity. In this case, 0.999
    %is used to relax the definition of straightness.
    %If it is true then the length of this line is increased by 1. It is
    %plotted and saved to straightResults[]. 
    %straightResults[] contains all the lines that are considered to be
    %straight. Note that it will contain multiple results for the 
    %same points because long linear movement starts off small. So 
    %everytime a line gets longer it is saved as the new potential 
    %straight line. They are filtered out in the next statement. 
    if (r2)>=0.99900
        %This statement checks if straightResults[] is not empty and the
        %beginning position of last line in the array is less than the 
        %beginning position being checked currently. 
        %If it is true, then it means a new straight line has been detected.
        %When this happens the last line is saved from straightResults[] as
        %one of final lines to straightLines[]. Therefore,straightLines[] 
        %only contains completed straight lines. 
        %When saving the line details, the original coordinates are used 
        %to get the computed values for the staight line detected 
        %with polyfit() and polyval() which are then saved to Fitresults[].
        if(length(straightResults)>1 && straightResults(end,1)<i)
            xLine = LabData{straightResults(end,1):straightResults(end,2),2};
            yLine = LabData{straightResults(end,1):straightResults(end,2),3};
            LineCoef = polyfit(xLine,yLine,1);
            LineFitY = polyval(LineCoef,xLine);
            Fitresults = [Fitresults; xLine LineFitY];
            straightLines = [straightLines; straightResults(end,:)];            
        end
        c=c+1;
        plot(xdata,fittedY, 'r-', 'LineWidth', 3);
        hold on;
        straightResults = [straightResults; i c r2 slope];
    end
    
    %If the r2 value is less than expected and the range is bigger
    %than before. Then we set the end of that line to be the start of a new
    %line and reset c to its previous value. Otherwise, we just increment i
    %and c by one and try again.
    if (r2)<=0.99900 
        if (c-i>10)
            i=c;
            c=i+10;
        else
            i=i+1;
            c=c+1;
        end
    end
    
    %Record the results for all iterations for all the points
    results = [results; i c r2 slope];
end

%The acquired data is passed to turningAngles function which returns all
%the degrees for the turns made between the straight lines found. As well
%as, the number of right and left turns for the data.
%The returned results are used to plot a histogram distribution of the
%turns and the variance of r2 values for all the results.
[angleTurns, RightTurn ,LeftTurn] = turningAngles(straightLines, Fitresults);
figure;
histogram(angleTurns(:,1),50);
title('Distibution of turning angles');
xlabel('Theta');
ylabel('Frequency');
figure;
plot(results(:,3));
title('Goodness of fit for the object');
xlabel('Frames');
ylabel('R-squared');
