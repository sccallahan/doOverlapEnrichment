doOverlapEnrichment
================
Carson Callahan

Intro
-----

ChromHMM has some really cool features for analyzing ChIP data. In my lab, we like to use its `OverlapEnrichment` function to look at matched pair samples or isogenic systems and compare their chromatin states. This allows us to examine transitions between states between the two conditions. However, the function as is requires a bit of upstream work on the part of user: segmenting the bed file that is being mapped *to*, renaming the segmented files, and moving them into their own folder. This is tedious to do manually, so I wrote a small script to automate this process. It is run entirely from the terminal.

Description
-----------

This script will automate the ChromHMM OverlapEnrichment process by:

-   Segmenting the bed file
-   Moving the segmented files into their own folder
-   Renaming the segmented files to include the leading "0" required
-   Performing OverlapEnrichment
-   Moving results to their own folder

This script assumes some things:

-   You are running ChromHMM 1.15-0
-   ChromHMM is installed in the default home directory, usually "~/anaconda3/share/chromhmm-1.15-0/ChromHMM.jar"
-   The script is in the same directory as your BED files (or in some folder you've added to your PATH)

If you have ChromHMM installed somewhere else or are on a different version, you can edit the script to point to the proper path or ChromHMM version

The script is run in a UNIX terminal with the following syntax:

``` bash
bash doOverlapEnrichment.sh [bed_to_segment] [folder_for_segments] [segment.bed_to_map] [overlap_file_prefix] [chromhmm_output_folder]
```

Explanation of arguments:

-   bed\_to\_segment = segments.bed file (from ChromHMM output) that you want to split into separate files; the X axis of the output image
-   folder\_for\_segments = name of the folder you want to place the output of (1) into
-   segment.bed\_to\_map = the segment.bed file of the sample you are treating as the "first" condition; the Y axis of the output image
-   overlap\_file\_prefix = the name of the ChromHMM OverlapEnrichment files, e.g. \[Sample1Sample2\] would give "Sample1Sample2.png"
-   chromhmm\_ouput\_folder = name of the folder you want place the output of (4) into

The script places all of the output folders in the current working directory.
