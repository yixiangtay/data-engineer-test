# Section 1: Data Pipelines

## Objective

The objective is to extract raw data from multiple csv files, apply transformation logic to records in each file and
load them to the same output file.

## Solution

### ETL

The code to perform the ETL task can be found [here](./task.py).

### Scheduling

Given that the raw csv files can be expected to arrive daily at 1 am, we can make use of a cron job to trigger the ETL
pipeline on a daily basis. To create the cron job:

1. Edit the crontab file
```bash
crontab -e
```
2. Append the following entry to the file. Replace the paths (enclosed in `<` and `>`) as appropriate.
```
0 1 * * * python3 </path/to/task.py> --input-dir </path/to/input/dir> --output-dir </path/to/output/dir>
```
This will create a cron job that triggers the ETL task daily at 1 am.

The [input](data/input) directory contains the raw csv files that are to be processed.
The output directory contains the [processed](data/output/processed-12-06-2021.csv) files which are suffixed with their
date of creation.
This is to avoid contamination of the output files that ran on separate dates.
Other than the processed file which contains the transformed data records, an [error](data/output/error-12-06-2021.csv)
file which contains raw records that has been rejected from the final output is included in the output directory.
The error file serves as a log of the source values that got rejected to aid correction of the data, if required.