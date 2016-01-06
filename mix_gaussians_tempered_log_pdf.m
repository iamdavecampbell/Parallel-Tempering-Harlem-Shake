function ll = mix_gaussians_tempered_log_pdf( x, mix ,temp)
% Evaluate a mixture of Guassians at specified locations.
%
% x is N x D
% mix.weights is k x 1
% mix.means is k x D
%
% Tamara Broderick
% David Duvenaud
%
% March 2013




% vals is going to be summed over the elements of mixture.
[K, D] = size(mix.means);
[N, D] = size(x);

log_pdfs = NaN(N, K);
log_mix_weights = log(mix.weights);
   
for k = 1:K
    log_pdfs(:, k) = log_mix_weights(k) + logmvnpdf( x, mix.means(k, :), mix.covs(:, :, k));
end


% Throw in the prior as well 
% Uniform on the -2,2 square
if max(abs(x))<=2
    ll = logsumexp( log_pdfs )*temp + (1-temp)*log(1/16) ;
    
else
    ll  = -10*abs(logsumexp( log_pdfs )*temp + (1-temp)*log(1/16));
end
%logmvnpdf( x, [0,0], diag([1.5,1.5]));
    

 