# R/01_get_fallback_data.R
# Purpose: Download daily OHLCV data for a single ticker (SPY) as fallback.
# Author: Tony Karkantzelis
# Date: 14/7/2025
# Project: DWT RL XAI

# --- 0. Load necessary packages ---
# quantmod should already be installed in your renv environment
library(quantmod)
message("quantmod package loaded.")

# --- 1. Define Ticker and Date Range ---
ticker <- "SPY"
# Download data for the last 5 years
# Sys.Date() gets today's date
start_date <- Sys.Date() - lubridate::years(5) # Requires lubridate, which you installed
end_date <- Sys.Date()

message(paste("Attempting to download data for", ticker, "from", start_date, "to", end_date))

# --- 2. Download OHLCV Data using getSymbols ---
# auto.assign = FALSE prevents getSymbols from automatically creating
# an object named 'SPY' in your global environment. Instead, it returns
# the data directly, which we then assign to 'spy_ohlcv'.
tryCatch({
  spy_ohlcv <- getSymbols(
    Symbols = ticker,
    src = "yahoo",
    from = start_date,
    to = end_date,
    auto.assign = FALSE
  )
  message(paste0(ticker, " data downloaded successfully."))
}, error = function(e) {
  message(paste0("Error downloading ", ticker, " data: ", e$message))
  spy_ohlcv <- NULL # Assign NULL if download fails
})

# --- 3. Save Raw Data ---
# Define the directory for raw data
raw_data_dir <- "data/raw"

# Create the directory if it doesn't exist
if (!dir.exists(raw_data_dir)) {
  dir.create(raw_data_dir, recursive = TRUE) # recursive = TRUE creates parent directories if needed
  message(paste("Created directory:", raw_data_dir))
}

# Define the filename for the saved data
# Using paste0 to create a dynamic filename with the ticker
output_filename <- file.path(raw_data_dir, paste0(tolower(ticker), "_daily_ohlcv.rds"))

# Save the downloaded data as an RDS file
if (!is.null(spy_ohlcv)) {
  saveRDS(spy_ohlcv, output_filename)
  message(paste("Data saved to:", output_filename))
} else {
  message("No data to save as download failed.")
}

message("Script finished.")