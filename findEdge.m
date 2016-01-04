function [box_coord xLine] = findEdge(xind, yind, simage, user_I)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bd = mean(mean(simage(xind-2:xind+2, yind-2:yind+2)));
hor_bd = bd + user_I;
ver_bd = hor_bd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if simage(xind, yind) > hor_bd || simage(xind, yind) > ver_bd
    disp('bad starting point to search for the center');
    return
end

counter = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search is to find the most left index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% temporary indices
temp_x = xind;
temp_y = yind;

while counter < 10
    if simage(temp_x, temp_y) < hor_bd
        temp_y = temp_y - 1; % go left 1 index
        counter = 0;
    else
        temp_x = temp_x - 1; % go up 1 index
        counter = counter + 1;
    end
end
counter = 0;

while counter < 10
    if simage(temp_x, temp_y) < hor_bd
        temp_y = temp_y - 1;
        counter = 0;
    else
        temp_x = temp_x + 1; % go down 1 index
        counter = counter + 1;
    end
end
counter = 0;



LY = temp_y - 10;    % 5 indices for safety
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search is to find the most right index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% temporary indices
temp_x = xind;
temp_y = yind;



while counter < 10
    if simage(temp_x, temp_y) < hor_bd
        temp_y = temp_y + 1; % go right 1 index
        counter = 0;
    else
        temp_x = temp_x - 1; % go up 1 index
        counter = counter + 1;
    end
end
counter = 0;

while counter < 10
    if simage(temp_x, temp_y) < hor_bd
        temp_y = temp_y + 1;
        counter = 0;
    else
        temp_x = temp_x + 1; % go down 1 index
        counter = counter + 1;
    end
end



RY = temp_y + 10; % 5 indices for safety
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search is to find the most top index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% temporary indices
temp_x = xind;
temp_y = yind;

counter = 0;

while counter < 10
    if simage(temp_x, temp_y) < ver_bd
        temp_x = temp_x - 1; % go up 1 index
        counter = 0;
    else
        temp_y = temp_y - 1; % go left 1 index
        counter = counter + 1;
    end
end



counter = 0;

while counter < 10
    if simage(temp_x, temp_y) < ver_bd
        temp_x = temp_x - 1; % go up 1 index
        counter = 0;
    else
        temp_y = temp_y + 1; % go right 1 index 
        counter = counter + 1;
    end
end
counter = 0;

TX = temp_x - 2; % 3 indices for safety
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Search is to find the most bottom index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% temporary indices
temp_x = xind;
temp_y = yind;



while counter < 10
    if simage(temp_x, temp_y) < ver_bd
        temp_x = temp_x + 1; % go down 1 index
        counter = 0;
    else
        temp_y = temp_y - 1; % go left 1 index
        counter = counter + 1;
    end
end
counter = 0;



while counter < 10
    if simage(temp_x, temp_y) < ver_bd
        temp_x = temp_x + 1; % go down 1 index
        counter = 0;
    else
        temp_y = temp_y + 1; % go right 1 index 
        counter = counter + 1;
    end
end
counter = 0;

BX = temp_x + 2; % 3 indices for safety
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

box_coord = [TX LY; TX RY; BX LY; BX RY];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%












% get yline
hline = 10;
center = TX + floor((BX - TX) / 2);
% going 40 pixels left and right
h_arm = 40;

boxwidth = RY - LY;
scanwidth = boxwidth + (2 * h_arm);



for i = 1 : hline + 1
    for j = 1 : scanwidth + 1
%         if j >= h_arm && j <= h_arm + boxwidth
%             scanned(i,j) = 0;
%         else
            scanned(i,j) = simage(i+center-hline+1, j+LY-h_arm-1);
%         end
    end
end

% for i = 1 : size(scanned, 2)
%     sum_scanned(i) = sum(scanned);
% end

sum_scanned = sum(scanned);

movAve = 3;
Lstart = sum(sum_scanned(1:movAve));

Rstart = sum(sum_scanned(end-2:end));



Lcounter = 2;
while Lstart < sum(sum_scanned(Lcounter:Lcounter+2))
    Lcounter = Lcounter + 1;
    Lstart = sum(sum_scanned(Lcounter:Lcounter+2));
end



Rcounter = 1;
while Rstart < sum(sum_scanned(end-2-Rcounter:end-Rcounter))
    Rcounter = Rcounter + 1;
    Rstart = sum(sum_scanned(end-2-Rcounter:end-Rcounter));
end



yline = floor((((LY - h_arm) + Lcounter) + ((RY + h_arm) - Rcounter)) / 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Lstart = LY; % left y index
Rstart = RY; % right y index
Tstart = TX;
Bstart = BX;

% how far do we go?
h_arm = 5;
v_arm = 7;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ttt = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_counter = 0;
temp_RY = RY;
disp(strcat('TX ',num2str(TX)))
disp(strcat('BX ',num2str(BX)))
disp(strcat('temp ry ',num2str(temp_RY)))
disp(strcat('Size simage ',num2str(size(simage))))

while mean(simage(TX:BX, temp_RY)) > bd+ttt
    temp_RY = temp_RY + 5;
    r_counter = r_counter + 1;
end
rh_arm = r_counter + h_arm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l_counter = 0;
temp_LY = LY;
while mean(simage(TX:BX, temp_LY)) > bd+ttt
    temp_LY = temp_LY - 5;
    l_counter = l_counter + 1;
end
lh_arm = l_counter + h_arm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_counter = 0;
temp_TX = TX;
while mean(simage(temp_TX, LY:RY)) > bd+ttt
    temp_TX = temp_TX + 4;
    t_counter = t_counter + 1;
end
tv_arm = t_counter + v_arm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b_counter = 0;
temp_BX = BX;
while mean(simage(temp_BX, LY:RY)) > bd+ttt
    temp_BX = temp_BX - 4;
    b_counter = b_counter + 1;
end
bv_arm = b_counter + v_arm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rh_arm;
lh_arm;





j = 1;
for i = Lstart : -1 : Lstart - lh_arm
    m = find(simage(TX:BX, i) == max(simage(TX:BX, i)));
    m = m(ceil(length(m)/2));
    Lcenter_line(j) = TX + m - 1;
%     Lcenter_line(j) = TX + m(1) - 1;
    j = j + 1;
end

LXcoord = [ceil(mean(Lcenter_line(lh_arm - 5 : lh_arm))), LY];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - 10


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1;
for i = Rstart : 1 : Rstart + rh_arm
    m = find(simage(TX:BX, i) == max(simage(TX:BX, i)));
    m = m(ceil(length(m)/2));
    Rcenter_line(j) = TX + m - 1;
    j = j + 1;
end

RXcoord = [ceil(mean(Rcenter_line(rh_arm - 5 : rh_arm))), RY];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - 10

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1;

for i = Tstart : -1 : Tstart - v_arm
    m = find(simage(i, LY:RY) == min(simage(i, LY:RY)));
    m = m(ceil(length(m)/2));
    Tcenter_line(j) = LY + m - 1;
    j = j + 1;
end

TYcoord = [TX, ceil(mean(Tcenter_line(v_arm - 4 : v_arm)))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - 4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1;
for i = Bstart : 1 : Bstart + v_arm
    m = find(simage(i, LY:RY) == min(simage(i, LY:RY)));
    m = m(ceil(length(m)/2));
    Bcenter_line(j) = LY + m - 1;
    j = j + 1;
end

BYcoord = [BX, ceil(mean(Bcenter_line(v_arm - 4 : v_arm)))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - 4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Require that vertical line is perpendicular to horizontal line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slope of the horizontal line

if abs(RXcoord(2) - LXcoord(2)) ~= 0
    h_slope = (RXcoord(1) - LXcoord(1)) / (RXcoord(2) - LXcoord(2));
    % slope of the verticle requiring perpendicular to horizontal line
    v_slope = -(h_slope);
    % center line
        
    xl = LXcoord(1) - ceil(h_slope * LXcoord(2));
    xt = TYcoord(1) - ceil(v_slope * TYcoord(2));
    yc = yline;
    xc = ceil((h_slope * yc) + xl);
    
    b = yc + ceil(v_slope * xc);
    
    yb = ceil(v_slope * (BX - xc)) + yc;
    yt = ceil(v_slope * (TX - xc)) + yc;
    
%     yc = ceil((xt - xl) / (h_slope - v_slope));

    BYcoord = [BX yb];
    TYcoord = [TX yt];
else
    yb = TYcoord(2);
    x_length = LXcoord(1) - TYcoord(1);
    xb = (2 * x_length) + TYcoord(1);
    BYcoord = [xb yb];
end

xLine = [LXcoord; RXcoord; TYcoord; BYcoord; LY-lh_arm RY+rh_arm; xc yc];

return




    