
/*
    todo EXPLAIN命令可以用于查看HiveSQL查询语句的执行计划。它可以帮助用户了解查询的执行过程，包括查询语句的优化、查询计划生成和查询执行等过程。
    EXPLAIN命令的语法如下：
        EXPLAIN [EXTENDED|DEPENDENCY|REWRITE|LOGICAL|AUTHORIZATION] select_statement;
    文档：
        https://blog.csdn.net/ytp552200ytp/article/details/132922437
*/

-- 1. 基本用法
EXPLAIN
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;

/*
 todo 显示SQL执行计划
STAGE DEPENDENCIES:
  Stage-1 is a root stage
  Stage-0 depends on stages: Stage-1
""
STAGE PLANS:
  Stage: Stage-1
    Map Reduce
      Map Operator Tree:
          TableScan
            alias: order_detail
            Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
            Select Operator
"              expressions: province_id (type: string), total_amount (type: decimal(16,2))"
"              outputColumnNames: province_id, total_amount"
              Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
              Group By Operator
"                aggregations: count(), sum(total_amount)"
                keys: province_id (type: string)
                mode: hash
"                outputColumnNames: _col0, _col1, _col2"
                Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
                Reduce Output Operator
                  key expressions: _col0 (type: string)
                  sort order: +
                  Map-reduce partition columns: _col0 (type: string)
                  Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
"                  value expressions: _col1 (type: bigint), _col2 (type: decimal(26,2))"
      Execution mode: vectorized
      Reduce Operator Tree:
        Group By Operator
"          aggregations: count(VALUE._col0), sum(VALUE._col1)"
          keys: KEY._col0 (type: string)
          mode: mergepartial
"          outputColumnNames: _col0, _col1, _col2"
          Statistics: Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE
          File Output Operator
            compressed: false
            Statistics: Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE
            table:
                input format: org.apache.hadoop.mapred.SequenceFileInputFormat
                output format: org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat
                serde: org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
""
  Stage: Stage-0
    Fetch Operator
      limit: -1
      Processor Tree:
        ListSink
""

*/


-- 2. 加上formatted - json格式输出数据
EXPLAIN FORMATTED
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;
/*
{
    "STAGE DEPENDENCIES": {
        "Stage-1": {
            "ROOT STAGE": "TRUE"
        },
        "Stage-0": {
            "DEPENDENT STAGES": "Stage-1"
        }
    },
    "STAGE PLANS": {
        "Stage-1": {
            "Map Reduce": {
                "Map Operator Tree:": [
                    {
                        "TableScan": {
                            "alias:": "order_detail",
                            "columns:": [
                                "province_id",
                                "total_amount"
                            ],
                            "database:": "hive_optimize",
                            "Statistics:": "Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE",
                            "table:": "order_detail",
                            "isTempTable:": "false",
                            "OperatorId:": "TS_0",
                            "children": {
                                "Select Operator": {
                                    "expressions:": "province_id (type: string), total_amount (type: decimal(16,2))",
                                    "columnExprMap:": {
                                        "BLOCK__OFFSET__INSIDE__FILE": "BLOCK__OFFSET__INSIDE__FILE",
                                        "INPUT__FILE__NAME": "INPUT__FILE__NAME",
                                        "ROW__ID": "ROW__ID",
                                        "create_time": "create_time",
                                        "dt": "dt",
                                        "id": "id",
                                        "product_id": "product_id",
                                        "product_num": "product_num",
                                        "province_id": "province_id",
                                        "total_amount": "total_amount",
                                        "user_id": "user_id"
                                    },
                                    "outputColumnNames:": [
                                        "province_id",
                                        "total_amount"
                                    ],
                                    "Statistics:": "Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE",
                                    "OperatorId:": "SEL_7",
                                    "children": {
                                        "Group By Operator": {
                                            "aggregations:": [
                                                "count()",
                                                "sum(total_amount)"
                                            ],
                                            "columnExprMap:": {
                                                "_col0": "province_id"
                                            },
                                            "keys:": "province_id (type: string)",
                                            "mode:": "hash",
                                            "outputColumnNames:": [
                                                "_col0",
                                                "_col1",
                                                "_col2"
                                            ],
                                            "Statistics:": "Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE",
                                            "OperatorId:": "GBY_8",
                                            "children": {
                                                "Reduce Output Operator": {
                                                    "columnExprMap:": {
                                                        "KEY._col0": "_col0",
                                                        "VALUE._col0": "_col1",
                                                        "VALUE._col1": "_col2"
                                                    },
                                                    "key expressions:": "_col0 (type: string)",
                                                    "sort order:": "+",
                                                    "Map-reduce partition columns:": "_col0 (type: string)",
                                                    "Statistics:": "Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE",
                                                    "value expressions:": "_col1 (type: bigint), _col2 (type: decimal(26,2))",
                                                    "OperatorId:": "RS_9"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                ],
                "Execution mode:": "vectorized",
                "Reduce Operator Tree:": {
                    "Group By Operator": {
                        "aggregations:": [
                            "count(VALUE._col0)",
                            "sum(VALUE._col1)"
                        ],
                        "columnExprMap:": {
                            "_col0": "KEY._col0"
                        },
                        "keys:": "KEY._col0 (type: string)",
                        "mode:": "mergepartial",
                        "outputColumnNames:": [
                            "_col0",
                            "_col1",
                            "_col2"
                        ],
                        "Statistics:": "Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE",
                        "OperatorId:": "GBY_4",
                        "children": {
                            "File Output Operator": {
                                "compressed:": "false",
                                "Statistics:": "Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE",
                                "table:": {
                                    "input format:": "org.apache.hadoop.mapred.SequenceFileInputFormat",
                                    "output format:": "org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat",
                                    "serde:": "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
                                },
                                "OperatorId:": "FS_6"
                            }
                        }
                    }
                }
            }
        },
        "Stage-0": {
            "Fetch Operator": {
                "limit:": "-1",
                "Processor Tree:": {
                    "ListSink": {
                        "OperatorId:": "LIST_SINK_10"
                    }
                }
            }
        }
    }
}
*/



-- 3. 加上EXTENDED - 显示更多扩展信息
EXPLAIN EXTENDED
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;
/*
STAGE DEPENDENCIES:
  Stage-1 is a root stage
  Stage-0 depends on stages: Stage-1
""
STAGE PLANS:
  Stage: Stage-1
    Map Reduce
      Map Operator Tree:
          TableScan
            alias: order_detail
            Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
            GatherStats: false
            Select Operator
"              expressions: province_id (type: string), total_amount (type: decimal(16,2))"
"              outputColumnNames: province_id, total_amount"
              Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
              Group By Operator
"                aggregations: count(), sum(total_amount)"
                keys: province_id (type: string)
                mode: hash
"                outputColumnNames: _col0, _col1, _col2"
                Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
                Reduce Output Operator
                  key expressions: _col0 (type: string)
                  null sort order: a
                  sort order: +
                  Map-reduce partition columns: _col0 (type: string)
                  Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
                  tag: -1
"                  value expressions: _col1 (type: bigint), _col2 (type: decimal(26,2))"
                  auto parallelism: false
      Execution mode: vectorized
      Path -> Alias:
        hdfs://node101:8020/user/hive/warehouse/hive_optimize.db/order_detail/dt=2024-07-02 [order_detail]
      Path -> Partition:
        hdfs://node101:8020/user/hive/warehouse/hive_optimize.db/order_detail/dt=2024-07-02
          Partition
            base file name: dt=2024-07-02
            input format: org.apache.hadoop.mapred.TextInputFormat
            output format: org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat
            partition values:
              dt 2024-07-02
            properties:
              bucket_count -1
"              column.name.delimiter ,"
"              columns id,user_id,product_id,province_id,create_time,product_num,total_amount"
"              columns.comments '订单id','用户id','商品id','省份id','下单时间','商品件数','下单金额'"
"              columns.types string:string:string:string:string:int:decimal(16,2)"
              field.delim
              file.inputformat org.apache.hadoop.mapred.TextInputFormat
              file.outputformat org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat
              location hdfs://node101:8020/user/hive/warehouse/hive_optimize.db/order_detail/dt=2024-07-02
              name hive_optimize.order_detail
              numFiles 1
              numRows 0
              partition_columns dt
              partition_columns.types string
              rawDataSize 0
"              serialization.ddl struct order_detail { string id, string user_id, string product_id, string province_id, string create_time, i32 product_num, decimal(16,2) total_amount}"
              serialization.format
              serialization.lib org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
              totalSize 1176009934
              transient_lastDdlTime 1719907333
            serde: org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe

              input format: org.apache.hadoop.mapred.TextInputFormat
              output format: org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat
              properties:
                bucket_count -1
                bucketing_version 2
"                column.name.delimiter ,"
"                columns id,user_id,product_id,province_id,create_time,product_num,total_amount"
"                columns.comments '订单id','用户id','商品id','省份id','下单时间','商品件数','下单金额'"
"                columns.types string:string:string:string:string:int:decimal(16,2)"
                comment 优化测试表：订单交易明细表
                field.delim
                file.inputformat org.apache.hadoop.mapred.TextInputFormat
                file.outputformat org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat
                location hdfs://node101:8020/user/hive/warehouse/hive_optimize.db/order_detail
                name hive_optimize.order_detail
                partition_columns dt
                partition_columns.types string
"                serialization.ddl struct order_detail { string id, string user_id, string product_id, string province_id, string create_time, i32 product_num, decimal(16,2) total_amount}"
                serialization.format
                serialization.lib org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
                transient_lastDdlTime 1719907233
              serde: org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
              name: hive_optimize.order_detail
            name: hive_optimize.order_detail
      Truncated Path -> Alias:
        /hive_optimize.db/order_detail/dt=2024-07-02 [order_detail]
      Needs Tagging: false
      Reduce Operator Tree:
        Group By Operator
"          aggregations: count(VALUE._col0), sum(VALUE._col1)"
          keys: KEY._col0 (type: string)
          mode: mergepartial
"          outputColumnNames: _col0, _col1, _col2"
          Statistics: Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE
          File Output Operator
            compressed: false
            GlobalTableId: 0
            directory: hdfs://node101:8020/tmp/hive/bwie/6d81123c-89ab-4fc5-b250-bc8330fcb57e/hive_2024-07-02_16-49-32_996_6295981475585967882-4/-mr-10001/.hive-staging_hive_2024-07-02_16-49-32_996_6295981475585967882-4/-ext-10002
            NumFilesPerFileSink: 1
            Statistics: Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE
            Stats Publishing Key Prefix: hdfs://node101:8020/tmp/hive/bwie/6d81123c-89ab-4fc5-b250-bc8330fcb57e/hive_2024-07-02_16-49-32_996_6295981475585967882-4/-mr-10001/.hive-staging_hive_2024-07-02_16-49-32_996_6295981475585967882-4/-ext-10002/
            table:
                input format: org.apache.hadoop.mapred.SequenceFileInputFormat
                output format: org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat
                properties:
"                  columns _col0,_col1,_col2"
"                  columns.types string:bigint:decimal(26,2)"
                  escape.delim \
                  hive.serialization.extend.additional.nesting.levels true
                  serialization.escape.crlf true
                  serialization.format 1
                  serialization.lib org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
                serde: org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
            TotalFiles: 1
            GatherStats: false
            MultiFileSpray: false
""
  Stage: Stage-0
    Fetch Operator
      limit: -1
      Processor Tree:
        ListSink
""
*/



-- 4. 加上DEPENDENCY - 显示更多扩展信息
EXPLAIN DEPENDENCY
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;
/*
{
    "input_tables": [
        {
            "tablename": "hive_optimize@order_detail",
            "tabletype": "MANAGED_TABLE"
        }
    ],
    "input_partitions": [
        {
            "partitionName": "hive_optimize@order_detail@dt=2024-07-02"
        }
    ]
}
*/



explain SELECT
            count(t.province_id) AS province_count
        FROM (
                 -- a. 省份分组，去重
                 SELECT
                     province_id
                 FROM hive_optimize.order_detail
                 GROUP BY province_id
             ) t
;
/*
STAGE DEPENDENCIES:
  Stage-1 is a root stage
  Stage-2 depends on stages: Stage-1
  Stage-0 depends on stages: Stage-2
""
STAGE PLANS:
  Stage: Stage-1
    Map Reduce
      Map Operator Tree:
          TableScan
            alias: order_detail
            Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
            Select Operator
              expressions: province_id (type: string)
              outputColumnNames: province_id
              Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
              Group By Operator
                keys: province_id (type: string)
                mode: hash
                outputColumnNames: _col0
                Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
                Reduce Output Operator
                  key expressions: _col0 (type: string)
                  sort order: +
                  Map-reduce partition columns: _col0 (type: string)
                  Statistics: Num rows: 13066777 Data size: 11760099340 Basic stats: COMPLETE Column stats: NONE
      Execution mode: vectorized
      Reduce Operator Tree:
        Group By Operator
          keys: KEY._col0 (type: string)
          mode: mergepartial
          outputColumnNames: _col0
          Statistics: Num rows: 6533388 Data size: 5880049219 Basic stats: COMPLETE Column stats: NONE
          Group By Operator
            aggregations: count(_col0)
            mode: hash
            outputColumnNames: _col0
            Statistics: Num rows: 1 Data size: 8 Basic stats: COMPLETE Column stats: NONE
            File Output Operator
              compressed: false
              table:
                  input format: org.apache.hadoop.mapred.SequenceFileInputFormat
                  output format: org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat
                  serde: org.apache.hadoop.hive.serde2.lazybinary.LazyBinarySerDe
""
  Stage: Stage-2
    Map Reduce
      Map Operator Tree:
          TableScan
            Reduce Output Operator
              sort order:
              Statistics: Num rows: 1 Data size: 8 Basic stats: COMPLETE Column stats: NONE
              value expressions: _col0 (type: bigint)
      Execution mode: vectorized
      Reduce Operator Tree:
        Group By Operator
          aggregations: count(VALUE._col0)
          mode: mergepartial
          outputColumnNames: _col0
          Statistics: Num rows: 1 Data size: 8 Basic stats: COMPLETE Column stats: NONE
          File Output Operator
            compressed: false
            Statistics: Num rows: 1 Data size: 8 Basic stats: COMPLETE Column stats: NONE
            table:
                input format: org.apache.hadoop.mapred.SequenceFileInputFormat
                output format: org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat
                serde: org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe
""
  Stage: Stage-0
    Fetch Operator
      limit: -1
      Processor Tree:
        ListSink
""

*/
