import click
import pandas as pd


@click.command()
@click.argument("input_file", type=click.Path(exists=True))
@click.argument("output_file", type=click.Path())
def main(input_file: str, output_file: str) -> None:
    """
    Aggregate broken links by parent page.

    Args:
        input_file: Path to the input CSV file containing link data.
        output_file: Path to save the aggregated CSV file.
    """
    df: pd.DataFrame = pd.read_csv(input_file)
    aggregated: pd.DataFrame = df.groupby("parent").size().reset_index()
    aggregated = aggregated.sort_values(by="broken_link_count", ascending=False)
    aggregated.to_csv(output_file, index=False)
    click.echo(f"Aggregated links saved to {output_file}")


if __name__ == "__main__":
    main()
