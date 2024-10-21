"""Main module tests.

This is the tests for the main module.
"""

from package.main import hello_polars


def test_hello_ploars():
    """Tests the hello_polars() function."""
    df = hello_polars("Kasper", 21)
    assert df["name"][0] == "Kasper"
    assert df["age"][0] == 21
