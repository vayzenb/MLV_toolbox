<img src='images/Logo_Banner.png' width=40%> 
<hr>

The MLV toolbox provides a set of mid-level vision 

In this section, we are going to explain what MLV_toolbox is.

We are working on the python version and we have a plan to release the python version soon.<br> 
*_Please stay tuned for updates!_* 

## Table of Contents
- [Requirements](#Requirements)
- 
## Requirements

* [Matlab](https://www.mathworks.com/products/matlab.html)
* [Matlab Computer Vision Toolbox ](https://www.mathworks.com/products/computer-vision.html)
* [Matlab Image Processing Toolbox](https://www.mathworks.com/products/image.html)
* [Matlab Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) 

## Usage

**Setup Path**

The first step to use the MLV toolbox is to add the required folders to the Matlab path. You can do this on Matlab's Graphical User Interface or by running the following line of code in the command window:

```matlab
setup
```



**Extracting Line Drawings**

The main function for extracting line drawings is "lineDrawingTracing.m". 

*_Please note that the line drawing extraction process can take a while to finish, depending on the image size._*

Example usage:

```
fileName= 'example.jpg';
vecLD = lineDrawingTracing(fileName);
figure;
subplot(1,2,1);
imshow(imread('example.jpg'));
subplot(1,2,2);
drawLinedrawing(vecLD,3,'b');
```

Output:

<img src='images/example_output.png' width=70%> 

Note that the drawLineDrawing takes a LineDrawing (LD) data structure (represented as vecLD in the example above), and draws the outcome with specific line width (3 in the example above) and a chosen color ('b' -> which is for blue in Matlab). 

**Computing Medial Axis Properties**

**Computing Contour Properties**

**Manipulating Line Drawings**

**Batch Processing**

## Datasets


## FAQs


**References**
