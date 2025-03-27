function [below_min, above_max] = rx_start_time_histogram(data, x_lim, y_lim, bin_width, x_label, y_label, plot_title, filestr)
    
    data = data - round(data);

    min_val = x_lim(1);
    max_val = x_lim(2);

    % Compute bin edges and counts
    N = round((x_lim(2) - x_lim(1)) / bin_width);   
    bin_edges = x_lim(1) + (0:N) * bin_width; 
    hist_data = zeros(1, N); 

    below_min = sum(data < min_val);
    above_max = sum(data > max_val);
    total_values = length(data);

    fprintf('Total number of values: %d\n', total_values);
    fprintf('Values below min (%.2e): %d\n', min_val, below_min);
    fprintf('Values above max (%.2e): %d\n', max_val, above_max);

    for i = 1:total_values
        value = data(i);
        for j = 1:N
            if value >= bin_edges(j) && value <= bin_edges(j+1)
                hist_data(j) = hist_data(j) + 1;
                break;
            end
        end
    end
hist_data = 100*hist_data/length(data);

    % system_label = '';
    % if contains(lower(file_origin), 'gpsdo')
    %     system_label = 'GPSDO';
    % elseif contains(lower(file_origin), 'octo')
    %     system_label = 'OctoClock';
    % else
    %     system_label = 'UnknownSystem';
    % end

    
    figure('Position', [100, 100, 800, 600]);

        bar(bin_edges(1:N), hist_data, 'FaceColor', [0.2 0.6 0.8], ...
        'EdgeColor', 'k', 'BarWidth', 1);
    xlabel(x_label, 'FontSize', 14, 'FontWeight', 'bold');
    ylabel(y_label, 'FontSize', 14, 'FontWeight', 'bold');
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold');
    xlim(x_lim);
    ylim(y_lim);
    grid on;
    grid minor;
    set(gca, 'FontSize', 12, 'LineWidth', 1, 'Box', 'on', ...
        'GridAlpha', 0.5, 'MinorGridAlpha', 0.3); 
    set(gcf, 'Color', 'w'); 
    set(gca, 'XColor', 'k', 'YColor', 'k'); 


    folderPath = fileparts(filestr);
    filename = sprintf('%s\\%s.png',folderPath, plot_title);
    exportgraphics(gcf, filename, 'Resolution', 300);
    close(gcf);
end

