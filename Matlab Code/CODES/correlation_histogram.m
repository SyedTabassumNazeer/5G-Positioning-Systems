function correlation_histogram(correlation_data, bin_width, x_label, y_label, x_lim, y_lim, plot_title, filestr)
    % Extract max correlation values from each row 
    row_max_values = max(correlation_data, [], 2);

    % Range of data
    min_val = min(row_max_values);
    max_val = max(row_max_values);
    total_values = length(row_max_values);
    
    fprintf('Total number of peak values (one per row): %d\n', total_values);

    % Compute bin edges and counts
    N = round((x_lim(2) - x_lim(1)) / bin_width);   
    bin_edges = x_lim(1) + (0:N) * bin_width; 
    hist_data = zeros(1, N); 

    
    % Fill histogram
    for i = 1:total_values
        value = row_max_values(i);
        for j = 1:N
            if value >= bin_edges(j) && value <= bin_edges(j+1)
                hist_data(j) = hist_data(j) + 1;
                break;
            end
        end
    end

    % convert to percentage
    hist_data = 100*hist_data / total_values;

    % Detect system type (OctoClock / GPSDO)
    % if contains(lower(file_origin), 'octo')
    %     system_label = 'OctoClock';
    % elseif contains(lower(file_origin), 'gpsdo')
    %     system_label = 'GPSDO';
    % else
    %     system_label = 'UnknownSystem';
    % end

    % Extract set name 
    % set_info = regexp(file_origin, 'Set-\d+', 'match');
    % if ~isempty(set_info)
    %     set_name = set_info{1};
    % else
    %     set_name = 'UnknownSet';
    % end

   
   
  
    figure('Position', [100, 100, 800, 600]);

    bar(bin_edges(1:N), hist_data, 'FaceColor', [0.2 0.6 0.8], ...
        'EdgeColor', 'k', 'BarWidth', 1);
    xlim(x_lim);
    ylim(y_lim);
    grid on;
    grid minor;
    set(gca, 'FontSize', 12, 'LineWidth', 1, 'Box', 'on', ...
        'GridAlpha', 0.5, 'MinorGridAlpha', 0.3); 
    set(gcf, 'Color', 'w'); 
    set(gca, 'XColor', 'k', 'YColor', 'k'); 

    
    xlabel(x_label, 'FontSize', 14, 'FontWeight', 'bold');
    ylabel(y_label, 'FontSize', 14, 'FontWeight', 'bold');
    title(plot_title, 'FontSize', 16, 'FontWeight', 'bold');
    folderPath = fileparts(filestr);
    filename = sprintf('%s\\%s.png',folderPath, plot_title);


    exportgraphics(gcf, filename, 'Resolution', 300);

    % saveas(gcf, save_path);
    close(gcf);
end
