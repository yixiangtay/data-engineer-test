import argparse
import csv
from datetime import datetime
import glob
import os
import re


def preprocess_row(row):
    """Preprocess a row in the input csv file by removing prefixes in `name`."""
    row["name"] = re.sub("^(Dr.)|(Mdm.)|(Mr.)|(Mrs.)|(Ms.)|(Miss) ", "", row["name"])


def process_row(row):
    """Process a row in the input csv file which includes:

    1. splitting the `name` field into `first_name` and `last_name`
    2. removing prepended zeros in `price`
    3. adding a new field `above_100` to indicate if `price` is strictly greater than 100
    """
    name = row["name"].split()
    row["first_name"], row["last_name"] = name[0], name[1]
    row.pop("name")
    row["price"] = row["price"].lstrip("0")
    row["above_100"] = "true" if float(row["price"]) > 100 else "false"


def main(args):
    # ensure output directory is present
    if not os.path.exists(args.output_dir):
        os.mkdir(args.output_dir)

    # output writer writes processed data
    # error writer writes input malformed data
    processed_file = os.path.join(args.output_dir, datetime.today().strftime("processed-%d-%m-%Y.csv"))
    error_file = os.path.join(args.output_dir, datetime.today().strftime("error-%d-%m-%Y.csv"))
    with open(processed_file, "w", newline="") as out, open(error_file, "w", newline="") as err:
        out_writer = csv.DictWriter(out, delimiter=",",
                                    fieldnames=["first_name", "last_name", "price", "above_100"],
                                    quoting=csv.QUOTE_NONE)
        out_writer.writeheader()
        err_writer = csv.DictWriter(err, delimiter=",",
                                    fieldnames=["name", "price"],
                                    quoting=csv.QUOTE_NONE)
        err_writer.writeheader()

        # get relevant files in input directory
        files = glob.glob(os.path.join(args.input_dir, "dataset*.csv"))
        for file in files:
            with open(file, "r") as f_in:
                reader = csv.DictReader(f_in, delimiter=",")
                for row in reader:
                    # rows which do not have the `name` field are rejected
                    if not row.get("name"):
                        err_writer.writerow(row)
                        continue

                    preprocess_row(row)
                    process_row(row)
                    out_writer.writerow(row)


if __name__ == "__main__":
    # for parsing the command line arguments
    parser = argparse.ArgumentParser("csv processing")
    parser.add_argument("--input-dir", dest="input_dir", required=True, help="path to input directory")
    parser.add_argument("--output-dir", dest="output_dir", required=True, help="path to output directory")
    args = parser.parse_args()

    main(args)
