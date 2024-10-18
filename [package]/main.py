"""Template docstring.

The purpose of this code it to print "Hello, World"
"""

import polars as pl


def hello_polars() -> pl.DataFrame:
    """Create and returns a DataFrame.

    Returns:
        pl.DataFrame:
            A DataFrame

    """
    data = [
        {
            "name": "Kasper",
            "age": 21,
        },
    ]

    df = pl.DataFrame(data)

    return df


if __name__ == "__main__":
    print("Hello, World!")
