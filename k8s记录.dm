[k8s官网](kubernetes.io)

- #### kubernetes的优势

- 自动装箱，水平扩展，自我修复

- 服务发现和负载均衡

- 自动发布（默认滚动发布模式）和回滚

- 集中化配置管理和密钥管理

- 存储编排

- 任务批处理运行

## 1.kubernetes快速入门

- 四组基本概念
- Pod/Pod控制器
- Name/Namespace
- Label/Label选择器
- Service/Ingress



- ##### Pod

​       Pod是k8s里面能够被运行的最小逻辑单元(原子单元)

​       1个Pod里面可以运行多个容器，他们共享UTS+NET+IPC名称空间

​        可以把Pod理解成豌豆荚，而通一Pod内的每个容器是一颗颗豌豆

​        一个Pod里运行多个容器，又叫：边车(SideCar)模式

- ##### Pod控制器

​         Pod控制器是Pod启动的一种模板，用来保证在k8s里启动的Pod应始终按照人们的预期运行(副本数，生命周期，健康状态检查....)

​          K8s内提供了众多的Pod控制器，常用的有以下几种：

​          Deployment

​          DaemonSet

​          ReplicaSet

​          StatefulSet

​          job

​          Cronjob  

- Name

  ​          由于k8s内部，使用"资源" 来定义每一种逻辑概念（功能）故每种"资源"都因该有自己的"名称"

​                 "资源"  有api版本（apiVersion）类别（kind）,元数据 （metadata）定义清单（spec）状态（status）等配置信息

​                  "名称"  通常定义在  "资源"  的"元数据" 信息里



- Namespace

​                   随着项目增多，人员增加，集群规模的扩大，需要一种能够隔离k8s内各种"资源"的方法，这就是名称空间

​                   名称空间可以理解成为k8s内部的虚拟集群组

​                   不同名称空间内的"资源"，名称可以相同，相同名称空间内的同种"资源"，"名称" 不能相同

​                   合理的使用k8s的名称空间，使得集群管理员能够更好的对交付到k8s里的服务经行文磊管理和浏览

​                   k8s里默认存在的名称空间有：default，kube-system，kube-public

​                   查询k8s里特定 "资源" 要带上相应的名称空间

- Label

​                   标签是k8s特色的管理方式，便于分类管理资源对象

​                   一个标签可以对应多个资源，一个资源也可以有多个标签，他们是多对多的关系

​                   一个资源拥有多个标签，可以实现不用维度的管理。

​                   标签的组成：key=value

​                   与标签类似的，还有一种"注释" (annotations)

- Label选择器

​                    给资源打上标签后，可以使用标签选择器过滤指定的标签

​                    标签选择器目前有两个：基于等值关系（等于，不等于）和基于集合关系（属于。不属于。存在）

​                     许多资源支持内嵌标签选择器字段

​                          matchlabels

​                          matchexpressions

- Service

​                      在K8S的世界里,虽然每个Pod都会被分配一个单独的IP地址 ,但这个IP地址会随着Pod的销毁而消失

​                      Service (服务)就是用来解决这个问题的核心概念

​                      一个Service可以看作- 组提供相同服务的Pod的对外访问接口

​                      Service作用于哪些Pod是通过标签选择器来定义的 

- 核心组件

​          配置存储中心→etcd服务

​          主控( master )节点

​                          kube-apiserver服务

```apiserver
apiserver
提供了集群管理的REST 
API接口(包括鉴权、数据校验及集群状态变更) 
负责其他模块之间的数据交互,承担通信枢纽功能,是资源配额控制的入口,
提供完备的集群安全机制
```

​                          kube-controller-manager服务

```kube-controller-manager控制器
controller-manager
由一系列控制器组成,通过apiserver监控整个集群的状态,并确保集群处于预期的工作状态
Node Controller           #节点控制器
Deployment Controller     #Pod控制器
Service Controller        #服务控制器
Volume Controller         #存储卷控制器
Endpoint Controller       #接入点控制器
Garbage Controller        #垃圾回收控制前
Namespace Controller      #名称空间控制器
Job Controller            #任务控制器
Resource quta Controller  #资源配额控制器
```

​                          kube-scheduler服务

```scheduler
主要功能是接收调度pod到适合的运算节点上
预算策略( predict )
优选策略( priorities )
```



- 运算(node)节点

​                          kube-kubelet服务

```kubelet
简单地说, kubelet的主要功能就是定时从某个地方获取节点上pod的期望状态(运行什么容器、运行的副本数量、网络或者存储如何配置等等) , 并调用对应的容器平台接口达到这个状态
定时汇报当前节点的状态给apiserver,以供调度的时候使用
镜像和容器的清理工作保证节点上镜像不会占满磁盘空间，退出的容器不会占用太多资源
```

​                         Kube-proxy服务

```kube-proxy
kube-proxy是K8S在每个节点上运行网络代理, service资源的载体,建立了pod网络和集群网络的关系( clusterip>podip )
常用三种流量调度模式
●Userspace (废弃)
●Iptables (濒临废弃)
●Ipvs(推荐)
●负责建立和删除包括更新调度规则、通知apiserver自己的更新,或者从apiserver哪里获取其他kube-proxy的调度规则变化来更新自己的
```

![2021.3.31](C:\Users\L\Pictures\Saved Pictures\2021.3.31.png)

- CL客户端             

​                          kubectl

- 核心附件

​            CNI网络插件→ flannel/calico

​            服务发现用插件→coredns

​            服务暴露用插件→traefik

​             GUI管理插件→Dashboard



常见的K8S安装部署方式:

●Minikube 单节点微型K8S (仅供学习、 预览使用)

●二 进制安装部署(生产首选,新手推荐)

●使用kubeadmin进行部署, K8S的部署工具,跑在K8S里(相对简单,熟手推荐)



安装部署准备工作:

准备5台2c/2g/50g虚机,使用10.4.7.0/24网络

预装CentOS7.6操作系统,做好基础优化

安装部署bind9 ,部署自建DNS系统

准备自签证书环境

#### 环境基础

```
我这个实验环境是使用的是5台2c/2g/50g虚机,使用10.4.7.0/24网络
centos7.6 name=hdss7-11.host.com 10.4.7.11
centos7.6 name=hdss7-12.host.com 10.4.7.12
centos7.6 name=hdss7-21.host.com 10.4.7.21
centos7.6 name=hdss7-22.host.com 10.4.7.22
centos7.6 name=hdss7-200.host.com 10.4.7.200
```

#### 调整操作系统

所有主机上：

#### 调整yum源

#### 安装epel-release

```#
# yum -y install epel-release      #直接安装epel源
# curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo   #更换阿里epel源
# curl -0 /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  #更换阿里Base源
```

#### 关闭SElinux和firewalld

```#
# setenforce 0
# systemctl stop firewalld
```

#### 安装必要工具

```#
# yum install wget net-tools telnet tree nmap sysstat lrzsz dos2unix bind-utils -y
```

#### DNS服务初始化

hdss7-11.host.com上：

```dns
# yum -y install bind
[root@hdss7-11 ~]# rpm -qa bind
bind-9.11.4-26.P2.el7_9.4.x86_64      #bind版本
```

#### 配置bind9

```bind配置文件
/etc/named.conf
```

```bind
listen-on port 53 { 10.4.7.11; };       #监听到我们内网地址
listen-on-v6 port 53 { ::1; };          #ipv6这个需要删除掉
allow-query     { any; };    #指哪一些客户端能够通过我自建dns来查询dns解析，any指全部内网
forwarders      { 10.4.7.254; }; #添加forwarders指上级dns，直指到公网查询
recursion yes;    #dns采用递归的算发提供查询
dnssec-enable no;  #这个实验环境需要关闭，节省资源真实环境不需要关闭
dnssec-validation no;  #这个实验环境需要关闭，节省资源真实环境不需要关闭
[root@hdss7-11 ~]# named-checkconf   修改完检查有没有报错
[root@hdss7-11 ~]# 
```

#### 配置DNS

#### 区域配置文件

```配置文件
/etc/named.rfc1912.zones
```

```区域配置文件路径
zone "host.com" IN {
        type  master;
        file  "host.com.zone";
        allow-update { 10.4.7.11; };
};

zone "od.com" IN {
        type  master;
        file  "od.com.zone";
        allow-update { 10.4.7.11; };
};
```

#### 配置区域数据文件

#### 配置主机域

```
# vi /var/named/host.com.zone
```

```
$ORIGIN host.com.
$TTL 600        ;  10 minutes
@       IN SOA  dns.host.com. dnsadmin.host.com. (
                                202141001  ; serial
                                10800      ; refresh (3 hours)
                                900        ; retry (15 minutes)
                                604800     ; expire (1 week)
                                86400      ; minimum (1 day)
                                )
                      NS   dns.host.com.
$TTL 60 ; 1 minute
dns                A  10.4.7.11
HDSS7-11           A  10.4.7.11
HDSS7-12           A  10.4.7.12
HDSS7-21           A  10.4.7.21
HDSS7-22           A  10.4.7.22
HDSS7-200          A  10.4.7.200
```

#### 配置业务域数据文件

```
# vi /var/named/od.com.zone
```

```
$ORIGIN od.com.
$TTL 600        ;  10 minutes
@       IN SOA  dns.od.com. dnsadmin.od.com. (
                                202141001  ; serial
                                10800      ; refresh (3 hours)
                                900        ; retry (15 minutes)
                                604800     ; expire (1 week)
                                86400      ; minimum (1 day)
                                )
                      NS   dns.host.com.
$TTL 60 ; 1 minute
dns                A  10.4.7.11
```

#### 区域解析配置完成

```
[root@hdss7-11 ~]# named-checkconf       #检查DNS配置文件有没有报错
[root@hdss7-11 ~]# systemctl start named   #启动dns
[root@hdss7-11 ~]# systemctl enable named   #设置开机自启
[root@hdss7-11 ~]# netstat -luntp | grep 53   #查看端口是否启动
tcp        0      0 10.4.7.11:53            0.0.0.0:*               LISTEN      14659/named         
tcp        0      0 127.0.0.1:953           0.0.0.0:*               LISTEN      14659/named         
tcp6       0      0 ::1:953                 :::*                    LISTEN      14659/named         
udp        0      0 10.4.7.11:53            0.0.0.0:*                           14659/named         
```

#### 测试DNS是否正常解析

```
[root@hdss7-11 ~]# dig -t A hdss7-21.host.com @10.4.7.11 +short
10.4.7.21
[root@hdss7-11 ~]# dig -t A hdss7-200.host.com @10.4.7.11 +short    
10.4.7.200                                         #说明DNS服务已经正常能解析到我们每个主机的IP
[root@hdss7-11 ~]#
```

#### 配置DNS客户端

  Linux主机上

```
/etc/resolv.conf
search host.com   #主机域的短域名
nameserver 10.4.7.11
```

#### 准备签发证书环境

运维主机hdss7-200.host.com上：

#### 安装CFSSL

。证书签发工具CFSSL: R1.2

​         cfssl下载地址

​         cfssl-json下载地址

​         cfssl-certinfo下载地址

```
# wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O /usr/bin/cfssl
# wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O /usr/bin/cfssl-json
# wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 -O /usr/bin/cfssl-certinfo
# chmod +x /usr/bin/cfssl*
```



#### 创建生成CA证书签名请求(csr)的JSON配置文件

```
[root@hdss7-200 ~]# cd /opt/
[root@hdss7-200 opt]# mkdir certs
[root@hdss7-200 certs]# vi ca-csr.json
{
    "CN": "OldboyEdu",
    "hosts": [
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "fujian",
            "L": "xiamen",
            "O": "od",
            "OU": "ops"
        }
    ],
    "ca": {
        "expiry": "175200h"
    }
}
```

CN: Common Name ,浏览器使用该字段验证网站是否合法,-般写的是域名。 非常重要。浏览器使用该字段验证网站是否合法

C: Country,国家

ST:State,州,省

L: Locality,地区,城市

O: Organization Name ,组织名称,公司名称

OU: Organization Unit Name ,组织单位名称,公司部门

#### 开始签证书

```
[root@hdss7-200 certs]# cfssl gencert -initca ca-csr.json | cfssl-json -bare ca
2021/04/01 16:18:46 [INFO] generating a new CA key and certificate from CSR
2021/04/01 16:18:46 [INFO] generate received request
2021/04/01 16:18:46 [INFO] received CSR
2021/04/01 16:18:46 [INFO] generating key: rsa-2048
2021/04/01 16:18:47 [INFO] encoded CSR
2021/04/01 16:18:47 [INFO] signed certificate with serial number 362853644162865154609606601862885519669460049824
[root@hdss7-200 certs]# ll
total 16
-rw-r--r-- 1 root root  993 Apr  1 16:18 ca.csr
-rw-r--r-- 1 root root  342 Apr  1 16:12 ca-csr.json
-rw------- 1 root root 1675 Apr  1 16:18 ca-key.pem
-rw-r--r-- 1 root root 1338 Apr  1 16:18 ca.pem
[root@hdss7-200 certs]# 
```

#### 部署docker环境

#### hdss7-200.host.com   hdss7-21.host.com  hdss7-22.host.com

```
# curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

#### docker配置

```
[root@hdss7-21 ~]# mkdir -p /data/docker /etc/docker
[root@hdss7-21 ~]# vi /etc/docker/daemon.json
{
"graph": "/data/docker",
"storage-driver": "overlay2",
"insecure-registries": ["registry.access.redhat.com","quay.io","harbor.od.com"],
"registry-mirrors": ["https://q2gr04ke.mirrir.aliyuncs.com"],
"bip": "172.7.21.1/24",  #bip需要跟着宿主机变化
"exec-opts": ["native.cgroupdriver=systemd"],
"live-restore": true
}
[root@hdss7-21 ~]# systemctl start docker
[root@hdss7-21 ~]# systemctl enable docker
```

我在配置daemon.json的时候遇到一个报错启动不了docker

```
Job for docker.service failed because start of the service was attempted too often. See "systemctl status docker.service" and "journalctl -xe" for details.
To force a start use "systemctl reset-failed docker.service" followed by "systemctl start docker.service" again.
上述报错的解决方法
[root@hdss7-21 ~]# mv /etc/docker/daemon.json /etc/docker/daemon.conf
[root@hdss7-21 ~]# systemctl start docker  #然后在重启就成功了
```

#### 部署docker镜像私有仓库harbor

name=hdss7-200.host.com上：

下载软件二进制包并解压

https://github.com/goharbor/harbor/releases/tag/v2.2.1:注需下载的版本可以自行在GitHub上自行选择

```
[root@hdss7-200 opt]# mkdir src
[root@hdss7-200 src]# wget https://github.com/goharbor/harbor/releases/download/v2.2.1/harbor-offline-installer-v2.2.1.tgz
[root@hdss7-200 src]# tar xf harbor-offline-installer-v2.2.1.tgz -C /opt/
[root@hdss7-200 opt]# mv harbor/ harbor-v2.2.1       #给他改个名字方便记忆版本
[root@hdss7-200 opt]# ln -s /opt/harbor-v2.2.1/ /opt/harbor     #创建软链接
[root@hdss7-200 opt]# cd harbor
[root@hdss7-200 harbor]# ll
total 493156
-rw-r--r-- 1 root root      3361 Mar 26 13:32 common.sh
-rw-r--r-- 1 root root 504956561 Mar 26 13:33 harbor.v2.2.1.tar.gz
-rw-r--r-- 1 root root      7840 Mar 26 13:32 harbor.yml.tmpl   #主配置文件
-rwxr-xr-x 1 root root      2500 Mar 26 13:32 install.sh
-rw-r--r-- 1 root root     11347 Mar 26 13:32 LICENSE
-rwxr-xr-x 1 root root      1881 Mar 26 13:32 prepare
这里需要修改harbor.yml.tmpl主配置文件
第一个需要修改的地方
hostname: harbor.od.com       #修改成自己的业务域
  port: 180     #搓开监听端口因为等下还要安装nginx
harbor_admin_password: Harbor12345   #默认明文密码这里是虚拟环境我这边都不修改harbor密码了
data_volume: /data/harbor        #修改存储路径
    location: /data/harbor/logs   #修改日志路径
#https不使用的话需要全部给注释掉
# https related config
#https:
  # https port for harbor, default is 443
  #port: 443
  # The path of cert and key files for nginx
  #certificate: /your/certificate/path
  #private_key: /your/private/key/path
[root@hdss7-200 harbor]# mv harbor.yml.tmpl harbor.yml
[root@hdss7-200 harbor]# mkdir -p /data/harbor/logs
[root@hdss7-200 harbor]# curl -L https://get.daocloud.io/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose   #安装harbor单机编排依赖包
[root@hdss7-200 harbor]# chmod +x /usr/local/bin/docker-compose
[root@hdss7-200 harbor]# ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
[root@hdss7-200 harbor]# ./prepare
[root@hdss7-200 harbor]# ./install.sh
[root@hdss7-200 harbor]# docker-compose version      #查看docker-compose版本是否足够否则可能出现版本过低没有配置文件
docker-compose version 1.27.4, build 40524192
docker-py version: 4.3.1
CPython version: 3.7.7
OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
[root@hdss7-200 harbor]# docker-compose ps
      Name                     Command                  State                 Ports          
---------------------------------------------------------------------------------------------
harbor-core         /harbor/entrypoint.sh            Up (healthy)                            
harbor-db           /docker-entrypoint.sh            Up (healthy)                            
harbor-jobservice   /harbor/entrypoint.sh            Up (healthy)                            
harbor-log          /bin/sh -c /usr/local/bin/ ...   Up (healthy)   127.0.0.1:1514->10514/tcp
harbor-portal       nginx -g daemon off;             Up (healthy)                            
nginx               nginx -g daemon off;             Up (healthy)   0.0.0.0:180->8080/tcp    
redis               redis-server /etc/redis.conf     Up (healthy)                            
registry            /home/harbor/entrypoint.sh       Up (healthy)                            
registryctl         /home/harbor/start.sh            Up (healthy)                            
[root@hdss7-200 harbor]# 
```

#### 安装nginx并且配置反向代理

```
[root@hdss7-200 ~]# yum -y install nginx
[root@hdss7-200 ~]# rpm -qa nginx
nginx-1.16.1-3.el7.x86_64
[root@hdss7-200 ~]# vi /etc/nginx/conf.d/harbor.od.com.conf
server {
    listen       80;
    server_name  harbor.od.com;

    client_max_body_size 1000m;     #表示客户端请求服务器最大允许大小

    location / {
        proxy_pass http://127.0.0.1:180;
    }
}
[root@hdss7-200 ~]# nginx -t
[root@hdss7-200 ~]# systemctl start nginx
[root@hdss7-200 ~]# systemctl enable nginx
[root@hdss7-200 ~]# curl harbor.od.com       #这里访问的时候会报错是应为没有dns解析记录
curl: (6) Could not resolve host: harbor.od.com; Unknown error
[root@hdss7-200 ~]# 
```

#### 在10.4.7.11上给harbor解析一个A记录

```
[root@hdss7-11 ~]# vi /var/named/od.com.zone
$ORIGIN od.com.
$TTL 600        ;  10 minutes
@       IN SOA  dns.od.com. dnsadmin.od.com. (
                                202141002  ; serial   #注意这里serial前滚一个序号
                                10800      ; refresh (3 hours)
                                900        ; retry (15 minutes)
                                604800     ; expire (1 week)
                                86400      ; minimum (1 day)
                                )
                      NS   dns.host.com.
$TTL 60 ; 1 minute
dns                A  10.4.7.11
harbor             A  10.4.7.200
[root@hdss7-11 ~]# systemctl restart named
[root@hdss7-11 ~]# dig -t A harbor.od.com +short    #测试解析是否成功
10.4.7.200                  #能正常解析ip说明A记录解析成功
[root@hdss7-11 ~]# 
然后浏览器打开http://harbor.od.com
```

![image-20210402142127319](C:\Users\luotingyi\AppData\Roaming\Typora\typora-user-images\image-20210402142127319.png)

![image-20210402164008076](C:\Users\luotingyi\AppData\Roaming\Typora\typora-user-images\image-20210402164008076.png)

#### 推送镜像到harbor.od.com上

```
这里我拿nginx1.7.9测试上传
[root@hdss7-200 ~]# docker pull nginx:1.7.9
[root@hdss7-200 ~]# docker tag 84581e99d807 harbor.od.com/test/nginx:v1.7.9
[root@hdss7-200 ~]# docker push harbor.od.com/test/nginx:v1.7.9
```

![image-20210402165732441](C:\Users\luotingyi\AppData\Roaming\Typora\typora-user-images\image-20210402165732441.png)

## 部署Master节点服务

#### 部署etcd集群

#### 集群规划

主机名                                                 角色

hdss7-12.host.com                           etcd lead

hdss7-21.host.com                           etcd follow

hdss7-22.host.com                           etcd follow

**注意**：这里部署文档以`hdss7-12.host.com`  主机为例，另外两台主机安装部署方法类似



#### 创建基于根证书的config配置文件

`这里是在运维主机上hdss7-200.host.com`创建的证书

```
[root@hdss7-200 certs]# vi /opt/certs/ca-config.json
{
    "signing": {
        "default": {
            "expiry": "175200h"
        },
        "profiles": {
            "server": {
                "expiry": "175200h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "175200h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "175200h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
```

证书类型

`client certificate :客户端使用,用于服务端认证客户端,例如etcdctl、etcd proxy、fleetctl.docker客户端`

`server certificate:服务端使用,客户端以此验证服务端身份,例如docker服务端、kube- apiserver`

`peer certificate:双向证书,用于etcd集群成员间通信`

#### 创建生成自签证书签名请求（csr）的JSON配置文件

```
运维主机hdss7-200.host.com上 ：
[root@hdss7-200 certs]# vi /opt/certs/etcd-peer-csr.json
{
    "CN": "k8s-etcd",
    "hosts": [
        "10.4.7.11",
        "10.4.7.12",
        "10.4.7.21",
        "10.4.7.22"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "xiamen",
            "L": "xiamen",
            "O": "od",
            "OU": "ops"
        }
    ]
}

```

#### 生成etcd证书和私钥

```
[root@hdss7-200 certs]# cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer etcd-peer-csr.json |cfssl-json -bare etcd-peer

l-json -bare etcd-peer
2021/04/02 17:19:41 [INFO] generate received request
2021/04/02 17:19:41 [INFO] received CSR
2021/04/02 17:19:41 [INFO] generating key: rsa-2048
2021/04/02 17:19:41 [INFO] encoded CSR
2021/04/02 17:19:41 [INFO] signed certificate with serial number 97331783239438458958034251146753747097669545704
2021/04/02 17:19:41 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
[root@hdss7-200 certs]# ll
total 36
-rw-r--r-- 1 root root  840 Apr  2 17:10 ca-config.json
-rw-r--r-- 1 root root  993 Apr  1 16:18 ca.csr
-rw-r--r-- 1 root root  342 Apr  1 16:12 ca-csr.json
-rw------- 1 root root 1675 Apr  1 16:18 ca-key.pem
-rw-r--r-- 1 root root 1338 Apr  1 16:18 ca.pem
-rw-r--r-- 1 root root 1062 Apr  2 17:19 etcd-peer.csr
-rw-r--r-- 1 root root  361 Apr  2 17:17 etcd-peer-csr.json
-rw------- 1 root root 1679 Apr  2 17:19 etcd-peer-key.pem
-rw-r--r-- 1 root root 1424 Apr  2 17:19 etcd-peer.pem
[root@hdss7-200 certs]#
```

#### 在三个节点上安装部署etcd集群

```
[root@hdss7-12 src]# useradd -s /sbin/nologin -M etcd
```

