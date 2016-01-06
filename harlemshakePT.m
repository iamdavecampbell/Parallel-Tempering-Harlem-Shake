
% Harlem shake - Metropolis Hastings vs Parallel Tempering version.
%
% original code for Metropolis Hastings vs HMC from:
% Tamara Broderick
% David Duvenaud
% http://github.com/duvenaud/harlemcmc-shake
%
%
% Modified to Parallel Tempering by
% Dave Campbell  http://stat.sfu.ca/~dac5
% http://github.com/iamdavecampbell/Parallel-Tempering-Harlem-Shake
%
%
% May 2014
%
%
%
% Note that these Parallel Tempering functions are add ons to the original
% code for Metropolis Hasting vs HMC from the above repository
% http://github.com/duvenaud/harlemcmc-shake
%

save_pngs_flag = 'frames'

save_pngs = save_pngs_flag;

addpath('/exportfig');
addpath('/util');


mh_time = 16;   % Seconds of buildup part.
pt_time = 23;  % Seconds of crazy part.
framerate = 14; % Hz.
n_mh_frames = mh_time * framerate+1;
n_pt_frames = pt_time * framerate+1;

% Check for previously cached samples.
cache_filename = 'sample_cache_full';
temp = [.05,.1,.2,.3,.4,.6,.8,1];
% load(strcat(cache_filename,'_with_',num2str(length(temp)),'_chains.mat'))


mh_proposal_cov = [ 0.005 0; 0 0.005 ];
mh_proposal_middle_cov = [ 0.5 0; 0 0.5 ];

% Set up some mixtures of Gaussians.
mixes = define_mixes_letters();
num_mixes = numel(mixes);

% Fix the seed of the random generators.
seed=3;
randn('state',seed);
rand('state',seed);

% Start with samples from these dists.
x = cell(num_mixes, 1);
for n = 1:num_mixes
    x{n} = mix_gaussians_draw( mixes{n}, 1 );
end

% Run M-H & PT


%     temp = [.1,.2,.4,1];
fprintf('\nComputing MH samples');
MHaccepts = ones(num_mixes,length(temp));
PTsamples      = cell(num_mixes,length(temp));
chains_swap    = cell(num_mixes,1);
chains_swap(:) = {zeros(n_mh_frames,3)};
MHsamples        = cell(num_mixes,1);
for m = 1:num_mixes
    MHsamples{m} =[x{m}; NaN(n_mh_frames-1, 2)];
    
    
    if m == 5   % The central Gaussian gets its own proposal distribution.
        cur_cov = mh_proposal_middle_cov;
    else
        cur_cov = mh_proposal_cov;
    end
    proposal_cov   = cell(1,length(temp));
    for tlp = 1:length(temp)
        proposal_cov{tlp}   =  cur_cov*temp(tlp)+2*mh_proposal_middle_cov*(1-temp(tlp));
    end
    
    for n = 2:n_mh_frames
        
        MHsamples{m}(n,:) = mog_mh( mixes{m}, MHsamples{m}(n - 1,:), cur_cov );
        
    end
    % Start the next segment from the end of the MH
    PTsamples(m,:) = {[MHsamples{m}(n_mh_frames,:);NaN(n_pt_frames, 2)]};
    for n = 2:n_pt_frames
        iter = n-1;
        [PTsamples(m,:) chains_swap{m}(iter,:), MHaccepts(m,:)]= mog_mh_PT(mixes{m}, PTsamples(m,:), cur_cov,proposal_cov,temp,MHaccepts(m,:),iter);
    end
    
    fprintf('.');
end



save(strcat(cache_filename,'_with_',num2str(length(temp)),'_chains.mat'));
% end


%%

% if nargin < 1
%     save_pngs = false;
% else
%     save_pngs = save_pngs_flag;
% end
% n_mh_frames
% n_pt_frames

visual_framerate = framerate;
% plot_hmc_tails = true;

set(0,'DefaultFigureWindowStyle','normal')
figure(1); clf;
set(gcf, 'Position',[1 1 1024 768]);

% Plot MH part.
frame_number = 1;
frame_number = plot_samples_PT( MHsamples, n_mh_frames-1, num_mixes, save_pngs, visual_framerate, frame_number, mixes, [], 0,1 )
% frame_number =225
fprintf('\n\nDO THE HARLEM SHAKE\n\n')

ptsamplestoplot = PTsamples(:,end);

% Plot PT part.
frame_number = plot_samples_PT( ptsamplestoplot , n_pt_frames-1, num_mixes, save_pngs, visual_framerate, frame_number, mixes, chains_swap, 1,temp)

%
%  frame_number =545


frame_number = plot_trace_PT(  PTsamples, MHsamples , n_pt_frames,n_mh_frames, num_mixes, save_pngs, visual_framerate, frame_number, mixes, chains_swap, 1,temp);


frame_number = 2000;
frame_number = plot_samples_PT( MHsamples, n_mh_frames-1, num_mixes, save_pngs, visual_framerate, frame_number, mixes, [], 0,1 , n_mh_frames-1)
frame_number = 2001;
frame_number = plot_samples_PT( ptsamplestoplot , n_pt_frames-1, num_mixes, save_pngs, visual_framerate, frame_number, mixes, chains_swap, 1,temp, n_pt_frames-1)


% Compile the video.
if save_pngs
    system('ffmpeg -r 14 -i frames/hs_%04d.png  -vcodec libx264 hs_PT_movie_v8.m4v');
end


