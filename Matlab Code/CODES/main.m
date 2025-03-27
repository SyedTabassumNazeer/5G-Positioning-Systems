close all
clear all
clc

% root_dir = 'C:\Users\user\Downloads\TOA_Measurements_num_samples_16384';
% datasets = [1,2,3];

root_dir = 'C:\Users\user\Downloads\TOA_Measurements_num_samples_8192';
datasets = [2,3,4,5];

systems = {'GPSDO','octoclock'};

%% Delete previous png files

for sidx = 1:length(systems)
    for didx = 1:length(datasets)
        filestr = sprintf("%s\\%s\\TOA_Measurements_Set-%d\\DATA\\*.png", root_dir,systems{sidx},datasets(didx));

        %delete previous png file
        delete(filestr);
    end
end



%% RTOA Plots
for sidx = 1:length(systems)
    for didx = 1:length(datasets)
        filestr = sprintf("%s\\%s\\TOA_Measurements_Set-%d\\DATA\\relative_toa1.mat", root_dir,systems{sidx},datasets(didx));
        data_struct = load(filestr);
        data = data_struct.relative_toa1;


        bin_width = 33e-9;
        x_lim = [-500e-9, 500e-9];
        y_lim = [0, 100];
        x_label = 'TOA (ns)';
        y_label = 'Frequency';
        plot_title = sprintf('Histogram of RTOA Set-%d-%s',datasets(didx),systems{sidx});

        annotate_ns = false; % or false

        [bin_counts, bin_edges, data_var, data_std, data_mean] = my_histogram( ...
            data, bin_width, x_lim, y_lim, ...
            x_label, y_label, plot_title,filestr, annotate_ns);
    end
end
%% Peak Values


% filename = 'C:\TOA_Measurments_2\Octo-Clock\TOA_Measurements_Set-3\DATA\correlation1.mat';
%
for sidx = 1:length(systems)
    for didx = 1:length(datasets)
        filestr = sprintf("%s\\%s\\TOA_Measurements_Set-%d\\DATA\\correlation1.mat", root_dir,systems{sidx},datasets(didx));

        data_struct = load(filestr);
        correlation_data = data_struct.correlation1;


        bin_width = 20;
        x_label = 'Correlation Peak Value';
        y_label = 'Percentage';
        x_lim = [0, 1400];
        y_lim = [0,100];
        plot_title = sprintf('Histogram of Correlation Peaks Set-%d-%s',datasets(didx),systems{sidx});


        correlation_histogram(correlation_data, bin_width, x_label, y_label, x_lim, y_lim, plot_title, filestr);

        % correlation_histogram(correlation_data, bin_width, x_label, y_label, x_lim, filename, save_dir);
    end
end
%% rx_start time

for sidx = 1:length(systems)
    for didx = 1:length(datasets)
        filestr = sprintf("%s\\%s\\TOA_Measurements_Set-%d\\DATA\\rx_start_time.mat", root_dir,systems{sidx},datasets(didx));

        data_struct = load(filestr);
        data = data_struct.rx_start_time;

        x_lim = [-500e-6, 50e-6];
        y_lim = [0,100];
        bin_width = 50e-6;
        x_label = 'Time (\mus)';
        y_label = 'Frequency';

        % set_info = regexp(filename, 'Set-\d+', 'match');
        % if ~isempty(set_info)
        %     set_name = set_info{1};
        % else
        %     set_name = 'Unknown-Set';
        % end
        plot_title = sprintf('Histogram of ADC switch on time (rx start time) Set-%d-%s',datasets(didx),systems{sidx});


        [below_min, above_max] = rx_start_time_histogram(data, x_lim, y_lim, bin_width, x_label, y_label, plot_title, filestr);
    end
end

%% 2D scatter plot of peak values vs toa



% toa_file = 'C:\TOA_Measurments_2\GPSDO\TOA_Measurements_Set-3\DATA\relative_toa1.mat';
% corr_file = 'C:\TOA_Measurments_2\GPSDO\TOA_Measurements_Set-3\DATA\correlation1.mat';
%
% toa_struct = load(toa_file);
% corr_struct = load(corr_file);
%
% relative_toa = toa_struct.relative_toa1;
% correlation_matrix = corr_struct.correlation1;
%
%
% file_origin = corr_file;  % used to extract Set info and system type
% save_dir = 'C:\TOA_Measurments_2\GPSDO\Scatter_plot';
% x_label = 'Relative TOA (\mus)';
% y_label = 'Correlation Peak Value';
% x_lim = [-0.2, 0.1];
% y_lim = [0, 1400];
%
%
% Scatter(relative_toa, correlation_matrix, file_origin, save_dir, x_label, y_label, x_lim, y_lim);
