# Capillary Analysis Tools

## External files used

* [freezeColors.m](https://www.mathworks.com/matlabcentral/fileexchange/7943-freezecolors---unfreezecolors) by John Iversen, used for the heat maps in frame_gui

* [fmeasure.m](https://www.mathworks.com/matlabcentral/fileexchange/27314-focus-measure/content/fmeasure/fmeasure.m) by Said Pertuz, used to generate the focus measures of the RBCs

## Important utility functions

### getCapillaries.m
This function is used to find the capillaries in a FOV. It uses the variance image of the collected video to find moving RBCs, and uses edge detection and other heuristics to label regions as capillaries. These regions are morphologically dilated so that they can be masked over an frame of the video and used to restrict the search for RBCs.

### findRBC.m
Finds RBCs in a specified capillary of a frame by taking the edge detection of the frame, cropping, and then performing analysis on the closed pixel regions. This function returns a rough bounding box of the RBCs, to be fed into fmeasure.m. The capillary is specified using the ID taken from the mask from getCapillaries

## getFOVfmeasures.m
This uses the above functions to get the values of the focus measures along the height (Y direction) of each capillary in the FOV. Currently, the values are found for every frame in the captured folder. The value is determined by using findRBC to get the RBC location along the capillary, and the image data is processed using fmeasure.m with the specified measure. Currently, this calculated value is assigned to the topmost coordinate of the RBC (but in reality, I think this assignment should be more complex than that. However, so far the results are promising so I will leave it for now). The frames are analysed in parallel to speed things up, with analyseFOVFocus starting the parallel pool.

## analyseFOVFOcus.m
This is a wrapper function for getFOVfmeasures.m, starting the parallel pool and Initializing the functional images needed.
