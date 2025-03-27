function [bin_counts, bin_edges, data_var, data_std, data_mean] = my_histogram( ...
    data, bin_width, x_lim, y_lim, x_label, y_label, plot_title, filestr,... 
     annotate_ns)

    % Ensure row vector
    if iscolumn(data)
        data = data';
    end

    % Compute bin edges and counts
    N = round((x_lim(2) - x_lim(1)) / bin_width);   
    bin_edges = x_lim(1) + (0:N) * bin_width; 
    hist_data = zeros(1, N); 

    for i = 1:length(data)
        temp = bin_edges > data(i);
        idx = find(temp == 1, 1);
        if ~isempty(idx) && idx <= N
            hist_data(idx) = hist_data(idx) + 1;
        end
    end
    hist_data(idx) = 100*hist_data(idx)/length(data);

    % Compute stats only for values within x-limits
    filtered_data = data(data >= x_lim(1) & data <= x_lim(2));
    if isempty(filtered_data)
        data_mean = NaN;
        data_var = NaN;
        data_std = NaN;
        warning('No data points found within x-limits.');
    else
        data_mean = mean(filtered_data);
        data_var = var(filtered_data);
        data_std = std(filtered_data);
    end

    
    
    
    % Plot
    figure('Position', [100, 100, 800, 600]);

    bar(bin_edges(1:N), hist_data, 'FaceColor', [0.2 0.6 0.8], ...
        'EdgeColor', 'k', 'BarWidth', 1);

    xlabel(x_label, 'FontSize', 14, 'FontWeight', 'bold');
    ylabel(y_label, 'FontSize', 14, 'FontWeight', 'bold');
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold');

    ylim(y_lim);
    grid minor;
    set(gca, 'FontSize', 12, 'LineWidth', 1, 'Box', 'on', ...
        'GridAlpha', 0.5, 'MinorGridAlpha', 0.3); 
    set(gcf, 'Color', 'w'); 
    set(gca, 'XColor', 'k', 'YColor', 'k'); 

    % Conditionally annotate bars with ns values
    if annotate_ns
        for i = 1:N
            hold on
            if hist_data(i) > 0
                text(bin_edges(i), hist_data(i) + 0.01 * max(y_lim), ...
                    sprintf('%.0fns', bin_edges(i) * 1e9), ...
                    'FontSize', 10, 'FontWeight', 'bold', ...
                    'HorizontalAlignment', 'left', ...
                    'EdgeColor', 'k', 'Margin', 2);
            end
        end
    end

    % Display mean in top-left corner
    y_lims = ylim;
    x_lims = xlim;
    text_pos_x = x_lims(1) + 0.02 * (x_lims(2) - x_lims(1));
    text_pos_y = y_lims(2) - 0.05 * (y_lims(2) - y_lims(1));
    mean_str = sprintf('Mean: %.0f, std :%.0f', data_mean * 1e9,  data_std*1e9);
    text(text_pos_x, text_pos_y, mean_str, ...
        'FontSize', 12, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', 'w', 'EdgeColor', 'k', 'Margin', 4);

    % Save the plot
    folderPath = fileparts(filestr);
    filename = sprintf('%s\\%s.png',folderPath, plot_title);
    exportgraphics(gcf, filename, 'Resolution', 300);
    close(gcf);

    % Output
    bin_counts = hist_data;
end

