function [theta_start theta_end] = get_scan_angle(simage, xc, yc, rmax, offset_theta)

[rows cols] = size(simage);

if yc <= (rows - yc) && rmax.direction == 'l' % scan down & left
    theta_start = pi + offset_theta;
elseif yc > (rows - yc) && rmax.direction == 'l' % scan up & left
    theta_start = (pi / 2) + offset_theta;
elseif yc <= (rows - yc) && rmax.direction == 'r' % scan down & right
    theta_start = (3 / 2 * pi) + offset_theta;
elseif yc > (rows - yc) && rmax.direction == 'r' % scan up & right
    theta_start = offset_theta;
end
theta_end = theta_start + (pi / 2);

return