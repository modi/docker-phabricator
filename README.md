# Phabricator Docker 环境

Phabricator 的安装较繁琐。

本项目搭建了以下服务：

- Web 界面，端口 80
- Git 代码仓库托管（SSH 传输），端口 2222
- 后台工作队列

适用于体验、评估 Phabricator。

## 使用说明

1.  克隆仓库：

    以克隆至 `phab` 目录为例：

        git clone git@github.com:modi/docker-phabricator.git phab

2.  创建 Docker Compose 的 .env 文件

    .env 文件为 Docker Compose 环境提供配置，你可参考 .env.example，在仓库根目录创建 .env 文件。
    
    .env 文件中的 PHAB_HOST 指定了服务的主机名，如：

        PHAB_HOST=phab.example.com

    （选做）如果需要调整 Docker Compose 配置，可在 .env 中引用额外的配置文件：

        COMPOSE_FILE=docker-compose.yml:docker-compose.local.yml

3.  初始化配置和创建数据库：

    在仓库根目录执行：

        docker-compose run fpm phabricator-install.sh

    该命令执行时间可能较长。

4.  启动所有服务

    在仓库根目录执行：

        docker-compose up -d

## 常见问题

### 怎么访问各项功能？

环境提供了 Envoy 反向代理作为 Web 站点、SSH 服务、通知服务等的单一入口，
把你在 .env 里配置的站点域名指向 Envoy 容器的 IP 即可。

### 怎么找 Envoy 容器的 IP？

使用 `docker inspect` 命令，如：

    docker inspect phab_envoy_1 | grep IP

### Mac 上访问不了服务

Mac 上的容器是跑在虚拟机里的，你必须设置端口转发才能访问服务。

### 为什么收不到桌面浏览器通知？

主流浏览器的安全设置禁用了非 HTTPS 的 WebSocket 连接，你可以修改 Envoy 的配置，增加 SSL 反向代理来解决。

### 不想配置邮件发送，怎么给 Phabricator 帐号找回密码？

执行下面的命令，可得到一个设置密码的临时链接：

    docker-compose exec fpm bin/auth recover admin

### 怎么访问托管的代码仓库？

和 GitHub / GitLab 操作类似，通过 Web 界面配置帐号的 SSH 公钥后，可执行下面的命令进行测试：

```
$ echo {} | ssh -p 2222 vcs@phab.example.com conduit conduit.ping
```

如果配置正确，响应类似：

```
{"result":"8522c60e44c2","error_code":null,"error_info":null}
```

# TODO

- 区分 Phabricator 版本
- 添加 svn 仓库的托管
- 浏览器桌面通知
- 打包中文语言包
- 提供设置主机端口转发的配置
- 把配置，如对外端口改造成环境变量 https://stackoverflow.com/questions/54047568/how-can-i-use-environment-variables-in-the-envoyproxy-config-file
