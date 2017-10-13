
function mixes = define_mixes_letters()

mixes = cell(0);

% H.
if 1
skinny = 0.01;
really_skinny = 0.005;
fat = 0.6;
vert_cov = [really_skinny 0; 0 fat];
horz_cov = [fat 0; 0 skinny];
mix.means = [ -1.5 0; 0 0; 1.5 0];
mix.covs(:,:,1) = vert_cov;
mix.covs(:,:,2) = horz_cov;
mix.covs(:,:,3) = vert_cov;
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end

% A.
if 1
skinny = 0.01;
fat = 0.45;
horz_cov = [fat 0; 0 skinny];
mix.means = [ 0 -1; -0.9 0; 0.9 0];
mix.covs(:,:,1) = horz_cov;
lengths = [0.01 1.2];
mix.covs(:,:,2) = rotate_cov( lengths, pi/8 );
mix.covs(:,:,3) = rotate_cov( lengths, -pi/8 );
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end


% R.
if 1
skinny = 0.01;
fat = 0.75;
vert_cov = [skinny 0; 0 fat];
mix.means = [ -1.5 0; 0.25 1.25; 0.25 0.5; 0.25 -0.9 ];
mix.covs(:,:,1) = vert_cov;
lengths = [1.2 0.01];
mix.covs(:,:,2) = rotate_cov( lengths, pi/12 );
mix.covs(:,:,3) = rotate_cov( lengths, -pi/12 );
mix.covs(:,:,4) = rotate_cov( lengths, pi/8 );
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end

% L.
if 1
skinny = 0.01;
fat = 0.6;
vert_cov = [skinny 0; 0 fat];
horz_cov = [fat 0; 0 skinny];
mix.means = [ -1.5 0; 0 -1.5];
mix.covs(:,:,1) = vert_cov;
mix.covs(:,:,2) = horz_cov;
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end

% Spherical Gaussian.
mix.weights = 1;
mix.means = [ 0 0];
mix.covs = [ 1 0; 0 1];
mixes{end + 1} = mix;


% M.
if 1
skinny = 0.01;
really_skinny = 0.005;
fat = 0.6;
vert_cov = [really_skinny 0; 0 fat];
mix.means = [ -1.5 0; 1.5 0; -0.7 0.2; 0.7 0.2 ];
mix.covs(:,:,1) = vert_cov;
mix.covs(:,:,2) = vert_cov;
lengths = [0.01 1];
mix.covs(:,:,3) = rotate_cov( lengths, -pi/6 );
mix.covs(:,:,4) = rotate_cov( lengths, pi/6 );
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end

%S
if 1
num_circle = 50;
angles = linspace( -pi/2, pi, num_circle) + pi/2;
mix.means = [cos( angles').*1.75 - 1, sin(angles').*0.9] + 0.9;
mix.means = [mix.means; -mix.means];
mix.covs = repmat( [ 1 0; 0 1], [1, 1, num_circle*2]) .* 0.01;
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end

% H.
if 1
skinny = 0.1;
really_skinny = 0.005;
fat1 = 1.2;
fat2 = 0.6;
vert_cov = [really_skinny 0; 0 fat1];
horz_cov = [fat2 0; 0 skinny];
mix.means = [ -1.5 0; 0 0; 1.5 0];
mix.covs(:,:,1) = vert_cov;
mix.covs(:,:,2) = horz_cov;
mix.covs(:,:,3) = vert_cov;
%mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.weights = [0.1 0.8 0.1];
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end


% K.
if 1
skinny = 0.01;
fat = 0.75;
vert_cov = [skinny 0; 0 fat];
mix.means = [ -1.5 0; -0.1 -0.8; -0.1 0.8 ];
mix.covs(:,:,1) = vert_cov;
lengths = [1.2 0.01];
mix.covs(:,:,2) = rotate_cov( lengths, pi/6 );
mix.covs(:,:,3) = rotate_cov( lengths, -pi/6 );
mix.weights = ones(size(mix.means,1),1) ./ size(mix.means,1);
mix.covs=mix.covs(:,:,1:length(mix.weights));
mixes{end + 1} = mix;
end

end