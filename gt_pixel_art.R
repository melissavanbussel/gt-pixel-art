# Load packages
library(openxlsx2)
library(gt)

# Create function that takes an Excel file as input, and returns a gt table
pixel_art <- function(file_path, sheet_num) {
  # Load Excel file as a openxlsx2 workbook object
  wb <- wb_load(file_path)

  # Read the underlying values in the user-specified sheet of the Excel file
  df <- wb$worksheets[[sheet_num]]$sheet_data$cc

  # Create a blank data frame to store the fill colour for each cell
  fill_df <- as.data.frame(matrix(
    data = NA_character_,
    nrow = as.numeric(max(df$row_r)),
    ncol = which(LETTERS == max(df$c_r))
  ))

  # Put the fill colours in the data.frame
  for (i in seq_along(1:nrow(df))) {
    current_fill_index <- as.numeric(df$c_s[i])
    current_style <- wb$styles_mgr$styles$fills[current_fill_index + 2]
    if (grepl("bgColor rgb=", current_style)) {
      current_hex <- sub(
        ".*<bgColor rgb=\"([A-F0-9]{8})\".*",
        "#\\1",
        current_style
      )
      current_hex <- paste0("#", substr(current_hex, start = 4, stop = 9))
    } else if (grepl("patternType=", current_style)) {
      current_hex <- sub(".*patternType=\"([^\"]+)\".*", "\\1", current_style)
      current_hex <- rgb(t(col2rgb(current_hex)), maxColorValue = 255)
    } else {
      current_hex <- NA
    }
    fill_df[as.numeric(df$row_r[i]), which(LETTERS == df$c_r[i])] <- current_hex
  }

  # Replace NAs with "white" so that the gt table renders properly
  fill_df[is.na(fill_df)] <- "white"

  # Create a blank gt table object
  gt_tbl <- gt(
    as.data.frame(matrix(
      data = NA,
      nrow = nrow(fill_df),
      ncol = ncol(fill_df)
    ))
  )

  # Apply background colours cell by cell
  for (i in 1:nrow(fill_df)) {
    for (j in 1:ncol(fill_df)) {
      gt_tbl <- gt_tbl |>
        tab_style(
          style = cell_fill(color = fill_df[i, j]),
          locations = cells_body(
            columns = j,
            rows = i
          )
        )
    }
  }

  # Style the table
  gt_tbl <- gt_tbl |>
    sub_missing(
      columns = everything(),
      missing_text = "" # Replace NAs (all cells) with blank text
    ) |>
    tab_style(
      # Remove all cell borders
      style = list(
        cell_borders(
          sides = "all",
          color = "white",
          weight = px(0)
        )
      ),
      locations = cells_body(
        columns = everything(),
        rows = everything()
      )
    ) |>
    tab_options(
      column_labels.hidden = TRUE, # Remove the row that contains the column names
      table_body.border.top.color = "transparent", # Remove gray line at top of table
      table_body.border.bottom.color = "transparent" # Remove gray line at bottom of table
    ) |>
    opt_css(
      # Make every cell the same height and width to create the appearance of square pixels
      css = "
      td {
        width: 50px;
        height: 50px;
        padding: 0;
      }
      "
    )
  return(gt_tbl)
}

# Example usage:
pixel_art("design.xlsx", sheet_num = 2)
