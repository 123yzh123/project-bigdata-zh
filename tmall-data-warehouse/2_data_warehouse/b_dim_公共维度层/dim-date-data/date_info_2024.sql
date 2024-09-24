/*
Navicat MySQL Data Transfer

Source Server         : node101-mysql
Source Server Version : 50729
Source Host           : node101:3306
Source Database       : db_test

Target Server Type    : MYSQL
Target Server Version : 50729
File Encoding         : 65001

Date: 2024-09-14 18:49:02
*/


CREATE DATABASE IF NOT EXISTS db_test ;
USE db_test;


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for date_info
-- ----------------------------
DROP TABLE IF EXISTS `date_info`;
CREATE TABLE `date_info` (
  `date_id` varchar(255) NOT NULL COMMENT '日',
  `week_id` int(11) DEFAULT NULL COMMENT '周ID',
  `week_day` int(11) DEFAULT NULL COMMENT '周几',
  `day` int(11) DEFAULT NULL COMMENT '每月的第几天',
  `month` int(11) DEFAULT NULL COMMENT '第几月',
  `quarter` int(11) DEFAULT NULL COMMENT '第几季度',
  `year` varchar(255) DEFAULT NULL COMMENT '年',
  `is_workday` int(11) DEFAULT NULL COMMENT '是否是工作日',
  `holiday_id` varchar(255) DEFAULT NULL COMMENT '节假日',
  PRIMARY KEY (`date_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='日期信息表';

SELECT * FROM date_info;

DROP TABLE IF EXISTS tmp_dim_date_info;
CREATE EXTERNAL TABLE tmp_dim_date_info (
    `date_id` STRING COMMENT '日',
    `week_id` STRING COMMENT '周ID',
    `week_day` STRING COMMENT '周几',
    `day` STRING COMMENT '每月的第几天',
    `month` STRING COMMENT '第几月',
    `quarter` STRING COMMENT '第几季度',
    `year` STRING COMMENT '年',
    `is_workday` STRING COMMENT '是否是工作日',
    `holiday_id` STRING COMMENT '节假日'
) COMMENT '时间维度表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/warehouse/gmall/tmp/tmp_dim_date_info/';

INSERT OVERWRITE TABLE dim_date SELECT * FROM tmp_dim_date_info;

-- ----------------------------
-- Records of date_info
-- ----------------------------
INSERT INTO `date_info` VALUES ('2024-01-01', '1', '1', '1', '1', '1', '2024', '0', '元旦');
INSERT INTO `date_info` VALUES ('2024-01-02', '1', '2', '2', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-03', '1', '3', '3', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-04', '1', '4', '4', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-05', '1', '5', '5', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-06', '1', '6', '6', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-07', '1', '7', '7', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-08', '2', '1', '8', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-09', '2', '2', '9', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-10', '2', '3', '10', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-11', '2', '4', '11', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-12', '2', '5', '12', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-13', '2', '6', '13', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-14', '2', '7', '14', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-15', '3', '1', '15', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-16', '3', '2', '16', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-17', '3', '3', '17', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-18', '3', '4', '18', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-19', '3', '5', '19', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-20', '3', '6', '20', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-21', '3', '7', '21', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-22', '4', '1', '22', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-23', '4', '2', '23', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-24', '4', '3', '24', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-25', '4', '4', '25', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-26', '4', '5', '26', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-27', '4', '6', '27', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-28', '4', '7', '28', '1', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-01-29', '5', '1', '29', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-30', '5', '2', '30', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-01-31', '5', '3', '31', '1', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-01', '5', '4', '1', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-02', '5', '5', '2', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-03', '5', '6', '3', '2', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-02-04', '5', '7', '4', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-05', '6', '1', '5', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-06', '6', '2', '6', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-07', '6', '3', '7', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-08', '6', '4', '8', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-09', '6', '5', '9', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-10', '6', '6', '10', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-11', '6', '7', '11', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-12', '7', '1', '12', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-13', '7', '2', '13', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-14', '7', '3', '14', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-15', '7', '4', '15', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-16', '7', '5', '16', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-17', '7', '6', '17', '2', '1', '2024', '0', '春节');
INSERT INTO `date_info` VALUES ('2024-02-18', '7', '7', '18', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-19', '8', '1', '19', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-20', '8', '2', '20', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-21', '8', '3', '21', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-22', '8', '4', '22', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-23', '8', '5', '23', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-24', '8', '6', '24', '2', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-02-25', '8', '7', '25', '2', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-02-26', '9', '1', '26', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-27', '9', '2', '27', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-28', '9', '3', '28', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-02-29', '9', '4', '29', '2', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-01', '9', '5', '1', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-02', '9', '6', '2', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-03', '9', '7', '3', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-04', '10', '1', '4', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-05', '10', '2', '5', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-06', '10', '3', '6', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-07', '10', '4', '7', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-08', '10', '5', '8', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-09', '10', '6', '9', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-10', '10', '7', '10', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-11', '11', '1', '11', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-12', '11', '2', '12', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-13', '11', '3', '13', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-14', '11', '4', '14', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-15', '11', '5', '15', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-16', '11', '6', '16', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-17', '11', '7', '17', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-18', '12', '1', '18', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-19', '12', '2', '19', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-20', '12', '3', '20', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-21', '12', '4', '21', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-22', '12', '5', '22', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-23', '12', '6', '23', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-24', '12', '7', '24', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-25', '13', '1', '25', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-26', '13', '2', '26', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-27', '13', '3', '27', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-28', '13', '4', '28', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-29', '13', '5', '29', '3', '1', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-03-30', '13', '6', '30', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-03-31', '13', '7', '31', '3', '1', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-04-01', '14', '1', '1', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-02', '14', '2', '2', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-03', '14', '3', '3', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-04', '14', '4', '4', '4', '2', '2024', '0', '清明节');
INSERT INTO `date_info` VALUES ('2024-04-05', '14', '5', '5', '4', '2', '2024', '0', '清明节');
INSERT INTO `date_info` VALUES ('2024-04-06', '14', '6', '6', '4', '2', '2024', '0', '清明节');
INSERT INTO `date_info` VALUES ('2024-04-07', '14', '7', '7', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-08', '15', '1', '8', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-09', '15', '2', '9', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-10', '15', '3', '10', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-11', '15', '4', '11', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-12', '15', '5', '12', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-13', '15', '6', '13', '4', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-04-14', '15', '7', '14', '4', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-04-15', '16', '1', '15', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-16', '16', '2', '16', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-17', '16', '3', '17', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-18', '16', '4', '18', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-19', '16', '5', '19', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-20', '16', '6', '20', '4', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-04-21', '16', '7', '21', '4', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-04-22', '17', '1', '22', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-23', '17', '2', '23', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-24', '17', '3', '24', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-25', '17', '4', '25', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-26', '17', '5', '26', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-27', '17', '6', '27', '4', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-04-28', '17', '7', '28', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-29', '18', '1', '29', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-04-30', '18', '2', '30', '4', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-01', '18', '3', '1', '5', '2', '2024', '0', '劳动节');
INSERT INTO `date_info` VALUES ('2024-05-02', '18', '4', '2', '5', '2', '2024', '0', '劳动节');
INSERT INTO `date_info` VALUES ('2024-05-03', '18', '5', '3', '5', '2', '2024', '0', '劳动节');
INSERT INTO `date_info` VALUES ('2024-05-04', '18', '6', '4', '5', '2', '2024', '0', '劳动节');
INSERT INTO `date_info` VALUES ('2024-05-05', '18', '7', '5', '5', '2', '2024', '0', '劳动节');
INSERT INTO `date_info` VALUES ('2024-05-06', '19', '1', '6', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-07', '19', '2', '7', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-08', '19', '3', '8', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-09', '19', '4', '9', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-10', '19', '5', '10', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-11', '19', '6', '11', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-12', '19', '7', '12', '5', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-05-13', '20', '1', '13', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-14', '20', '2', '14', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-15', '20', '3', '15', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-16', '20', '4', '16', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-17', '20', '5', '17', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-18', '20', '6', '18', '5', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-05-19', '20', '7', '19', '5', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-05-20', '21', '1', '20', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-21', '21', '2', '21', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-22', '21', '3', '22', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-23', '21', '4', '23', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-24', '21', '5', '24', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-25', '21', '6', '25', '5', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-05-26', '21', '7', '26', '5', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-05-27', '22', '1', '27', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-28', '22', '2', '28', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-29', '22', '3', '29', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-30', '22', '4', '30', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-05-31', '22', '5', '31', '5', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-01', '22', '6', '1', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-02', '22', '7', '2', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-03', '23', '1', '3', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-04', '23', '2', '4', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-05', '23', '3', '5', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-06', '23', '4', '6', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-07', '23', '5', '7', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-08', '23', '6', '8', '6', '2', '2024', '0', '端午节');
INSERT INTO `date_info` VALUES ('2024-06-09', '23', '7', '9', '6', '2', '2024', '0', '端午节');
INSERT INTO `date_info` VALUES ('2024-06-10', '24', '1', '10', '6', '2', '2024', '0', '端午节');
INSERT INTO `date_info` VALUES ('2024-06-11', '24', '2', '11', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-12', '24', '3', '12', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-13', '24', '4', '13', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-14', '24', '5', '14', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-15', '24', '6', '15', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-16', '24', '7', '16', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-17', '25', '1', '17', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-18', '25', '2', '18', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-19', '25', '3', '19', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-20', '25', '4', '20', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-21', '25', '5', '21', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-22', '25', '6', '22', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-23', '25', '7', '23', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-24', '26', '1', '24', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-25', '26', '2', '25', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-26', '26', '3', '26', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-27', '26', '4', '27', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-28', '26', '5', '28', '6', '2', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-06-29', '26', '6', '29', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-06-30', '26', '7', '30', '6', '2', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-01', '27', '1', '1', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-02', '27', '2', '2', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-03', '27', '3', '3', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-04', '27', '4', '4', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-05', '27', '5', '5', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-06', '27', '6', '6', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-07', '27', '7', '7', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-08', '28', '1', '8', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-09', '28', '2', '9', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-10', '28', '3', '10', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-11', '28', '4', '11', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-12', '28', '5', '12', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-13', '28', '6', '13', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-14', '28', '7', '14', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-15', '29', '1', '15', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-16', '29', '2', '16', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-17', '29', '3', '17', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-18', '29', '4', '18', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-19', '29', '5', '19', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-20', '29', '6', '20', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-21', '29', '7', '21', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-22', '30', '1', '22', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-23', '30', '2', '23', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-24', '30', '3', '24', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-25', '30', '4', '25', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-26', '30', '5', '26', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-27', '30', '6', '27', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-28', '30', '7', '28', '7', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-07-29', '31', '1', '29', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-30', '31', '2', '30', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-07-31', '31', '3', '31', '7', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-01', '31', '4', '1', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-02', '31', '5', '2', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-03', '31', '6', '3', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-04', '31', '7', '4', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-05', '32', '1', '5', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-06', '32', '2', '6', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-07', '32', '3', '7', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-08', '32', '4', '8', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-09', '32', '5', '9', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-10', '32', '6', '10', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-11', '32', '7', '11', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-12', '33', '1', '12', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-13', '33', '2', '13', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-14', '33', '3', '14', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-15', '33', '4', '15', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-16', '33', '5', '16', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-17', '33', '6', '17', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-18', '33', '7', '18', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-19', '34', '1', '19', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-20', '34', '2', '20', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-21', '34', '3', '21', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-22', '34', '4', '22', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-23', '34', '5', '23', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-24', '34', '6', '24', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-25', '34', '7', '25', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-08-26', '35', '1', '26', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-27', '35', '2', '27', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-28', '35', '3', '28', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-29', '35', '4', '29', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-30', '35', '5', '30', '8', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-08-31', '35', '6', '31', '8', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-01', '35', '7', '1', '9', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-02', '36', '1', '2', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-03', '36', '2', '3', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-04', '36', '3', '4', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-05', '36', '4', '5', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-06', '36', '5', '6', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-07', '36', '6', '7', '9', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-08', '36', '7', '8', '9', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-09', '37', '1', '9', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-10', '37', '2', '10', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-11', '37', '3', '11', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-12', '37', '4', '12', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-13', '37', '5', '13', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-14', '37', '6', '14', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-15', '37', '7', '15', '9', '3', '2024', '0', '中秋节');
INSERT INTO `date_info` VALUES ('2024-09-16', '38', '1', '16', '9', '3', '2024', '0', '中秋节');
INSERT INTO `date_info` VALUES ('2024-09-17', '38', '2', '17', '9', '3', '2024', '0', '中秋节');
INSERT INTO `date_info` VALUES ('2024-09-18', '38', '3', '18', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-19', '38', '4', '19', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-20', '38', '5', '20', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-21', '38', '6', '21', '9', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-22', '38', '7', '22', '9', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-23', '39', '1', '23', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-24', '39', '2', '24', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-25', '39', '3', '25', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-26', '39', '4', '26', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-27', '39', '5', '27', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-28', '39', '6', '28', '9', '3', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-09-29', '39', '7', '29', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-09-30', '40', '1', '30', '9', '3', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-01', '40', '2', '1', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-02', '40', '3', '2', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-03', '40', '4', '3', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-04', '40', '5', '4', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-05', '40', '6', '5', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-06', '40', '7', '6', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-07', '41', '1', '7', '10', '4', '2024', '0', '国庆节');
INSERT INTO `date_info` VALUES ('2024-10-08', '41', '2', '8', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-09', '41', '3', '9', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-10', '41', '4', '10', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-11', '41', '5', '11', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-12', '41', '6', '12', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-13', '41', '7', '13', '10', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-10-14', '42', '1', '14', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-15', '42', '2', '15', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-16', '42', '3', '16', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-17', '42', '4', '17', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-18', '42', '5', '18', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-19', '42', '6', '19', '10', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-10-20', '42', '7', '20', '10', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-10-21', '43', '1', '21', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-22', '43', '2', '22', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-23', '43', '3', '23', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-24', '43', '4', '24', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-25', '43', '5', '25', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-26', '43', '6', '26', '10', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-10-27', '43', '7', '27', '10', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-10-28', '44', '1', '28', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-29', '44', '2', '29', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-30', '44', '3', '30', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-10-31', '44', '4', '31', '10', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-01', '44', '5', '1', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-02', '44', '6', '2', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-03', '44', '7', '3', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-04', '45', '1', '4', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-05', '45', '2', '5', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-06', '45', '3', '6', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-07', '45', '4', '7', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-08', '45', '5', '8', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-09', '45', '6', '9', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-10', '45', '7', '10', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-11', '46', '1', '11', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-12', '46', '2', '12', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-13', '46', '3', '13', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-14', '46', '4', '14', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-15', '46', '5', '15', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-16', '46', '6', '16', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-17', '46', '7', '17', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-18', '47', '1', '18', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-19', '47', '2', '19', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-20', '47', '3', '20', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-21', '47', '4', '21', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-22', '47', '5', '22', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-23', '47', '6', '23', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-24', '47', '7', '24', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-11-25', '48', '1', '25', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-26', '48', '2', '26', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-27', '48', '3', '27', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-28', '48', '4', '28', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-29', '48', '5', '29', '11', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-11-30', '48', '6', '30', '11', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-01', '48', '7', '1', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-02', '49', '1', '2', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-03', '49', '2', '3', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-04', '49', '3', '4', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-05', '49', '4', '5', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-06', '49', '5', '6', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-07', '49', '6', '7', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-08', '49', '7', '8', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-09', '50', '1', '9', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-10', '50', '2', '10', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-11', '50', '3', '11', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-12', '50', '4', '12', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-13', '50', '5', '13', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-14', '50', '6', '14', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-15', '50', '7', '15', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-16', '51', '1', '16', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-17', '51', '2', '17', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-18', '51', '3', '18', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-19', '51', '4', '19', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-20', '51', '5', '20', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-21', '51', '6', '21', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-22', '51', '7', '22', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-23', '52', '1', '23', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-24', '52', '2', '24', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-25', '52', '3', '25', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-26', '52', '4', '26', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-27', '52', '5', '27', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-28', '52', '6', '28', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-29', '52', '7', '29', '12', '4', '2024', '0', null);
INSERT INTO `date_info` VALUES ('2024-12-30', '53', '1', '30', '12', '4', '2024', '1', null);
INSERT INTO `date_info` VALUES ('2024-12-31', '53', '2', '31', '12', '4', '2024', '1', null);
