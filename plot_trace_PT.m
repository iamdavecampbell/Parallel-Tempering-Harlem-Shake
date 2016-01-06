function frame_number = plot_trace_PT( PTsamples, MHsamples , n_pt_frames,n_mh_frames, num_mixes, save_pngs, framerate, frame_number, mixes, chains_swap, plot_pt_tails,temp);


history = 100;




in_pt = numel(chains_swap) > 0;
if in_pt
    ls = 'none';
else
    ls = '-';
end
randocol = rand(9,1)


for n = 1: n_mh_frames
    
    cur_range = max(1, n - history):n;
    
    % Plot MH samplers running.
    for m = 1:num_mixes
        margin = 0.01;
        
        h_axes(m) = subaxis(3,3,m,'Spacing',0.01, 'MR',0.01, 'Holdaxis', true, ...
            'MarginLeft',margin,'MarginRight',margin, ...
            'MarginTop',margin,'MarginBottom',margin);
        h1{m} = plot(h_axes(m),cur_range ,MHsamples{m}(cur_range ,1),...
            '-', 'LineWidth', 7, 'Color', colorhue(9));
        ylim([-2,2]);
        xlim([min([n-history,cur_range])   ,max(cur_range)]);
        
        set(gcf, 'color', 'white');
        set(gca, 'color', ones(1,3).*randocol(m));
        
    end
%     pause(1/framerate);
    if save_pngs
        set(gcf, 'Position',[1 1 1024 768]);
        export_fig('-nocrop', sprintf('frames/hs_%04d.png', frame_number));
    end
    clf
    frame_number = frame_number + 1;
end


















col_ix = 2;
c_array(1, :) = [ 55, 126, 184 ];  % blue
c_array(2, :) = [ 255, 127, 1 ];   % orange
c_array(3, :) = [ 77, 175, 74 ];   % green
c_array(4, :) = [ 250, 60, 80 ];   % red
c_array(5, :) = [ 152, 78, 163 ];  % purple
c_array(6, :) = [ 200, 255, 51 ];  % yellow

col_change_frames = 6;

for n = 1: n_pt_frames
        if (mod(n, col_change_frames) == 1)
        set(gcf, 'color', c_array(mod(col_ix, 6) + 1, :) ./255);
        col_ix = col_ix + 1;
        end
    cur_range = max(1, n - history):n;
    cur_range_MH = max(n, n_mh_frames + n - history):n_mh_frames;
    % Plot MH samplers running.
    for m = 1:num_mixes
        margin = 0.01;
        
        h_axes(m) = subaxis(3,3,m,'Spacing',0.01, 'MR',0.01, 'Holdaxis', true, ...
            'MarginLeft',margin,'MarginRight',margin, ...
            'MarginTop',margin,'MarginBottom',margin);
        h1{m} = plot(h_axes(m),cur_range_MH ,MHsamples{m}(cur_range_MH  ,1),...
            '-', 'LineWidth', 7, 'Color', colorhue(9));
        ylim([-2,2]);
        xlim([min([n-history+n_mh_frames,n_mh_frames+cur_range])   ,max(n_mh_frames+cur_range)]);
        hold on
        for lp = 1:(size(PTsamples,2)-1)
            h1{m} = plot(h_axes(m),cur_range+n_mh_frames ,PTsamples{m,lp}(cur_range ,1),...
                '-', 'LineWidth', 4, 'Color', colorhue(9+lp));
        end
        
        h1{m} = plot(h_axes(m),cur_range+n_mh_frames ,PTsamples{m,end}(cur_range ,1),...
            '-', 'LineWidth', 4, 'Color', colorhue(9));
        
        hold off
        
        
%         set(gcf, 'color', 'white');
        %     if(rem(m,2)==0)
        %         set(gca, 'color', 'black');
        %     else
        %         set(gca, 'color', 'white');
        %     end
        set(gca, 'color', ones(1,3).*randocol(m));
    end
    set(gcf, 'color', c_array(mod(col_ix, 6) + 1, :) ./255);
    %pause(1/framerate);
    if save_pngs
        set(gcf, 'Position',[1 1 1024 768]);
        export_fig('-nocrop', sprintf('frames/hs_%04d.png', frame_number));
    end
    
    frame_number = frame_number + 1;
    
end