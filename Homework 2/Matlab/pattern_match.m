% Task 2 of the Machine Vision homework assignment, measuring pixels -> mm
% Omar El-Nahhas & Javier Galindos
clear;
close all;
%% Get images from webcam

%cam = webcam('HD Webcam C615');
%cam.Resolution = '640x480';
camHeight = 480;
camWidth = 640;
%% Import template images

template_orange = imread('Images/orange_temp.png');
template_yellow = imread('Images/yellow_temp.png');
template_blue = imread('Images/blue_template.png');
template_empty = imread('Images/empty-temp.png');

templates ={template_orange; template_yellow; template_blue; template_empty};
colours = [[0,165,255];
           [15,253,250];
           [255,0,0];
           [0,0,0]];

img = imread('Images/checker_board6.png');


%% Dirk-jan his function template_matching
template = template_empty;
[I_SSD,I_NCC, Idata] = template_matching(template, img);

corr_prob = 0.8;

[B,I] = maxk(I_NCC(:), length(find(I_NCC>corr_prob)));
[sk1, sk2] = ind2sub(size(I_SSD), I);



cluster_data = [sk2,sk1];
pill_radius = 5;
min_pts = 3;
clusters = dbscan(cluster_data, pill_radius, min_pts);
save_means = [];
mean_cluster = [];
for i=1:length(unique(clusters))
    mean_cluster(i,:) = mean(cluster_data(clusters == i,:));
end

save_means = [save_means; mean_cluster, 1*ones(size(mean_cluster,1),1)];
origin = mean_cluster(1,:);

figure, 
imshow(img); hold on;
plot(mean_cluster(:,1),mean_cluster(:,2),'k*');
text(mean_cluster(:,1) - 20,mean_cluster(:,2) - 20,'empty')
title('Result')

%% Dirk-jan his function template_matching
template = template_blue;
[I_SSD,I_NCC, Idata] = template_matching(template, img);

corr_prob = 0.8;

[B,I] = maxk(I_NCC(:), length(find(I_NCC>corr_prob)));
[sk1, sk2] = ind2sub(size(I_SSD), I);



cluster_data = [sk2,sk1];
pill_radius = 5;
min_pts = 3;
clusters = dbscan(cluster_data, pill_radius, min_pts);

mean_cluster = [];
for i=1:length(unique(clusters))
    mean_cluster(i,:) = mean(cluster_data(clusters == i,:));
end
save_means = [save_means; mean_cluster, 2*ones(size(mean_cluster,1),1)];
hold on; plot(mean_cluster(:,1),mean_cluster(:,2),'r*');
text(mean_cluster(:,1) - 15,mean_cluster(:,2) - 20,'blue')
title('Result')
%% Dirk-jan his function template_matching
template = template_orange;
[I_SSD,I_NCC, Idata] = template_matching(template, img);

corr_prob = 0.8;

[B,I] = maxk(I_NCC(:), length(find(I_NCC>corr_prob)));
[sk1, sk2] = ind2sub(size(I_SSD), I);



cluster_data = [sk2,sk1];
pill_radius = 5;
min_pts = 3;
clusters = dbscan(cluster_data, pill_radius, min_pts);

mean_cluster = [];
for i=1:length(unique(clusters))
    mean_cluster(i,:) = mean(cluster_data(clusters == i,:));
end
save_means = [save_means; mean_cluster, 3*ones(size(mean_cluster,1),1)];
hold on; plot(mean_cluster(:,1),mean_cluster(:,2),'g*'); 
text(mean_cluster(:,1) - 25,mean_cluster(:,2) - 20,'orange')
title('Result')

%% Dirk-jan his function template_matching
template = template_yellow;
[I_SSD,I_NCC, Idata] = template_matching(template, img);

corr_prob = 0.8;

[B,I] = maxk(I_NCC(:), length(find(I_NCC>corr_prob)));
[sk1, sk2] = ind2sub(size(I_SSD), I);



cluster_data = [sk2,sk1];
pill_radius = 5;
min_pts = 3;
clusters = dbscan(cluster_data, pill_radius, min_pts);

mean_cluster = [];
for i=1:length(unique(clusters))
    mean_cluster(i,:) = mean(cluster_data(clusters == i,:));
end
save_means = [save_means; mean_cluster, 4*ones(size(mean_cluster,1),1)];
hold on; plot(mean_cluster(:,1),mean_cluster(:,2),'b*');
text(mean_cluster(:,1) - 20,mean_cluster(:,2) - 20,'yellow')
title('Result')

%% Compute manhattan distance
manhattan_dist_pix = pdist2(origin,save_means(:,1:2),'cityblock'); %manhattan distance


pix_to_mm_ratio = 106/463;

manhattan_dist_mm = manhattan_dist_pix*pix_to_mm_ratio;

manhattan_dist_mm = [manhattan_dist_mm' save_means(:,3)]

% 1 is empty
% 2 is blue
% 3 is orange
% 4 is yellow

text(save_means(:,1) - 7,save_means(:,2) + 20,string(round(manhattan_dist_mm(:,1))))

