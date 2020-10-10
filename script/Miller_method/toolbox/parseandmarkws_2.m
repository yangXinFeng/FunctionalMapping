function kept_pts=parseandmarkwsc(data,sc)
if exist('sc')==1,sc=sc*std(data)+mean(data);end
kept_pts=[];
key='n';
windowsize=5000;
curr_start=1;
fid2=figure;
moveon=0;
m_pos=[];
while moveon==0
    %plot data and marked points
    clf,plot(curr_start:(curr_start+windowsize-1),data(curr_start:(curr_start+windowsize-1)))
    if exist('sc')==1, hold on, plot(curr_start:(curr_start+windowsize-1),sc(curr_start:(curr_start+windowsize-1)),'r'), end
    axis([curr_start (curr_start+windowsize-1) mean(data)-1*std(data) mean(data)+10*std(data)])
    if any(and(kept_pts>curr_start,kept_pts<(curr_start+windowsize-1))),
        a=find(and(kept_pts>curr_start,kept_pts<(curr_start+windowsize-1)));
        hold on, plot(kept_pts(a),data(kept_pts(a)),'ro')
    end
    if and(m_pos>curr_start,m_pos<(curr_start+windowsize-1)),
        hold on, plot(m_pos,data(m_pos),'go')
    end
    title('click to mark, press ''y'' to keep selection, press ''q'' to quit')
    xlabel('press ''d'' to parse left and ''k'' to parse right, and ''j'' to jump to a timepoint')
    km=waitforbuttonpress;
    temp=get(fid2);
    temp2=get(gca);
    if km==0     %mouse
        m_pos=[floor(temp2.CurrentPoint(1,1))];
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    if key=='q'
        moveon=1;
    elseif key=='y'
        if exist('m_pos')==1
        	kept_pts=[kept_pts m_pos];
            m_pos=[];
        end
        key='n';
    elseif key=='d'
        if curr_start>(floor(windowsize/2)), curr_start=curr_start-(floor(windowsize/2)); key='n'; end
    elseif key=='k'
        if curr_start+(floor(windowsize/2))+windowsize<=length(data), curr_start=curr_start+(floor(windowsize/2)); key='n'; end        
    elseif key=='j'
        tmp=input('what datapoint would you like to jump to');
        if tmp+(floor(windowsize/2))<=length(data), curr_start=tmp; key='n'; else, disp('that index is too close to the end'), end        
    end
end
close