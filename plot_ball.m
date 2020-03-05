 function [h] = plot_ball(balls,xmax,ymax,colorfile, varargin)
 %2020/03/04 LI ChangSheng @ China 
 %E-mail:sheng0619@163.com
 % change from  Tom Fournier, March 2010
 % radii change to real radii
 % LI Chang-Sheng, 2016/12/13
 
 % PLOT_BALL plot balls from RiceBal.  Colors are maintained.
 %
 % [h] = PLOT_BALL(balls,xmax,ymax,colorfile)
 %
 % INPUT
 %  balls = ball info; rows-[ x y z rad col]
 %
 %  Color given in the BALLS matrix (col) correspond to the following:
 %   0 = gray (0.85)
 %   1 = green (010)
 %   2 = yellow (110)
 %   3 = red (100)
 %   4 = white (1)
 %   5 = black (0.15)
 %   6 = medium gray (0.5)
 %   7 = blue (001)
 %   8 = green/blue (011)
 %   9 = violet (101)
 %
 % OUTPUT
 %   h = handle structure for the ball patches
 %
 % Tom Fournier, March 2010

 olin = 'none';
 colmap = 0;         % use default RiceBal colors
 overlay = 0;        % color the balls
 csFaceAlpha=1; %
 i = 1;
 cres = 16;

 nball = size(balls,2);

 r=balls(3,:)';%radii
 
 % order colors
 if colmap == 0
  col = load(colorfile)';
  col=[col col col col col col col col];
  Gc = zeros(3*nball,numel(col));  
  clm = repmat((1+balls(4,:)).*3,3,1);clm(2,:) = clm(2,:)-1; clm(1,:) = clm(1,:)-2;
  row = 1:nball*3;
  ci = sub2ind(size(Gc),row(:),clm(:));
  Gc(ci) = 1;
  bcolor = Gc*col(:);
  bcolor = reshape(bcolor,3,nball);
 else
  bcolor = balls(4,:);    
 end
 
 % make circles
 % cres = 8;                     % now set in options
 % cirx = x + r*cos(t)
 % ciry = y + r*sin(t)
 theta = linspace(0,360,cres);
 stheta = sind(theta);
 ctheta = cosd(theta);
 circx = repmat(balls(1,:),cres,1) + repmat(r',cres,1).*repmat(ctheta',1,nball);
 circy = repmat(balls(2,:),cres,1) + repmat(r',cres,1).*repmat(stheta',1,nball);
 
 % order by color
 [v indco] = sort(balls(4,:));
 cvals = unique(balls(4,:));
 X = circx(:,indco);
 Y = circy(:,indco);
 col3 = bcolor(:,indco);

 if colmap  == 1 || overlay == 1   
     hold on;
     pat = patch(X,Y,col3,'edgecolor',olin);
     if overlay == 1
         set(pat,'facealpha',0);
     elseif ~isscalar(collim)
         set(gca,'clim',collim);
     end
 
 else
     hold on;
     pat = [];
     strti = 1;
     for i = 1:length(cvals)
         ind = find(balls(4,indco)==cvals(i),1,'last');
         %plot(X(:,strti:ind),Y(:,strti:ind),'color',col3(:,strti));
         %col3(:,strti)'
         p = patch(X(:,strti:ind),Y(:,strti:ind),col3(:,strti)','edgecolor',olin,'FaceAlpha',csFaceAlpha);%,'FaceColor','none');
         pat = [pat p];
         strti = ind+1;
     end
     
     %axis equal %tight
 end
 set(gca,'layer','bottom')
 axis equal
 %shading interp;
 %shading faceted;
 xl = [0.0 xmax];
 yl = [0.0 ymax];
 xlim(xl);
 ylim(yl);
 h = pat;
