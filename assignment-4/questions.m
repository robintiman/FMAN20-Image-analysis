%% Q1
load('femfel.mat');
close
subplot(1,3,1), imshowpair(femfel1, femfel2)
title('Image difference using imshowpair')
% We see that image 1 is slightly shifted 

% Align the images
im_moved = rgb2gray(femfel1);
im_fixed = rgb2gray(femfel2);
[optimizer, metric] = imregconfig('monomodal');
im_aligned = imregister(im_moved, im_fixed, 'affine', optimizer, metric);

diff_im = im_fixed-im_aligned;
subplot(1,3,2), imshow(diff_im)
title('Aligned image difference')

% Estimate background
background = imopen(diff_im , strel('disk', 15));
final_im = diff_im - background; 
final_im = imadjust(final_im);
final_im = imbinarize(final_im);
final_im = bwareaopen(final_im, 50);
subplot(1,3,3), imshow(final_im)
title('Final result')

%% Q2
load('heart_data.mat');
close all

% Get the mean and standard deviation for the two classes
back_std = std(background_values);
chamb_std = std(chamber_values);
back_mean = mean(background_values);
chamb_mean = mean(chamber_values);

% Determine priors
total_pixels = numel(im);
a_back = -log(numel(background_values)/total_pixels);
a_chamb = -log(numel(chamber_values)/total_pixels);

% Calculate the probabilities for each pixel (negative log-likelihood)
pd_back = -log(normpdf(im, back_mean, back_std)) - a_back;
pd_chamb = -log(normpdf(im, chamb_mean, chamb_std)) - a_chamb;

lambda = 4.15;
[M, N] = size(im);
n = numel(im);
neigh = edges4connected(M,N);
i = neigh(:,1);
j = neigh(:,2);
A = sparse(i,j,lambda,n,n);
T = [pd_back(:) pd_chamb(:)];
T = sparse(T);

[E, theta] = maxflow(A,T);
theta = reshape(theta,M,N);
theta = double(theta);
imshow(imresize(theta, 3))

%% Q3
F = [-4 2 -6;3 0 7;-6 9 1];
a = [1 2 1;3 2 1;0 3 1];
b = [1 1 1;5 1 1;-1 -3 1];

corr_points = zeros(3,3);
for i=1:3
    for j=1:3
        corr_points(i,j) = a(i,:)*F*b(j,:)'; 
    end 
end
corr_points

% Answer a1->b2 and a2->b1





