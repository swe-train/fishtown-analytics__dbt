from argparse import Namespace
from collections.abc import Generator

import pytest

from dbt.flags import set_from_args


@pytest.fixture
def args_for_flags() -> Namespace:
    return Namespace()


@pytest.fixture(autouse=True)
def set_test_flags(args_for_flags: Namespace) -> Generator[None, None, None]:
    set_from_args(args_for_flags, {})
    # fixtures stop setup upon yield
    yield None
    # everything after yield is run at test teardown
    set_from_args(Namespace(), {})
