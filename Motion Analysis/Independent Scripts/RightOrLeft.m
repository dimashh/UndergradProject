%This function accepts two vectors and two variables that correspond to
%left and right turn counts.
%It works out the determinant of the two vectors.
%The result is used to calculate the angle between the vectors with the
%functions atand2d()
%The value of the determinant is also used to decide if it was a right or a
%left turn. A negative result indicates it was right turn. A positive
%result indicates a left turn. Their counts are increased if the conditions
%are met.
function [TurnDegree,rightCount, leftCount] = RightOrLeft(vector1, vector2, right, left)
    determinant = det([vector1; vector2]);
    vectorAngle = atan2d(determinant, dot(vector1,vector2));
    
    %The following checks are needed to resolve the exception situations
    %where the sign of the result is reversed. So to get the right results
    %these statements check if they have occurred and fix the result. Note
    %that it only happens when the object does a uturn and starts moving 
    %in the opposite direction.
    if((vector1(1)>0&&vector1(2)<0)&&(vector2(1)<0&&vector2(2)>0)&&abs(vectorAngle)>=150)
        vectorAngle = -(vectorAngle);
    elseif(((vector1(1)<0&&vector1(2)<0)&&(vector2(1)>0&&vector2(2)>0)&&abs(vectorAngle)>=150))
        vectorAngle = -(vectorAngle);
    elseif((vector1(1)>0&&vector1(2)>0)&&(vector2(1)<0&&vector2(2)<0)&&abs(vectorAngle)>=150)
        vectorAngle = -(vectorAngle);
    end
    
    if(vectorAngle<0)
        right = right+1;
    elseif(vectorAngle>0)
        left=left+1;
    end
    
    %The results are set as follows and returned at the end.
    rightCount = right;
    leftCount = left;
    TurnDegree = vectorAngle;
end