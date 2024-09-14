# Retinal-Blood-Vessel-Detection

This project aims to extract blood vessels from retinal images using various image processing techniques. The provided MATLAB code processes retinal images to enhance and isolate vein structures and then evaluates the performance of the extraction using metrics such as sensitivity, specificity, and accuracy.

## Overview

The code performs the following steps:

1. **Green Channel Extraction**: Extracts the green channel from the RGB image, where blood vessels are more prominent.
2. **Adaptive Thresholding**: Applies adaptive thresholding to binarize the image based on local statistics.
3. **Sharpening**: Uses a sharpening filter to enhance the contrast of vein structures.
4. **Denoising**: Applies a Wiener filter to reduce noise in the image.
5. **Otsu Thresholding**: Uses Otsu’s method for global binarization of the image.
6. **Morphological Opening**: Performs morphological opening to remove small artifacts.
7. **Circle Removing**: Removes circular artifacts based on a mask from the green channel.
8. **Evaluation**: Computes sensitivity, specificity, and accuracy to evaluate the performance of the extraction.

## Files

- `main.m`: Main script for processing images and evaluating results.
- `process_image.m`: Function for processing individual images.
- `evaluate_results.m`: Function for evaluating the performance of the extraction.

## Prerequisites

- MATLAB
- Image Processing Toolbox

## Usage

1. **Prepare Your Data**:
   - Place your original images in a directory (e.g., `original_images`).
   - Place the corresponding ground truth images in another directory (e.g., `groundtruth_images`).
   - Ensure both directories contain images in TIFF format (`.tif`).

2. **Run the Script**:
   - Update the `original_images_dir` and `groundtruth_images_dir` variables in `main.m` to point to your image directories.
   - Run `main.m` in MATLAB.

3. **View Results**:
   - The processed images and evaluation metrics will be displayed and saved in `results.txt`.



## Evaluation Metrics

The following metrics are used to evaluate the performance of the blood vessel extraction:

- **Sensitivity (True Positive Rate)**: Measures the proportion of actual positive cases correctly identified by the model.
  \[
  \text{Sensitivity} = \frac{TP}{TP + FN}
  \]
  
- **Specificity (True Negative Rate)**: Measures the proportion of actual negative cases correctly identified by the model.
  \[
  \text{Specificity} = \frac{TN}{TN + FP}
  \]

- **Accuracy**: Measures the overall correctness of the model.
  \[
  \text{Accuracy} = \frac{TP + TN}{TP + TN + FP + FN}
  \]

Where:
- **TP** = True Positives
- **TN** = True Negatives
- **FP** = False Positives
- **FN** = False Negatives

## License

This project does not have a formal license and is provided for educational purposes only. Feel free to use and modify the code as needed for learning and personal projects.

