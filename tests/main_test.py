"""Main module tests.

This is the tests for the main module.
"""

from package.main import hello_polars


def test_hello_ploars():
    """Tests hello_polars function."""
    df = hello_polars("Kasper", 21)
