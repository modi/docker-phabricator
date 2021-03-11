# 使用 Docker 运行 Phabricator

使用：

- 克隆本仓库
- 执行 `docker-compose up -d`
- 将域名 `p.localhost` 解析到 `127.0.0.1`

等待启动完成（实测过，1 核 1 G 的云服务器也能在 1 分钟以内初始化），然后通过 http://p.localhost:8181 访问 Phabricator。

提示：

- 如果宿主机的 8181、2222、22280 三个端口被其他进程占用，则必须调整配置

有问题？请[提交 Issue](https://github.com/modi/docker-phabricator/issues)，或者直接联系我。
