function az1_360 = quad_pi_scan(az1)

n = size(az1,1);
az1_360 = zeros(4*(n-1)+1,2);

for i = 1 : n
    az1_360(i,:) = az1(i,:);    % duplicate copy (theta // intensity)
       
    % opposite quadrant
    if az1(i,1) <= pi
        az1_360(i+(2*(n-1)),1) = az1(i,1) + pi; 
    else
        az1_360(i+(2*(n-1)),1) = az1(i,1) - pi;        
    end
    az1_360(i+(2*(n-1)),2) = az1(i,2);
    
    if i < n
        % the next quadrant
        if az1(i+1,1) <= 3/2*pi            
            az1_360(i+n,1) = az1(i+1,1) + pi/2;                       
        else
            az1_360(i+n,1) = az1(i+1,1) - 3/2*pi;                        
        end
        az1_360(i+n,2) = az1(n-i,2);
        
        % the previous quadrant
        if az1(i,1) >= pi/2
            az1_360(i+3*n-2,1) = az1(i+1,1) - pi/2;
        else
            az1_360(i+3*n-2,1) = az1(i+1,1) + 3/2*pi;
        end
        az1_360(i+3*n-2,2) = az1(n-i,2);
    end
end
                    
return