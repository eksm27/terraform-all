import pytest

from httpx import AsyncClient, ASGITransport

from app.main import app


@pytest.mark.anyio
async def test_health():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test"
    ) as client:
        res = await client.get("/health")
        assert res.status_code == 200


@pytest.mark.anyio
async def test_octocat():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test"
    ) as client:
        res = await client.get("/octocat")
        assert res.status_code == 200
        assert isinstance(res.json(), list)