/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 50139
 Source Host           : localhost
 Source Database       : aceim_development

 Target Server Type    : MySQL
 Target Server Version : 50139
 File Encoding         : utf-8

 Date: 09/10/2011 23:49:09 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `session`
-- ----------------------------
DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_session_on_session_id` (`session_id`),
  KEY `index_session_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

