# Pixel art using the `gt` package

This repository contains code for creating pixel art (displayed as tables) using the `gt` package in R. This is my (quick) submission for Posit's [2025 Table Contest](https://posit.co/blog/announcing-the-2025-table-and-plotnine-contests/). 🙂

Results:

<img src="pixel_art_posit.png" width="250">

<img src="pixel_art_avocado.png" width="250">

## How to use

* The code can be found in the `gt_pixel_art.R` file located [here](https://github.com/melissavanbussel/gt-pixel-art/blob/main/gt_pixel_art.R).
* Start by installing the required packages if you don't already have them installed. This can be done using the `install.packages()` function. You will need to have the `openxlsx2` and `gt` packages installed.
* Create an Excel file that has the pixel art you would like to create. You can see an example Excel file in the `design.xlsx` file located [here](https://github.com/melissavanbussel/gt-pixel-art/blob/main/design.xlsx). See the ["Notes"](https://github.com/melissavanbussel/gt-pixel-art/blob/main/README.md#notes) section below for some caveats!

## How it works

The `pixel_art()` function uses the [`openxlsx2` package](https://janmarvin.github.io/openxlsx2/) to read the user-provided Excel file. Using the `styles_mgr` from the "workbook" object that `openxlsx2` creates when the Excel file is loaded, the function determines the colour of each cell in the user-specified sheet of the Excel file by using regular expressions to parse the xml that is stored in `styles_mgr`. Once the colour of each cell has been determined, a `gt` table is created and the colours are applied to the cells in the `gt` table using the `gt::cell_fill()` function. Blank cells are coloured white, and then styling is applied to the table to create the appearance of pixel art! (This involves removing cell borders, table borders and column labels, followed by resizing the cells as tiny squares).

## Notes

* With the current implementation, pixel art grids should have a maximum of 26 columns.
* If colours are not appearing properly, it may be because an Excel named colour is being used (which may not be recognizable by R) instead of a custom colour using a traditional hex code or rgb code. Try using a different colour if there are any colours not rendering properly. :)
