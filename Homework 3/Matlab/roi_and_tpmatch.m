% Task 2 of the Machine Vision homework assignment, measuring pixels -> mm
% Omar El-Nahhas & Javier Galindos
clear;
close all;
%% Get images from webcam

cam = webcam('HD Webcam C615');
cam.Resolution = '640x480';
camHeight = 480;
camWidth = 640;
preview(cam)
%% Import template images
frame =snapshot(cam);
imtool(frame)
%% show img

template=RGB;
figure
imshow(template);

%% Dirk-jan his function template_matching
while(1)
    img =snapshot(cam);
    [I_SSD,I_NCC, Idata] = template_matching(template, img);

    [B,I] = find(I_SSD==max(I_SSD(:)));
%[sk1, sk2] = ind2sub(size(I_NCC), I);
    imshow(img); hold on; plot(I,B,'g.', 'MarkerSize',80); title('Result')
end
%%
figure, 
subplot(2,2,1), imshow(img); hold on; plot(I,B,'.'); title('Result')
subplot(2,2,2), imshow(template); title('The key template');
subplot(2,2,3), imshow(I_SSD); title('SSD Matching');
subplot(2,2,4), imshow(I_NCC); title('Normalized-CC');


