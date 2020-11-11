# 基于 Docker 的 Phabricator 运行环境

安装：

- 克隆本仓库
- 把 `.env.example` 复制为 `.env`（如果宿主机的 8801、2201、22280 三个端口被其他程序占用，可在 `.env` 里指定其他端口号）
- 执行 `docker-compose run --rm fpm phabricator-configure.sh`
- 执行 `docker-compose up -d`
- 把域名 `phab.localhost` 解析到 `127.0.0.1`

完成了以上操作，即可通过 http://phab.localhost:8801 访问 Phabricator。

有问题？请[吐槽](https://github.com/modi/docker-phabricator/issues)。
