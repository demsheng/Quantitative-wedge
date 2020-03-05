function figure_set( AxisRight, AxisHigh, WinLeft, WinBottom, WinHeight, BackgroundColor)
%2020/03/04 LI ChangSheng @ China 
%E-mail:sheng0619@163.com
%2017-03-09 Li ChangSheng set figure
    fsize = 12;
    set(gcf,'color', BackgroundColor );
    set(gca,'tickdir','out')
    set(gca,'TickLength',[0.01 0],'TickDir','out')
    set(gca,'box','on');
    set(gca,'Yaxislocation','right');
    set(gca,'FontSize',fsize);
    set(gca,'LineWidth',1.0)

    axis([0 AxisRight 0 AxisHigh]);
    axis tight;

	[intvalue] = 10;
    csxlabel={};
    j=1;
    for i=0:intvalue:AxisRight
        xlabel=i;
        csxlabel{j}=num2str(xlabel,'%.0f');
        j=j+1;
    end
    set(gca,'xtick',[0:intvalue:AxisRight],'Xticklabel',csxlabel)
    ax=gca;
    ax.XAxis.MinorTickValues=[0:floor(intvalue/10):AxisRight];

    [intvalue] = 5; 
    csylabel={};
    j=1;
    for i=0:intvalue:AxisHigh
        ylabel=i;
        csylabel{j}=num2str(ylabel);%,'%.1f'
        j=j+1;
    end
    set(gca,'ytick',[0:intvalue:AxisHigh],'Yticklabel',csylabel)
    ax.YAxis.MinorTickValues=[0:floor(intvalue/5):AxisHigh];
    set(gca,'xminortick','on');%style 5
    set(gca,'yminortick','on');%style 5

    WinWidth  = WinHeight * AxisRight/AxisHigh;
    set(gcf, 'position', [WinLeft WinBottom WinWidth WinHeight]);
    set(gca,'units','centimeters'); 
    q=get(gca,'position'); 
    q(1)=0.0;
    q(2)=1;
    set(gcf,'units','centimeters');
    figq(1)=5;
    figq(2)=5;
    figq(3)=q(3);
    figq(4)=q(4)+1.5;
    set(gcf,'position',figq)
    set(gca,'position',q)
end