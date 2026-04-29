/*
 * 学习演进记录：CentOS 7 下 MySQL 8.0 与 5.7 环境搭建
 * 目标：实现本地物理机 Navicat 远程连接虚拟机数据库。
 */

/* * ==========================================
 * 阶段一：虚拟机资源分配与网络排错 (历史记录)
 * ==========================================
 * Q: 虚拟机分配 2核2G内存 的底层逻辑是什么？
 * A: 极简版 Linux 内存占用低，但 MySQL 8.0 的 InnoDB 引擎缓冲池对内存要求较高。分配 2G 可避免数据库启动或高负载时触发 OOM（内存溢出）导致进程被系统强制回收，同时为后续单机部署 Java 服务留出资源。
 * * Q: 克隆虚拟机后，必须修改哪些底层参数以避免网络冲突？
 * A: 必须修改 MAC地址（物理网卡唯一标识）、IP地址（局域网寻址标识）和 Hostname（主机名）。UUID 在当前测试场景下重复不影响通信。
 * * Q: CentOS 7 纯净版执行 yum 报错 404 的根本原因及解法？
 * A: CentOS 7 已彻底停止维护（EOL），官方移除了 mirrorlist 域名解析。必须将源地址替换为阿里云的 Vault（归档）源，并通过 sed 命令将内置变量 $releasever 强行替换为具体的系统版本号 7.9.2009。
 * * [历史执行代码]
 * sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo
 * sed -i 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.aliyun.com/centos-vault|g' /etc/yum.repos.d/CentOS-*.repo
 * sed -i 's/$releasever/7.9.2009/g' /etc/yum.repos.d/CentOS-*.repo
 * yum clean all 
 * yum makecache
 */

/* * ==========================================
 * 阶段二：MySQL 核心组件安装与初始化 (历史记录)
 * ==========================================
 * Q: 为什么安装 RPM 包之前必须执行 yum remove mysql-libs？
 * A: CentOS 7 底层默认携带同源的 MariaDB 库文件。如果不卸载，在安装 mysql-community-libs 时会 100% 触发依赖取代失败的阻断报错。
 * * Q: 为什么安装 Server 服务端包时会报错缺依赖？
 * A: MySQL 服务端底层包含部分用 Perl 语言编写的管理脚本。极简版 Linux 缺失该解释器，需执行 yum install perl 补齐运行环境。
 * * [历史执行代码]
 * yum remove mysql-libs -y
 * yum install libaio net-tools perl vim -y
 * rpm -ivh mysql-community-common...
 * rpm -ivh mysql-community-client-plugins... (仅8.0有此包)
 * rpm -ivh mysql-community-libs...
 * rpm -ivh mysql-community-client...
 * rpm -ivh mysql-community-server...
 * mysqld --initialize --user=mysql
 * cat /var/log/mysqld.log
 */

/* * ==========================================
 * 阶段三：安全策略设定与跨版本特性处理 (历史记录)
 * ==========================================
 * Q: Navicat 连接 8.0 时报 2058 错误的底层原理是什么？
 * A: MySQL 8.0 默认启用了更严格的 caching_sha2_password 加密算法，旧版客户端无法解析。需在授权时将密码插件降级为原生的 mysql_native_password。
 * * Q: MySQL 5.7 存入中文报错 Incorrect string value 的底层逻辑？
 * A: 5.7 版本的 character_set_server 默认采用拉丁字符集 latin1，字典中无汉字编码映射。必须修改系统配置文件 /etc/my.cnf 强行覆盖为 utf8。8.0 版本已默认改为 utf8mb4，无此问题。
 * * [历史执行代码]
 * vi /etc/my.cnf  // 追加 character_set_server=utf8
 * systemctl restart mysqld.service
 */


# ==========================================
# 最终版：Linux MySQL 极简部署流水线脚本
# 用途：标准化拉起可供 Navicat 远程连接的数据库实例
# ==========================================

# 1. 基础环境排雷与权限释放
yum remove mysql-libs -y
chmod -R 777 /tmp
yum install libaio net-tools perl -y

# 2. 服务拉起与网络放行
systemctl start mysqld.service
systemctl enable mysqld.service
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --reload

# 3. 数据库远程授权配置 (进入 mysql> 交互模式执行)
/*
-- 修改初始密码 (8.0 需符合大写+小写+数字+特殊字符策略)
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Atguigu_666';

-- 开放外网访问权限
use mysql;
update user set host='%' where user='root';

-- 降级加密插件以兼容远端工具 (针对 8.0 版本)
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Atguigu_666';

-- 刷新系统权限表使配置落盘生效
flush privileges;
*/