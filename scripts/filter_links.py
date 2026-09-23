from typing import Tuple

import click
import pandas as pd


@click.command()
@click.argument("input_file", type=click.Path(exists=True))
@click.argument("output_file", type=click.Path())
@click.option(
    "--exclude",
    "-e",
    type=int,
    multiple=True,
    default=(403, 405),
    help="Status codes to exclude. Can be used multiple times.",
)
def main(input_file: str, output_file: str, exclude: Tuple[int, ...]) -> None:
    """
    Filter links from INPUT_FILE and save the result to OUTPUT_FILE.

    Excludes links with status codes specified in the --exclude option.
    """
    df = pd.read_csv(input_file)
    filtered_df = df[~df["status"].isin(exclude)]
    filtered_df.to_csv(output_file, index=False)
    click.echo(f"Filtered links saved to {output_file}")


if __name__ == "__main__":
    main()
