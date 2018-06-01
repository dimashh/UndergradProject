%This funtion accepts two intputs that contain a matrix with straight lines
%and a matrix that contains corresponing coordinates. It outputs a matrix
%with the resulting angles between the lines and two variables that
%represent the count of right and left turns.

function [turnAngles rightTurn leftTurn] = turningAngles(straight, fit)
%turningAngles will hold the resulting angles. Variable start is used to
%keep track of the starting posiotions of the lines that will be used to
%extract the required coordinates from coordinate matrix. 
%leftTurn and rightTurn are set to zero and will be incremented
%accordingly.
%The variable len gets the number of total lines and used to define the
%ending point of the foor loop
turnAngles =[];
start=1;
rightTurn = 0;
leftTurn = 0;
len = size(straight,1);
for i=1:1:len
    %As the loop begins variable j is initialised to i+1. It is used to
    %access the next line in the array. If its value exceeds len then loop
    %is exited.
    j=i+1;
    if(j>len)
        break;
    end
    
    %If j equals len then the loop has reached its end and the last two
    %lines from the first matrix are used for comparison. The process is
    %similar to normal process of the loop except that the two lines are
    %specified and their information is extracted accordingly. For better
    %understanding check the comments below.
    if(j==len)
        LineLength2 = straight(j,2) - straight(j,1)+1;
        start2 = length(fit) - LineLength2;
        LineEnd2 = length(fit);
        v2 = [fit(start2, 1), fit(start2, 2)]-[fit(LineEnd2, 1), fit(LineEnd2, 2)];
        
        LineLength = straight(i,2) - straight(i,1) + 1;
        start = start2 - LineLength;
        LineEnd = start2 - 1;
        v1 =[fit(start,1), fit(start,2)]-[fit(LineEnd, 1), fit(LineEnd, 2)] ;
        
        [angleV rightTurn leftTurn] = RightOrLeft(v1,v2,rightTurn,leftTurn);
        turnAngles = [turnAngles; angleV];  
    end
    
    %The main body of the looop. It starts by working the length of the
    %first line and its ending position. This is used to retrieve the X and
    %Y coordinates from the coordinate matrix. In total four points are
    %required: the X and Y points where the line begins, and X and Y points
    %where the line ends. These are subtracted from each other to worked
    %out the vector for that line. 
    %The same is done is for the second line(accessed by j).
    %Note how start, LineEnd and LineLength are used to keep track of the
    %positions of the required coordinates. Without this, wrong coordinates
    %will be obtained and the results will be incorrect.
    if(j<=len)
        LineLength = straight(i,2) - straight(i,1) + 1;
        LineEnd = start + LineLength - 1;
        x1 = fit(start,1);
        y1= fit(start,2);
        xEnd = fit(LineEnd, 1);
        yEnd = fit(LineEnd, 2);
        v1 =[fit(start,1), fit(start,2)]-[fit(LineEnd, 1), fit(LineEnd, 2)];

        LineLength2 = straight(j,2) - straight(j,1) + 1;
        LineEnd2 = LineLength2 + LineEnd;
        start2 = start + LineLength; 
        x2 = fit(start2,1);
        y2= fit(start2,2);
        x2End = fit(LineEnd2, 1);
        y2End = fit(LineEnd2, 2);
        v2 = [fit(start2, 1), fit(start2, 2)]-[fit(LineEnd2, 1), fit(LineEnd2, 2)];
        start = LineEnd+1; 
        
        %As the the loop keeps going the vectors worked out with left and
        %right counts are passed down to RightOrLeft() function that is
        %resposible for calculating the angles and incrementing the counts.
        %Once this is returned the results are saved and outputted.
        [angleV rightTurn leftTurn] = RightOrLeft(v1,v2,rightTurn,leftTurn);
        turnAngles = [turnAngles; angleV];     
    end
end
