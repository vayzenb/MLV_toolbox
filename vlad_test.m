%% 
complete_stim = "C:\Users\vayze\Desktop\GitHub_Repos\kornet\stim\test\Outline_Black_Filled\OBJ (1).png";
pert_stim = "C:\Users\vayze\Desktop\GitHub_Repos\kornet\stim\test\Pert_Black_Filled\OBJ (1)_ripple.png";
delete_stim = "C:\Users\vayze\Desktop\GitHub_Repos\kornet\stim\test\IC\OBJ (01)_IC.png";

tic
nat_stim = "C:\Users\vayze\Desktop\GitHub_Repos\kornet\stim\_things\tree\tree_05s.jpg";

im = imread(nat_stim);
im_resize = imresize(im,[226,226]);

%imwrite(im_resize,"test.jpg")


img = traceLineDrawingFromRGB(im_resize);
% figure;
% subplot(1,2,1);
% 
% 
% 
% imshow(imread(nat_stim));
% subplot(1,2,2);
% drawLinedrawing(img,1,'b');

%im_overlay = renderLinedrawing(img,imread(nat_stim), [500,500], 2, [1,0,0]);
im_overlay = renderLinedrawing(img,[], [500,500], 2, [0,0,0]);
imshow(im_overlay)

%% 
MAT = computeMAT(im_overlay); 

imshow(MAT.skeleton)
toc