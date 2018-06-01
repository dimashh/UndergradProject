%Create a TCPIP object and establish connection to localhost at port 19.
%It is essential that SwisTrack is running and tracking process is on.
t = tcpip('localhost',19);
flushoutput(t);
fopen(t);
pause(.5);

%Variables that will store the coordinates of the tracked objects.
coordinatesArray1 = [];
coordinatesArray2 = [];

%Initialising the figure and plot for the paths of the tracked objects.
figure(1)
hold on;
s1 = plot(0,0);
hold on;
s2 = plot(0,0);

%Variables that will store the results for the first object.
results =[];
straightResults=[];
Fitresults = [];
straightLines=[];
angleTurns = [];

%Variables that will store the results for the second object. 
results2 =[];
straightResults2=[];
Fitresults2 = [];
straightLines2=[];
angleTurns2= [];

%Variable responsible for the number of elements required to begin the the
%motion analysis execution. It can be adjusted to accordingly depending on
%the amount of frames required
arrTarget = 1000;

%While loop will keep processing the incoming data while it is being
%sent from SwisTrack.
%It reads the data and keeps the lines with lengths greater than 60
%characters.
%These lines are then split up at commas to be compared further.
while(1)
    Data = fscanf(t);
    if length(Data)>60
        strLine = strsplit(Data,','); 
        %the following if statements determine if the number of the object
        %match the object id being tracked.
        %if they do then the object's number, x , y and trajectory are
        %saved to the corresponding array.
        %The coordinates for that object are plotted.
        if(strLine(2)=="0")
            coordinates = str2double(strLine(2:5));
            coordinatesArray1 = [coordinatesArray1; coordinates];
            s1.XData = coordinatesArray1(:,2);
            s1.YData = coordinatesArray1(:,3);
            drawnow
            %Once the minimum number of frames has been captured the motion
            %analysis is executed.
            if(length(coordinatesArray1)==arrTarget)  
                
                %The following variables are initialised to represent 
                %the starting and ending positions for the line which is 
                %going to be tested for linearity.
                %It is set as the default length at the start and it will
                %be changing within the loop in cases longer straight 
                %movements are detected.
                i = 1;
                c = i+10;
                while(1)         
                    %If the ending position of the line being checked is 
                    %greater than the total of frames recorded then 
                    %then the loop breaks.
                    if(c>arrTarget)
                        break;
                    end
                    %If the ending position of the line being checked is 
                    %equal to the total of frames then details such X,Y 
                    %coordinates of the last two straight lines are saved 
                    %to Fitresults[]. Line specific data are also obtained 
                    %from straightResults[] and saved to straightLines[].
                    if (c==arrTarget)                          
                        xLine = coordinatesArray1(straightResults(end,1):straightResults(end,2),2);
                        yLine = coordinatesArray1(straightResults(end,1):straightResults(end,2),3);
                        LineCoef = polyfit(xLine,yLine,1);
                        LineFitY = polyval(LineCoef,xLine);
                        Fitresults = [Fitresults; xLine LineFitY];
                        straightLines = [straightLines; straightResults(end,:)];
                    end
                    %Main body of the loop which takes the X and Y values 
                    %for the default lengths defined at the start.
                    %For these points the coefficients of best fit 
                    %are worked out.
                    %Next, the Y values corresponding to the coefficients 
                    %and X points are obtained.
                    %Finally, the R-squared value for coefficient 
                    %determininant and slope of the line are calculated.                    
                    xdata = coordinatesArray1(i:c,2);
                    ydata = coordinatesArray1(i:c,3);
                    coeffs = polyfit(xdata, ydata, 1);
                    fittedY = polyval(coeffs, xdata);
                    [r2] = rsquare(ydata, fittedY);
                    slope = coeffs(:,1);

                    %The if statement compares the r2 value of the line
                    %to check if it is straight. Value of 1 indicates 
                    %complete linearity. In this case, 0.99 is used to 
                    %relax the definition of straightness.
                    %If it is true then the length of this line is 
                    %increased by 1. It is plotted and saved to 
                    %straightResults[]. straightResults[] contains all 
                    %the lines that are considered to be straight. 
                    %Note that it will contain multiple results for the 
                    %same points because long linear movement starts 
                    %off small. So everytime a line gets longer it is saved
                    %as the new potential straight line. 
                    %They are filtered out in the next statement. 
                    if(r2)>=0.99000
                        %This statement checks if straightResults[] is not
                        %empty and the beginning position of last line in 
                        %the array is less than the beginning position being 
                        %checked currently. If it is true, then it means a 
                        %new straight line has been detected.
                        %When this happens the last line is saved from 
                        %straightResults[] as one of final lines to 
                        %straightLines[]. Therefore,straightLines[] only 
                        %contains completed straight lines. 
                        %When saving the line details, the original 
                        %coordinates are used to get the computed values 
                        %for the staight line detected with polyfit() 
                        %and polyval() which are then saved to Fitresults[]
                        if(length(straightResults)>1 && straightResults(end,1)<i)
                            xLine = coordinatesArray1(straightResults(end,1):straightResults(end,2),2);
                            yLine = coordinatesArray1(straightResults(end,1):straightResults(end,2),3);
                            LineCoef = polyfit(xLine,yLine,1);
                            LineFitY = polyval(LineCoef,xLine);
                            Fitresults = [Fitresults; xLine LineFitY];
                            straightLines = [straightLines; straightResults(end,:)];            
                        end
                        c=c+1;
                        figure(1);
                        plot(xdata,fittedY, 'r-', 'LineWidth', 3);
                        hold on
                        straightResults = [straightResults; i c r2 slope];
                    end
                    
                    %If the r2 value is less than expected and the range 
                    %is bigger than before. Then we set the end of that 
                    %line to be the start of a new line and reset c to its 
                    %previous value. Otherwise, we just increment i and c 
                    %by one and try again.
                    if (r2)<=0.99000 
                        if (c-i>10)
                            i=c;
                            c=i+10;
                        else
                            i=i+1;
                            c=c+1;
                        end
                    end
                    %Record the results for all iterations for all the points
                    results = [results; i c r2  slope];
                end
                %The acquired data is passed to turningAngles function 
                %which returns all the degrees for the turns made between 
                %the straight lines found. As well as, the number of right 
                %and left turns for the data.
                %The returned results are used to plot a histogram 
                %distribution of the turns and the variance of r2 values 
                %for all the results.
                [angleTurns RightTurn LeftTurn] = turningAngles(straightLines, Fitresults);
                figure(2)
                histf(angleTurns(:,1),50);
                hold on
                figure(10)
                hold on
                plot(results(:,3));                
            end    
        end       
        
        %Same procedure described above is repeated for the object with id
        %1. Although, it is an inefficient approach it still achieves the
        %results needed. During further development, it should be
        %priorotised to optimise this section. 
        if(strLine(2)=="1")
            coordinates = str2double(strLine(2:5));
            coordinatesArray2 = [coordinatesArray2; coordinates];
            s2.XData = coordinatesArray2(:,2);
            s2.YData = coordinatesArray2(:,3);
            drawnow   
            if(length(coordinatesArray2)==arrTarget)
                i2 = 1;
                c2 = i2+10;
                while(1)
                    if (c2>arrTarget)
                        break;
                    end
                    if (c2==arrTarget)                          
                        xLine2 = coordinatesArray2(straightResults2(end,1):straightResults2(end,2),2);
                        yLine2 = coordinatesArray2(straightResults2(end,1):straightResults2(end,2),3);
                        LineCoef2 = polyfit(xLine2,yLine2,1);
                        LineFitY2 = polyval(LineCoef2,xLine2);
                        Fitresults2 = [Fitresults2; xLine2 LineFitY2];
                        straightLines2 = [straightLines2; straightResults2(end,:)]; 
                    end
                    xdata2 = coordinatesArray2(i2:c2,2);
                    ydata2 = coordinatesArray2(i2:c2,3);
                    coeffs2 = polyfit(xdata2, ydata2, 1);
                    fittedY2 = polyval(coeffs2, xdata2);
                    [r2] = rsquare(ydata2, fittedY2);
                    slope2 = coeffs2(:,1);

                    if(r2)>=0.99000
                        if(length(straightResults2)>1 && straightResults2(end,1)<i2)
                            xLine2 = coordinatesArray2(straightResults2(end,1):straightResults2(end,2),2);
                            yLine2 = coordinatesArray2(straightResults2(end,1):straightResults2(end,2),3);
                            LineCoef2 = polyfit(xLine2,yLine2,1);
                            LineFitY2 = polyval(LineCoef2,xLine2);
                            Fitresults2 = [Fitresults2; xLine2 LineFitY2];
                            straightLines2 = [straightLines2; straightResults2(end,:)];            
                        end
                        c2=c2+1;
                        figure(1);
                        plot(xdata2,fittedY2, 'b-', 'LineWidth', 3);
                        straightResults2 = [straightResults2; i2 c2 r2 slope2];
                    end
                    if (r2)<=0.99000 
                        if (c2-i2>10)
                            i2=c2;
                            c2=i2+10;
                        else
                            i2=i2+1;
                            c2=c2+1;
                        end
                    end
                    results2 = [results2; i2 c2 r2 slope2];
                end 
                [angleTurns2 RightTurn2 LeftTurn2] = turningAngles(straightLines2, Fitresults2);
                figure(2);
                histf(angleTurns2(:,1),50, 'facecolor','r');
                 figure(10)
                 plot(results2(:,3),'r');
            end
        end
    end
    

end
