import click
import pandas as pd


@click.command()
@click.argument("input_file", type=click.Path(exists=True))
@click.argument("output_file", type=click.Path())
def main(input_file: str, output_file: str) -> None:
    """
    Convert CSV file to Markdown format for GitHub display.

    Args:
        input_file: Path to the input CSV file.
        output_file: Path to save the output Markdown file.
    """
    df: pd.DataFrame = pd.read_csv(input_file)
    md: str = df.to_markdown(index=False)
    with open(output_file, "w") as f:
        f.write(md)
    click.echo(f"Markdown report saved to {output_file}")


if __name__ == "__main__":
    main()
