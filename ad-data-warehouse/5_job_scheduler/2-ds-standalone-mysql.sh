

# 1. 创建数据库
mysql -h node101 -P 3306 -uroot -p123456 -e "DROP DATABASE IF EXISTS dolphinscheduler;"
mysql -h node101 -P 3306 -uroot -p123456 -e "CREATE DATABASE dolphinscheduler DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"

# 2. 修改配置文件
cd /opt/module/dolphinscheduler/bin/env
vim dolphinscheduler_env.sh
##  添加如下内容:
export DATABASE=${DATABASE:-mysql}
export SPRING_PROFILES_ACTIVE=${DATABASE}
export SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
export SPRING_DATASOURCE_URL="jdbc:mysql://node101:3306/dolphinscheduler?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
export SPRING_DATASOURCE_USERNAME=root
export SPRING_DATASOURCE_PASSWORD=123456

# 3. 添加jar包
cd /opt/module/dolphinscheduler
cd tools/libs/
rz
##    mysql-connector-j-8.0.31.jar

cd /opt/module/dolphinscheduler
cd standalone-server/libs/standalone-server
rz
##    mysql-connector-j-8.0.31.jar

# 4. 初始化数据库
cd /opt/module/dolphinscheduler
bash tools/bin/upgrade-schema.sh

# 5. 启动服务
cd /opt/module/dolphinscheduler
bin/dolphinscheduler-daemon.sh start standalone-server
## jps
##     2072 StandaloneServer

# 6. 界面登录
## http://node103:12345/dolphinscheduler/ui
## 用户名和密码:
##     admin/dolphinscheduler123


# 7. B站资料
# 7.1 DolphinScheduler2.x安装到优化（基本使用）
  https://www.bilibili.com/video/BV1sa411x7Ep

# 7.2 Apache DolphinScheduler3任务调度快速入门教程（详细）
  https://www.bilibili.com/video/BV1AP411z7C6/

