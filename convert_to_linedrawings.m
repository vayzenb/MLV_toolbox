%% Take directory of images and convert them to skeletons
function skeletonize_images(input_dir, target_dir)

    %Example how to execture from command line
    %matlab -batch "skeletonize_images('/lab_data/behrmannlab/image_sets/masked-ecoset/val/0039_dog','/lab_data/behrmannlab/image_sets/skeletonized-ecoset/val/0039_dog')"

    error_log_name = '/lab_data/behrmannlab/image_sets/skeletonized-ecoset/val/error_log.txt'
    addpath('/user_data/vayzenbe/GitHub_Repos/MLV_toolbox'); %add MLV toolbox to path
    setup; %setup MLV toolbox directories

    if ~exist(target_dir, 'dir')
    mkdir(target_dir)
    end

    tic
    im_files=[dir(strcat(input_dir,'/*.jpg'));dir(strcat(input_dir,'/*.png'));dir(strcat(input_dir,'/*.JPEG'))];
    im_files
    %testing without parfor
    parfor file_num = 1:length(im_files)
        try
            im = imread([im_files(file_num).folder,'/',im_files(file_num).name]); %read image

            im_resize = imresize(im,[150,150]); %resize image for efficiency

            img = traceLineDrawingFromRGB(im_resize); % convert image to edge map

            im_overlay = renderLinedrawing(img,[], [150,150], 2, [0,0,0]); % convert edgemap to line drawing

            %binarize
            mat_blur = imbinarize(mat_blur);
            
            %resize to 224x224
            mat_blur = imresize(mat_blur,[224,224]);
            
            
            
            imwrite(mat_blur, [target_dir, '/',im_files(file_num).name])

        catch
            disp(['Error with file ',im_files(file_num).name])
            %add file name to error log
            fileID = fopen(error_log_name,'a');
            fprintf(fileID,'%s\n',im_files(file_num).name);
            fclose(fileID);
        end
        
        
        
    end
    toc

    

end
