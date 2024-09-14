function main()
    % Define the directory where the images are stored
    original_images_dir = 'C:\Users\AFRAA\Desktop\2\original_images';
    groundtruth_images_dir = 'C:\Users\AFRAA\Desktop\2\groundtruth_images';

    % Get a list of all the files in the image directory
    img_files = dir(fullfile(original_images_dir, '*.tif'));
    gt_files = dir(fullfile(groundtruth_images_dir, '*.tif'));

    % Open a file for writing the results
    fileID = fopen('results.txt', 'w');

    % Loop over each file in the directory
    for k = 1:length(img_files)
        % Load the image and ground truth
        img_path = fullfile(original_images_dir, img_files(k).name);
        gt_path = fullfile(groundtruth_images_dir, gt_files(k).name);
        img = imread(img_path);
        gt_img = logical(imread(gt_path));

        % Process the image and display the steps
        processed_img = process_image(img);

        % Evaluate the results
        [sensitivity, specificity, accuracy] = evaluate_results(processed_img, gt_img);

        % Write the results to the file
        fprintf(fileID, 'Image %s: sensitivity = %f, specificity = %f, accuracy = %f\n', img_files(k).name, sensitivity, specificity, accuracy);
    end

    % Close the file
    fclose(fileID);
end

function processed_img = process_image(img)
    figure;
    
    %% main image
    subplot(2, 4, 1); imshow(img); title('Main Image');
    
    %% get green channel
    temp = img(:, :, 2);
    img = img(:, :, 2);
    temp(temp < 30) = 0;
    temp(temp ~= 0) = 1;
    temp = logical(temp);
    around_mask = imresize(temp, size(temp));
    subplot(2, 4, 2); imshow(img, []); title('Green Channel');

    %% gaussian adapt
    T = adaptthresh(img, 0.65, 'Statistic','gaussian', 'NeighborhoodSize', 9);
    img = 1 - imbinarize(img, T);
    subplot(2, 4, 3); imshow(img); title('Adaptive Thresholding');

    %% sharpenning
    f = [-1 -1 -1;-1 9 -1;-1 -1 -1];
    img = imfilter(img, f);
    subplot(2, 4, 4); imshow(img); title('Sharpening');

    %% Denoising Using Wiener Filter
    [img,noise_out] = wiener2(img,[5 5]);
    subplot(2, 4, 5); imshow(img); title('Denoising');

    %% otsu thresholding
    [counts,x] = imhist(img, 8);
    T = otsuthresh(counts);
    img = imbinarize(img, T);
    subplot(2, 4, 6); imshow(img); title('Otsu Thresholding');

    %% Morphological Opening
    se = strel('disk', 1);
    img = imopen(img, se);
    subplot(2, 4, 7); imshow(img); title('Morphological Opening');

    %% Circle Removing
    img = around_mask & img;
    subplot(2, 4, 8); imshow(img); title('Result');

    processed_img = img;
end

function [sensitivity, specificity, accuracy] = evaluate_results(img, gt_img)
    tp = 0;
    fp = 0;
    tn = 0;
    fn = 0;
    for i = 1 : size(img, 1)
        for j = 1 : size(img, 2)
            if img(i, j) == gt_img(i, j) && img(i, j) == 1
                tp = tp + 1;
            elseif img(i, j) == gt_img(i, j) && img(i, j) == 0
                tn = tn + 1;
            elseif img(i, j) ~= gt_img(i, j) && img(i, j) == 0
                fp = fp + 1;
            elseif img(i, j) ~= gt_img(i, j) && img(i, j) == 1
                fn = fn + 1;
            end
        end
    end
    sensitivity = tp / (tp + fn);
    specificity = tn / (tn + fp);
    accuracy = (tp + tn) / (tp + tn + fp + fn);
end
