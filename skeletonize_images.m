%% Take directory of images and convert them to skeletons
function skeletonize_images(input_dir, target_dir)

addpath('/user_data/vayzenbe/GitHub_Repos/MLV_toolbox'); %add MLV toolbox to path
setup; %setup MLV toolbox directories

if ~exist(target_dir, 'dir')
   mkdir(target_dir)
end

tic
im_files=[dir(strcat(input_dir,'/*.jpg'));dir(strcat(input_dir,'/*.png'));dir(strcat(input_dir,'/*.JPEG'))];
im_files
parfor file_num = 1:length(im_files)
    file_num
    im = imread([im_files(file_num).folder,'/',im_files(file_num).name]); %read image

    im_resize = imresize(im,[226,226]); %resize image for efficiency

    img = traceLineDrawingFromRGB(im_resize); % convert image to edge map

    im_overlay = renderLinedrawing(img,[], [500,500], 2, [0,0,0]); % convert edgemap to line drawing

    
    MAT = computeMAT(im_overlay);  %calcualte skeleton from edgemap
    
    mat_blur = imgaussfilt(double(MAT.skeleton),2); % expand skel values by blurring a bit
    
    
    %binarize
    mat_blur = imbinarize(mat_blur);
    
    %blur again so values aren't so extreme
    mat_blur = imgaussfilt(double(mat_blur),2);
    
    
    imwrite(mat_blur, [target_dir, '/',im_files(file_num).name])
    
    
    
end
toc
