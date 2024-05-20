from unittest.mock import MagicMock

import pytest

from dbt.artifacts.resources import DependsOn, NodeConfig
from dbt.artifacts.resources.base import NodeType
from dbt.contracts.graph.nodes import ModelNode


@pytest.fixture
def mock_model():
    return MagicMock(
        __class__=ModelNode,
        alias="model_one",
        name="model_one",
        database="dbt",
        schema="analytics",
        resource_type=NodeType.Model,
        unique_id="model.root.model_one",
        fqn=["root", "model_one"],
        package_name="root",
        original_file_path="model_one.sql",
        refs=[],
        sources=[],
        depends_on=DependsOn(),
        config=NodeConfig.from_dict(
            {
                "enabled": True,
                "materialized": "view",
                "persist_docs": {},
                "post-hook": [],
                "pre-hook": [],
                "vars": {},
                "quoting": {},
                "column_types": {},
                "tags": [],
            }
        ),
        tags=[],
        path="model_one.sql",
        language="sql",
        raw_code="",
        description="",
        columns={},
    )
