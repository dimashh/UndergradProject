%Following script establishes a TCP connection to port 19.
%Once it starts receiving data it will plot them accordingly.
%SwisTrack needs to be running and outputting captured data to port 19.

%TCPIP object is created which is associated with 'localhost' at port 19.
%Next a connection to it is opened. 
t = tcpip('localhost',19);
flushoutput(t);
fopen(t);
pause(.5);

%Empty matrices are iniatialised that will hold the data for each object.
coordinatesArray1 = [];
coordinatesArray2 = [];

%Plots are defined that will plot the paths for each tracked object.
%In this case it is set to 2 objects.
s1 = plot(0,0);
hold on;
s2 = plot(0,0);

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
        %match the object being tracked.
        %if they do then the object's number, x , y and trajectory are
        %saved to the corresponding array.
        %The coordinates for that object are plotted.
        
        if(strLine(2)=="0")
            coordinates = str2double(strLine(2:5));
            coordinatesArray1 = [coordinatesArray1; coordinates];
            fprintf(1,'%f \n', coordinates(:));
            s1.XData = coordinatesArray1(:,2);
            s1.YData = coordinatesArray1(:,3);
            drawnow
            
        elseif(strLine(2)==("1"))
            coordinates2 = str2double(strLine(2:5));
            coordinatesArray2 = [coordinatesArray2; coordinates2];
            s2.XData = coordinatesArray2(:,2);
            s2.YData = coordinatesArray2(:,3);
            drawnow
        end
    end
end
