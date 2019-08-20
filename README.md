# 使用 Docker 运行 Phabricator

适用于体验、评估 Phabricator，包括：

- Web 界面
- Git 代码仓库托管及基于 SSH 协议的传输
- 后台工作队列
- 浏览器桌面通知（需要配置 SSL 反向代理）

## 使用说明

1.  克隆本仓库至 phab 目录：

    ```
    git clone git@github.com:modi/docker-phabricator.git phab
    ```

2.  参考 .env.example 创建 .env 文件。

    配置 Phabricator 站点域名：

    ```
    PHAB_HOST=phab.example.com
    ```

    如果需要调整 Docker 配置，可在 .env 中引用额外的配置文件：

    ```
    COMPOSE_FILE=docker-compose.yml:docker-compose.local.yml
    ```

3.  运行项目：

    ```
    docker-compose up -d
    ```

4.  应用配置：

    参考或直接使用 php 容器里 `/usr/local/bin/phabricator-init.sh` 进行配置：

    ```
    docker-compose exec --user phab php phabricator-init.sh
    ```

5.  启动 phd：

    ```
    docker-compose exec --user root php supervisorctl start phd
    ```

## 常见问题

### 怎么访问各项功能？

该项目添加了一个 Envoy 反向代理作为 Web 站点、SSH 服务、通知服务等的单一入口，将你在 .env 文件里配置的域名，指向这个容器即可。

### 为什么收不到桌面浏览器通知？

主流浏览器的安全设置禁用了非 HTTPS 的WebSocket，你可以修改 Envoy 的配置，增加 SSL 反向代理来解决。

### 不想配置邮件发送，怎么给 Phabricator 帐号设置密码？

使用 Phabricator 的命令行工具：`./bin/auth recover 帐号` 可获得一个设置密码的临时链接。

### 怎么访问托管的代码仓库？

和 GitHub / GitLab 操作类似，通过 Web 界面配置帐号的 SSH 公钥后，可执行下面的命令进行测试：

```
$ echo {} | ssh vcs@phab.example.com conduit conduit.ping
```

如果配置正确，响应类似：

```
{"result":"8522c60e44c2","error_code":null,"error_info":null}
```

