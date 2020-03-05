%2020/03/04 LI ChangSheng @ China 
%E-mail:sheng0619@163.com
% search the points of the surface based on mesh, 
% and find the toe of the slope by the farthest distance method.
%
%ref.
%[1]LI ChangSheng, YIN HongWei. The quantitative method of the thrust wedge based on mesh
%
%MATLAB R2017a, run this code

clear
clc
opengl hardwarebasic 
f=fullfile('.','lib');
addpath(genpath(f));

WinHeight =400; %figure size
WinLeft   = 100;
WinBottom = 100;
BackgroundColor = [1.0 1.0 1.0];
%--------------------------------------------------------------------------
xmax=60.0;
ymax=14.0;
colormap = '.\ColorVBOX.txt';
data_dir='.\data';
%--------------------------------------------------------------------------
%search .txt file
filename=findfiles(data_dir,'txt');
filename_ori=cs_cell2struct(filename);
filenum = size(filename_ori,1);

SlopHigh=zeros(filenum,1);
SlopeToe=zeros(filenum,1);
SlopeAngle=zeros(filenum,1);

for k=1:1:filenum
    fprintf('progress bar< %d/%d, %3.2f%%> \n',k,filenum, k/filenum*100.0);
    fprintf('\tREADING <%s> ...\n', filename_ori(k).name);
    filename_data = filename_ori(k).name;
    TIFfilename  = strrep(filename_data,'.txt','.tif');
    % x     y     r     color
    [A,B,C,D] = textread(filename_data,'%f %f %f %d');
    BALL=[A B C D];

    figure('visible','on')
	hold on;
    axis equal;
	figure_set( xmax, ymax, WinLeft, WinBottom, WinHeight, BackgroundColor);

	fprintf('\tdraw ball ...\n');
	plot_ball(BALL', xmax,ymax, colormap );

    X = BALL(:,1);
    Y = BALL(:,2);

    BallNum=size(BALL,1);
    dx=200.0e-3;%one grid size
    nx=ceil( (xmax-0.0) / dx);
  
%     %show mesh
%     for i=0.0:dx:xmax
%         plot([i i], [0 10], 'k-.');
%     end
    
    %surface Y value
    ycol=zeros(2,nx);
    for i=1:BallNum
        % check for top ball
        index = ceil( (X(i)-0.0) / dx );
        if ( Y(i) > ycol(1,index) )
            ycol(1,index) = Y(i);
            ycol(2,index) = i;
        end
    end
    ycol(:,end)=[];
    
    point=size(ycol,2);
    xyvalue=[];
    count=1;
    for i=1:point
            id = ycol(2,i);
            if (id > 0.1)
                xyvalue(count,1)=X(id);
                xyvalue(count,2)=Y(id);
                xyvalue(count,3)=id; % sphere id in the surface
                count=count+1;
            end
    end
    plot(xyvalue(:,1), xyvalue(:,2),'k-');

    %find higt point 
    %high point index 
    [m,highIndex]=max(xyvalue(:,2));
    highPoint=[xyvalue(highIndex,1) xyvalue(highIndex,2) ];
    plot(highPoint(1), highPoint(2),'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',6);
	text(highPoint(1)-2, highPoint(2)+2, strcat('(',num2str(highPoint(1),'%.1f'),', ',num2str(highPoint(2),'%.1f'),')'),'FontSize',10.5);

    endPoint=[xyvalue(end,1) xyvalue(end,2) ];
    %plot(endPoint(1), endPoint(2),'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',6);
    %text(endPoint(1), endPoint(2), strcat('endpoint(',num2str(endPoint(1),'%.1f'),', ',num2str(endPoint(2),'%.1f'),')'),'FontSize',10.5);

    %line hightPoint to endPoint
    %plot([ highPoint(1) endPoint(1)], [highPoint(2) endPoint(2)],'k','LineWidth',2.0)
    %
    %all the point in surface
    highPointToEndPoint=xyvalue(highIndex:end,:);

     %The distance from the point to the line
    for ( i=1:size(highPointToEndPoint,1) )
        Point=highPointToEndPoint(i,1:2);
        disp = abs(det([highPoint-endPoint;Point-endPoint]))/norm(highPoint-endPoint);
        highPointToEndPoint(i,6)=disp;
    end
     
    %toe of the thrust wedge, i.e.  the point  with the maximum distance from the line segment 
    [m,farIndex]=max(highPointToEndPoint(:,6));
    farPoint=[highPointToEndPoint(farIndex,1) highPointToEndPoint(farIndex,2) ];
    plot(farPoint(1), farPoint(2),'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',6);
    text(farPoint(1), farPoint(2)+1, strcat('(',num2str(farPoint(1),'%.1f'),', ',num2str(farPoint(2),'%.1f'),')'),'FontSize',10.5);
 
    %fit line
    %highindex to farindex
    highIndex=1;
    highFarIndexPoint=highPointToEndPoint(highIndex: farIndex,:);

    extNum=floor( (farIndex-highIndex)*0.2 );%Remove boundary points
    slopePoint=highFarIndexPoint( (highIndex+extNum) : (farIndex-extNum),:);

    x=slopePoint(:,1);
    y=slopePoint(:,2);
    [p,s] =polyfit(x,y,1);
    %p(1)*x+p(2)
    angle = abs ( rad2deg( atan(p(1)) ) );
    text((farPoint(1)+highPoint(1))/2, (farPoint(2)+highPoint(2))/2+2, strcat('{\it\alpha} ','= ',num2str(angle,'%.1f'),'бу'),'FontSize',12)

    f = polyval(p,x);

    %draw translucent line
    lw=0.5; % line width
    x=x';
    y=f';
    lw=lw/2; 
    lx=diff(x);
    ly=diff(y);
    lr=sqrt(lx.^2+ly.^2);
    lx=lx./lr;
    ly=ly./lr;
    X=x([2:end,end:-1:2])+lw*[ly,-ly(end:-1:1)];
    Y=y([2:end,end:-1:2])+lw*[-lx,lx(end:-1:1)];
    fill(X,Y,'-k','EdgeColor','none','FaceAlpha',0.5)

    %result
    SlopHigh(k)=highPoint(2);
    SlopeToe(k)=farPoint(1);
    SlopeAngle(k)=angle;

    %save figure
    axis([0 xmax+0.080 0 ymax]);
    set(gca,'Yaxislocation','Left');
    pageLength=14;%cm
    pageHigh=pageLength/(xmax-0)*ymax;
    set(gcf, 'Units','centimeters', 'Position',[5 5 pageLength+1.5 pageHigh+1.5])
    set(gcf, 'PaperPositionMode','auto')
    set(gca,'units','centimeters');
    set(gca,'position',[1 1 pageLength pageHigh])
    print(gcf,'-dtiff','-r600',TIFfilename);
    close(gcf);
    
end
