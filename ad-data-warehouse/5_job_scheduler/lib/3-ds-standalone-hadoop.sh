
# 参考文档
##  https://www.cnblogs.com/DolphinScheduler/p/18194381

# standalone-server/conf/common.properties

### data.basedir.path=自定义本地文件存储位置
### resource.storage.type=HDFS
### # resource store on HDFS/S3 path, resource file will store to this base path, self configuration, please make sure the directory exists on hdfs and have read write permissions. "/dolphinscheduler" is recommended
### resource.storage.upload.base.path=自定义hdfs的存储位置
### resource.hdfs.root.user=自定义用户名称，和本文档之前做的配置要一致
### # if resource.storage.type=S3, the value like: s3a://dolphinscheduler; if resource.storage.type=HDFS and namenode HA is enabled, you need to copy core-site.xml and hdfs-site.xml to conf dir
### resource.hdfs.fs.defaultFS=hdfs://xxx:8020



### #高可用ip地址
### yarn.resourcemanager.ha.rm.ids=xxxx,xxx
### # if resourcemanager HA is enabled or not use resourcemanager, please keep the default value; If resourcemanager is single, you only need to replace ds1 to actual resourcemanager hostname
### yarn.application.status.address=http://ds1:%s/ws/v1/cluster/apps/%s
### # job history status url when application number threshold is reached(default 10000, maybe it was set to 1000)
### yarn.job.history.status.address=http:/xxx:19888/jobhistory/logs/%s


