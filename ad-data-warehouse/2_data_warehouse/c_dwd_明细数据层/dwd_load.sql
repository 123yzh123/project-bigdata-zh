USE ad_dwd ;

LOAD DATA INPATH '/origin_data/ad/ad_dwd_data/2024-10-04'
    OVERWRITE INTO TABLE ad_dwd.dwd_ad_event_inc PARTITION (dt='2024-10-04');


SHOW PARTITIONS ad_dwd.dwd_ad_event_inc;
SELECT * FROM ad_dwd.dwd_ad_event_inc WHERE dt = '2024-10-04' ;