function [BB] = HoughFiltering(BB, mask,im)
plot_lines = 1;
plot_circles = 0;
[ny,nx,~]=size(im);
nAngles = 8;
angle_range = 15;

signal_type = zeros(length(BB),4);
for b=1:length(BB)
    margin=3;
    % Check circles
    y=floor(BB(b).y)-margin; if y<1, y=1; end
    h=floor(BB(b).h)+2*margin; if h+y>ny, h=ny-y-1; end
    x=floor(BB(b).x)-margin; if x<1, x=1; end
    w=floor(BB(b).w)+2*margin; if w+x>nx, w=nx-x-1; end
    gray_im = mean(im,3);
    owindow = gray_im(y:y+h,x:x+w);
    if h>w, s=h; else, s=w; end
    owindow=imresize(owindow,[s s]);
    [accum, circen, cirrad] = CircularHough_Grd(owindow, round([s/4 s/2]));
    if size(circen,1)>0 &size(circen,1) < 3
        signal_type(b,3)= max(min(circen>=s/4 & circen<=s*3/4,[],2));
    end
    if plot_circles
        imshow(owindow,[0 255],'InitialMagnification',500);
        hold on;
        plot(circen(:,1), circen(:,2), 'r+');
        for k = 1 : size(circen, 1)
            DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
        end
        pause;
        close;
    end
    
    % Check lines
    margin=0;
    y=floor(BB(b).y)-margin; if y<1, y=1; end
    h=floor(BB(b).h)+2*margin; if h+y>ny, h=ny-y; end
    x=floor(BB(b).x)-margin; if x<1, x=1; end
    w=floor(BB(b).w)+2*margin; if w+x>nx, w=nx-x; end
    owindow = mask(y:y+h,x:x+w);
    owindow_ext = zeros(size(owindow)+2);
    owindow_ext(2:end-1,2:end-1) = owindow;
    window = edge(owindow_ext,'canny');
    [H,T,R] = hough(window);%,'Theta',linspace(-90,89,72));
    P  = houghpeaks(H,nAngles);
    theta_peaks(b,:) = [max(T(P(:,2))<-90+angle_range | T(P(:,2))>90-angle_range)
        max(T(P(:,2))>=-27-angle_range & T(P(:,2))<-27+angle_range)
        max(T(P(:,2))>=-angle_range & T(P(:,2))<angle_range)
        max(T(P(:,2))>=27-angle_range & T(P(:,2))<27+angle_range)
        ]';
    if plot_lines
        lines = houghlines(window,T,R,P,'FillGap',round(BB(b).size/640),'MinLength',round(BB(b).size/1600));
        imshow(window);
        hold on
        max_len = 0;
        for k = 1:length(lines)
            xy = [lines(k).point1; lines(k).point2];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            
            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
            
            % Determine the endpoints of the longest line segment
            len = norm(lines(k).point1 - lines(k).point2);
            if ( len > max_len)
                max_len = len;
                xy_long = xy;
            end
        end
        theta_values = sort(T(P(:,2)));
        unique_idx=[-min(T(P(:,2)))-max(T(P(:,2)))>10 diff(sort(T(P(:,2))))>10];
        theta_values(unique_idx)
        %T(P(diff(sort(T(P(:,2))))<10,2))
        theta_peaks
        pause;
        close;
    end
    
    signal_type(b,:) = [theta_peaks(b,1)&theta_peaks(b,2)&theta_peaks(b,4)&~theta_peaks(b,3)
        theta_peaks(b,1)&theta_peaks(b,2)&theta_peaks(b,4)&~theta_peaks(b,3)
        signal_type(b,3)
        theta_peaks(b,1)&theta_peaks(b,3)&~theta_peaks(b,2)&~theta_peaks(b,4)
        ]';
end

BB = BB(logical(max(signal_type,[],2)));

if isempty(BB)
    BB=[];
end
end

