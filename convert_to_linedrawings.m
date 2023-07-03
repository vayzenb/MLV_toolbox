%% Take directory of images and convert them to skeletons
function convert_to_linedrawings(input_dir, target_dir)

    %Example how to execture from command line
    %matlab -batch "skeletonize_images('/lab_data/behrmannlab/image_sets/masked-ecoset/val/0039_dog','/lab_data/behrmannlab/image_sets/skeletonized-ecoset/val/0039_dog')"

    %input_dir = 'C:\Users\vayze\Desktop\GitHub_Repos\kornet\stim\_things\bear';
    %target_dir = 'C:\Users\vayze\Desktop\GitHub_Repos\MLV_toolbox\images\bear';
    
    error_log_name = [target_dir,'error_log.txt'];
    addpath('/user_data/vayzenbe/GitHub_Repos/MLV_toolbox'); %add MLV toolbox to path
    setup; %setup MLV toolbox directories

    if ~exist(target_dir, 'dir')
        mkdir(target_dir)
    end

    tic
    im_files=[dir(strcat(input_dir,'/*.jpg'));dir(strcat(input_dir,'/*.png'));dir(strcat(input_dir,'/*.JPEG'))];
    
    %testing without parfor
    parfor file_num = 1:length(im_files)
        try
        
            im = imread([im_files(file_num).folder,'/',im_files(file_num).name]); %read image

            im_resize = imresize(im,[224,224]); %resize image for efficiency

            img = traceLineDrawingFromRGB(im_resize); % convert image to edge map

            im_overlay = renderLinedrawing(img,[], [224,224], 2, [0,0,0]); % convert edgemap to line drawing
            
            
            %blur
            line_im = imgaussfilt(double(im_overlay),2); % expand skel values by blurring a bit

            %binarize
            line_im = imbinarize(line_im);
            
            %invert colors
            line_im = imcomplement(line_im);
            
            %convert to double
            line_im = double(line_im);
            
            line_im = uint8(255 * mat2gray(line_im));
            
            % set black background to gray
            line_im(line_im ==0) = 109;
            
            %resize to 224x224
            line_im = imresize(line_im,[224,224]);
            
            %
            
            
            
            imwrite(line_im, [target_dir, '/',im_files(file_num).name])
            
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
