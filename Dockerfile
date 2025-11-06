FROM node:22-alpine AS node

WORKDIR /app

COPY web ./web

RUN cd web && npm install && npm run build

FROM python:3.12.7

WORKDIR /app

COPY . .

COPY --from=node /app/web/out ./web/out

RUN python -m pip install --no-cache-dir uv -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && uv sync --index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && touch /.dockerenv

CMD [ "uv", "run", "main.py" ]