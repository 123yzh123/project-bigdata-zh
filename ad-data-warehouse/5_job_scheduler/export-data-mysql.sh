#测试用脚本生成的配置文件是否可用。

# todo 1 各省市-广告统计ads_ad_stats_by_province
python /opt/module/datax/bin/datax.py \
-p"-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_province" \
/opt/module/datax/job/ad_export/export.ad report.ads_ad_stats_by_province.json

# todo 2各广告平台-广告统i计ads_ad _stats_by_platform
python /opt/module/datax/bin/datax.py\
-p"-Dexportdir=/warehouse/ad_ads/adsad_stats_by_platform"\
/opt/module/datax/job/ad_export/export.ad_report.ads_ad_stats_by_platform:json

# todo 3 各操作系统-广告统计ads_ad stats by_os
python /opt/module/datax/bin/datax.py\
-p"-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_os"\
/opt/module/datax/job/ad_export/export.ad_report.ads_ad_stats_by_os.json

# todo 4 各小时-广告统计ads ad stats by hour
python /opt/module/datax/bin/datax.py\
-p"-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_hour"\
/opt/module/datax/job/ad_export/export.ad_report.ads_ad_stats_by_hour.json




# ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_hour' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_hour.json"
# ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_os' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_os.json"
# ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_platform' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_platform.json"
# ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_province' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_province.json"
