function [sample MHaccepts] = tempered_mog_mh( mix, cur_pt, proposal_cov ,temp,MHaccepts)

% sample from one chain for use in Parallel tempering.  
%  Based on the function mog_mh for
% Metropolis-Hastings sampling in a mixture of Gaussians.
%  originally by:
% Tamara Broderick
% David Duvenaud
% March 2013
%
%
% modified by Dave Campbell April 2013



proposal = mvnrnd( cur_pt, proposal_cov );
if max(abs(proposal))>2
    % don't bother computing anything since the point is outside of the independent U(-2,2) priors
    sample = cur_pt;
else

proposal_ll = mix_gaussians_tempered_log_pdf(proposal, mix,temp);
cur_ll      = mix_gaussians_tempered_log_pdf(cur_pt, mix,temp);


% Possibly take a MH step.
ratio = exp(proposal_ll - cur_ll);
if ratio > rand
    sample = proposal;   % Accept. :)
    MHaccepts = MHaccepts+1;
else
    sample = cur_pt;     % Reject. :(
end
end