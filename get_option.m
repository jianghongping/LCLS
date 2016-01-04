function [center_finding fitting_on_off fitting_range_option...
    image_plot azimuthal_plot fitting_plot everything_plot...
    herman_only_plot diameter_only_plot auto_offset] = get_option()

% Action options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Center finding - 1. Manual, 2. Automatic

% Option 1. Manual - 1. Manual theta offset (default), 2. Automatic theta offset
% Option 2. Automatic - 1. Automatic offset theta, 2. Manual offset theta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fitting Option - 1. Yes 2. No
% Option 1. Manul fitting range
% Option 2. Default fitting range
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot options

% if Fitting option is 'Yes'

% 1. Image plot with center location (default on) 1. On, 2. Off, 3.
% 2. Azimutha scan plot (default on) 1. On, 2. Off
% 3. Fitting plot (default on) 1. On, 2. Off
% 4. Herman + Std_Dev + Diameter (default on) 1. On, 2. Off
% 5. Hermans only plot (default off) 1. On, 2. Off
% 6. Diameter + Std_Dev only (default off) 1. On, 2. Off
% 7. Save all plots that are 'On', 1. On, 2. Off

% if Fitting option is 'No'

% 1. Image plot with center location (default on) 1. On, 2. Off
% 2. Azimutha scan plot (default on) 1. On, 2. Off
% 3. Hermans only plot (default on) 1. On, 2. Off
% 4. Save all plots that are 'On', 1. On, 2. Off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

center_finding = 1;
fitting_on_off = 1;
fitting_range_option = 1;
auto_offset = 1;

image_plot = 1;
azimuthal_plot = 1;
fitting_plot = 1;
everything_plot = 1;
herman_only_plot = 1;
diameter_only_plot = 1;
on = 'On';
off = 'Off';
selection = 9;
try_again = -1;

disp('Default option setting:');
if center_finding == 1
    disp('Semi-automatic center');
elseif center_finding == 0
    disp('Manual center input');
end

if fitting_on_off == 1
    disp('Fitting - On');
elseif fitting_on_off == 0
    disp('Fitting - Off');
end

if auto_offset == 1
    disp('Auto-find offset angle');
elseif auto_offset == 0
    disp('Manual offset input');
end

disp(' ');
disp('Plot options:');
disp('1. SAXS image plot - On');
disp('2. Azimuthal scan plot - On')
disp('3. Fitting plot - On');
disp('4. Hermans + Diameter plot - On');
disp('5. Hermans only plot - Off');
disp('6. Diameter only plot - Off');
disp(' ');

option_change = input('Enter to accept default setting, or anything else to change [Enter/*] -> ', 's');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while ~isempty(option_change)

    clc;
    disp(' ');
    disp('Center Finding Option:');
    disp('1 for Semi-automatic center.');
    disp('0 for Manual center input.');
    center_finding = input('Please make a selection [1/0] > ');
    disp(' ');
    disp('Fitting Option:');
    disp('1 for Fitting ''On');
    disp('0 for Fitting ''Off');
    fitting_on_off = input('Please make a selection [1/0] > ');
    disp(' ');
    disp('Offset Angle Input Option');
    disp('1 for Auto-search offset angle');
    disp('0 for Manually enter offset angle 1-by-1');
    auto_offset = input('Please make a selection [1/0] > ');

    if fitting_on_off == 1
        disp(' ');
        disp('Fitting Range Option:');
        disp('Enter for default fitting range.');
        disp('Anything else for manual fitting range.');
        fitting_range_option = input('Please make a selection [Enter/*] > ', 's');
        if isempty(fitting_range_option)
            fitting_range_option = 1;
        elseif ~isempty(fitting_range_option)
            fitting_range_option = 0;
        end
        disp(' ');
        herman_only_plot = 0;
        diameter_only_plot = 0;
    end


    if fitting_on_off == 1

        while selection > 0 && selection < 10

            disp(' ');
            disp('Plot Options')

            if image_plot == 1
                on_off = on;
            elseif image_plot == 0
                on_off = off;
            end
            disp(['1. SAXS image with center -> ' on_off]);

            if azimuthal_plot == 1
                on_off = on;
            elseif azimuthal_plot == 0
                on_off = off;
            end
            disp(['2. Azimuthal scan plot -> ' on_off]);

            if fitting_plot == 1
                on_off = on;
            elseif fitting_plot == 0
                on_off = off;
            end
            disp(['3. Fitting plot -> ' on_off]);

            if everything_plot == 1
                on_off = on;
            elseif everything_plot == 0
                on_off = off;
            end
            disp(['4. Hermans + Diameter -> ' on_off]);

            if herman_only_plot == 1
                on_off = on;
            elseif herman_only_plot == 0
                on_off = off;
            end
            disp(['5. Hermans only plot -> ' on_off]);

            if diameter_only_plot == 1
                on_off = on;
            elseif diameter_only_plot == 0
                on_off = off;
            end
            disp(['6. Diameter only plot -> ' on_off]);
            disp(' ');

            selection = input('Enter to accept or 1-6 to make a change [Enter/1-6] > ');
            if isempty(selection)
                selection = 10;
            end
            disp(' ');

            if selection == 1
                disp('SAXS images');
                image_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 2
                disp('Azimuthal scan plot');
                azimuthal_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 3
                disp('Fitting plot');
                fitting_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 4
                disp('Hermans orientation parameter & Diameter plots');
                everything_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 5
                disp('Hermans plot');
                herman_only_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 6
                disp('Diameter plot');
                diameter_only_plot = input('1 for On, 0 for Off [1/0] > ');
            end


            if selection == 10
                clc;
                disp('Summary of options:');
                disp(' ');
                if center_finding == 1
                    disp('Semi-automatic center');
                elseif center_finding == 0
                    disp('Manual center input');
                end

                if fitting_on_off == 1
                    disp('Fitting - On');
                    if fitting_range_option == 1
                        disp('Use default fitting range');
                    elseif fitting_range_option == 0
                        disp('Manual fitting range');
                    end

                elseif fitting_on_off == 0
                    disp('Fitting - Off');
                end
                
                if auto_offset == 1
                    disp('Auto-search offset angle');
                elseif auto_offset == 0
                    disp('Manual offset input');
                end

                disp(' ');

                if image_plot == 1
                    on_off = on;
                elseif image_plot == 0
                    on_off = off;
                end
                disp(['1. SAXS image with center -> ' on_off]);

                if azimuthal_plot == 1
                    on_off = on;
                elseif azimuthal_plot == 0
                    on_off = off;
                end
                disp(['2. Azimuthal scan plot -> ' on_off]);

                if fitting_plot == 1
                    on_off = on;
                elseif fitting_plot == 0
                    on_off = off;
                end
                disp(['3. Fitting plot -> ' on_off]);

                if everything_plot == 1
                    on_off = on;
                elseif everything_plot == 0
                    on_off = off;
                end
                disp(['4. Hermans + Diameter -> ' on_off]);

                if herman_only_plot == 1
                    on_off = on;
                elseif herman_only_plot == 0
                    on_off = off;
                end
                disp(['5. Hermans only plot -> ' on_off]);

                if diameter_only_plot == 1
                    on_off = on;
                elseif diameter_only_plot == 0
                    on_off = off;
                end
                disp(['6. Diameter only plot -> ' on_off]);
                disp(' ');

            end
        end
    end

    if fitting_on_off == 0

        while selection > 0 && selection < 10
            disp(' ');
            disp('Plot Options')

            if image_plot == 1
                on_off = on;
            elseif image_plot == 0
                on_off = off;
            end
            disp(['1. SAXS image with center -> ' on_off]);

            if azimuthal_plot == 1
                on_off = on;
            elseif azimuthal_plot == 0
                on_off = off;
            end
            disp(['2. Azimuthal scan plot -> ' on_off]);

            if herman_only_plot == 1
                on_off = on;
            elseif herman_only_plot == 0
                on_off = off;
            end
            disp(['3. Hermans only plot -> ' on_off]);

            disp(' ');
            selection = input('Enter to accept or 1-3 to make a change [Enter/1-3] > ');
            if isempty(selection)
                selection = 10;
            end
            disp(' ');

            if selection == 1
                disp('SAXS images');
                image_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 2
                disp('Azimuthal scan plot');
                azimuthal_plot = input('1 for On, 0 for Off [1/0] > ');
            elseif selection == 3
                disp('Hermans plot');
                herman_only_plot = input('1 for On, 0 for Off [1/0] > ');
            end


            if selection == 10
                clc;
                disp('Summary of options:');
                disp(' ');
                if center_finding == 1
                    disp('Semi-automatic center');
                elseif center_finding == 0
                    disp('Manual center input');
                end
                
                if fitting_on_off == 1
                    disp('Fitting - On');
                    disp(' ');
                    if fitting_range_option == 1
                        disp('Use default fitting range');
                    elseif fitting_range_option == 0
                        disp('Manual fitting range');
                    end                    
                    
                elseif fitting_on_off == 0
                    disp('Fitting - Off');
                end
                
                if auto_offset == 1
                    disp('Auto-search offset angle');
                elseif auto_offset == 0
                    disp('Manual offset input');
                end
                disp(' ');

                if image_plot == 1
                    on_off = on;
                elseif image_plot == 0
                    on_off = off;
                end
                disp(['1. SAXS image with center -> ' on_off]);

                if azimuthal_plot == 1
                    on_off = on;
                elseif azimuthal_plot == 0
                    on_off = off;
                end
                disp(['2. Azimuthal scan plot -> ' on_off]);

                if herman_only_plot == 1
                    on_off = on;
                elseif herman_only_plot == 0
                    on_off = off;
                end
                disp(['3. Hermans only plot -> ' on_off]);
                disp(' ');
            end
        end
    end

    option_change = input('Enter to accept, anything else to make change [Enter/*] > ','s');
    if ~isempty(option_change)
        selection = 9;
    end
end











