#!/bin/bash
if [ $# -lt 1 ]
then
    echo "No Args Input..."
    exit ;
fi


case $1 in
"sql")
        echo " --------------- 启动 spark-sql ---------------"
	/opt/module/spark/bin/spark-sql --master local[2] --conf spark.sql.shuffle.partitions=2
;;
"start")
        echo " --------------- 启动 spark thrift server on local---------------"
        ssh node101 "/opt/module/spark/sbin/start-thriftserver.sh --hiveconf hive.server2.thrift.port=10001 --hiveconf hive.server2.thrift.bind.host=node101 --name spark_sql_thriftserver2 --master local[2] --conf spark.sql.shuffle.partitions=2"
;;
"yarn")
        echo " --------------- 启动 spark thrift server on yarn ---------------"
        ssh node101 "/opt/module/spark/sbin/start-thriftserver.sh --hiveconf hive.server2.thrift.port=10001 --hiveconf hive.server2.thrift.bind.host=node101 --name spark_sql_thriftserver2 --master yarn --deploy-mode client --driver-cores 1 --driver-memory 1g --executor-cores 2 --executor-memory 1g --num-executors 2 --conf spark.sql.shuffle.partitions=2"
;;
"stop")
        echo " --------------- 停止 spark thrift server ---------------"
	ssh node101 "/opt/module/spark/sbin/stop-thriftserver.sh"
	ssh node101 "/opt/module/spark/sbin/stop-history-server.sh"
;;
"client")
        echo " --------------- 运行 beeline ---------------"
        /opt/module/spark/bin/beeline -u jdbc:hive2://node101:10001 -n bwie -p 123456
;;
"history")
        echo " --------------- 启动 spark history server ---------------"
        ssh node101 "/opt/module/spark/sbin/start-history-server.sh"
;;
*)
    echo "Input Args Error..."
;;
esac

