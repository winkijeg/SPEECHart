fast_rotate.cpp

This function is a faster implemention of Matlab's imrotate. It replace the imrotate(image,ang,'crop') method, and works with uint8 images.
Usage :
fast_rotate(image,angle)
The image is an uint8 image, 2 or 3 dimentions.
The angle is in degrees.

Installation :
The cpp file needs to compile using mex.
Example : mex fast_rotate.cpp

