function frame_number = plot_samples_PT( sampled, n_frames, num_mixes, ...
    save_pngs, framerate, frame_number, mixes, chains_swap, plot_pt_tails ,temp,history)

% frame_number = plot_samples_PT( samples, n_mh_frames, num_mixes, save_pngs, visual_framerate, frame_number, mixes, [], 0,1 );
% sampled=samples, n_frames=n_pt_frames, num_mixes, save_pngs, framerate=visual_framerate, frame_number, mixes, chains_swap = [],plot_pt_tails= 1
%
%
% frame_number = plot_samples_PT( ptsamplestoplot , n_pt_frames, num_mixes, save_pngs, visual_framerate, frame_number, mixes, chains_swap, 1,temp);
% sampled=ptsamplestoplot , n_frames=n_pt_frames, num_mixes, save_pngs, framerate=visual_framerate, frame_number, mixes, plot_pt_tails= 1
if nargin<11
    history = 10;
end
if history == n_frames;
    index=n_frames;
else
    index=1;
end

num_chains = length(temp);
col_change_frames = 6;


in_pt = numel(chains_swap) > 0;
if in_pt
    ls = 'none';
else
    ls = '-';
end
%
% % Cache contours.
% for m = 1:num_mixes
%     margin = 0.01;
%     h_axes(m) = subaxis(3,3,m,'Spacing',0.01, 'MR',0.01, 'Holdaxis', true, ...
%         'MarginLeft',margin,'MarginRight',margin, ...
%         'MarginTop',margin,'MarginBottom',margin);
%
%     plot_one_contour(mixes{m}); hold on;
%     set(gca, 'LooseInset', [0,0,0,0]);
% end

col_ix = 2;
c_array(1, :) = [ 55, 126, 184 ];  % blue
c_array(2, :) = [ 255, 127, 1 ];   % orange
c_array(3, :) = [ 77, 175, 74 ];   % green
c_array(4, :) = [ 250, 60, 80 ];   % red
c_array(5, :) = [ 152, 78, 163 ];  % purple
c_array(6, :) = [ 200, 255, 51 ];  % yellow


for n = index: n_frames
    
    % Change the background color if we're in the HMC phase.
    if in_pt && (mod(n, col_change_frames) == 1)
        set(gcf, 'color', c_array(mod(col_ix, 6) + 1, :) ./255);
        col_ix = col_ix + 1;
    end
    
    cur_range = max(1, n - history):n;
    cur_tail_range = max(1, n - num_chains):n;
    
    % Plot MH samplers running.
    for m = 1:num_mixes
        margin = 0.01;
        h_axes(m) = subaxis(3,3,m,'Spacing',0.01, 'MR',0.01, 'Holdaxis', true, ...
            'MarginLeft',margin,'MarginRight',margin, ...
            'MarginTop',margin,'MarginBottom',margin);
        
        plot_one_contour(mixes{m}); hold on;
        if in_pt
            set(gcf, 'color', c_array(mod(col_ix, 6) + 1, :) ./255);
        end
        set(gca, 'LooseInset', [0,0,0,0]);
        % Plot the sample.
        h1{m} = plot(h_axes(m), sampled{m}(cur_range,1), sampled{m}(cur_range,2), ...
            '-', 'LineWidth', 7, 'Marker', 'o', 'MarkerSize', 15, ...
            'LineStyle', ls, 'MarkerFaceColor', 'r', 'Color', colorhue(9), ...
            'MarkerEdgeColor', 'r');
        hold on
        if in_pt
            
            for klp = 1:length(cur_range)
                if chains_swap{m}(cur_range(klp),3)==1 &&  chains_swap{m}(cur_range(klp),2)==length(temp)
                    plot( sampled{m}(cur_range(klp):cur_range(klp)+1,1), sampled{m}(cur_range(klp):cur_range(klp)+1,2), ...
                        '-', 'LineWidth',3, 'Color', colorhue(chains_swap{m}(cur_range(klp),1)),'Marker', '*', 'MarkerSize', 15, ...
                        'MarkerFaceColor', colorhue(2),'MarkerEdgeColor',colorhue(9));
                    if klp<length(cur_range)
                    plot( sampled{m}(cur_range(klp),1), sampled{m}(cur_range(klp),2), ...
                        'LineWidth', 7, 'Color', colorhue(9),'Marker', 'o', 'MarkerSize', 15, ...
                        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
                    end
                else
                    plot( sampled{m}(cur_range(klp):cur_range(klp)+1,1), sampled{m}(cur_range(klp):cur_range(klp)+1,2), ...
                        '-', 'LineWidth', 7, 'Color', colorhue(9),'Marker', 'o', 'MarkerSize', 15, ...
                        'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
                    
                end
                
            end
            hold off
        else
            h1{m} = plot(h_axes(m), sampled{m}(cur_range,1), sampled{m}(cur_range,2), ...
                '-', 'LineWidth', 7, 'Marker', 'o', 'MarkerSize', 15, ...
                'LineStyle', '-', 'MarkerFaceColor', 'r', 'Color', colorhue(9), ...
                'MarkerEdgeColor', 'r');
        end
        
    end
    
    pause(1/framerate);
    
    if save_pngs
        set(gcf, 'Position',[1 1 1024 768]);
        export_fig('-nocrop', sprintf('frames/hs_%04d.png', frame_number));
    end
    frame_number = frame_number + 1;
    
    % Erase old dots.
    % Erase old dots.
    
    %     for m = 1:num_mixes
    clf
    %delete(h1{m});
    %try
    %    delete(h2{m});
    %    delete(h3{m});
    %
    %end
    %     end
end

end

