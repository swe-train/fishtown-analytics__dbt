import pytest

from dbt.tests.adapter.persist_test_results.basic import PersistTestResults


class TestPersistTestResults(PersistTestResults):
    @pytest.fixture(scope="function", autouse=True)
    def setup_audit_schema(self, project, setup_method):
        # postgres only supports schema names of 63 characters
        # a schema with a longer name still gets created, but the name gets truncated
        self.audit_schema = self.audit_schema[:63]
