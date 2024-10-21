"""Template docstring.

This module contains code that create and prints a polars DataFrame.
"""

import polars as pl


def hello_polars(name: str) -> pl.DataFrame:
    """Create and returns a DataFrame.

    Returns
    -------
    pl.DataFrame:
            A DataFrame

    """
    first_name = name.split(" ")[0]
    data = [
        {
            "name": first_name,
            "age": 21,
        },
    ]

    df = pl.DataFrame(data)

    return df


if __name__ == "__main__":
    print(hello_polars("Kasper"))
