/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 80013
Source Host           : 127.0.0.1:3306
Source Database       : admin

Target Server Type    : MYSQL
Target Server Version : 80013
File Encoding         : 65001

Date: 2020-04-05 21:56:57
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for biz_order
-- ----------------------------
DROP TABLE IF EXISTS `biz_order`;
CREATE TABLE `biz_order` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `order_no` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '订单编号',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '订单名称',
  `pro_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '产品类型',
  `pro_num` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '产品数量',
  `pro_price` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '产品价格',
  `pro_material` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '产品材质',
  `material_source` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '原料厂家',
  `custom` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '客户联系人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `invoice_date` datetime DEFAULT NULL COMMENT '开票时间',
  `finish_date` datetime DEFAULT NULL COMMENT '完成时间',
  `plan_date` datetime DEFAULT NULL COMMENT '预计交期',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `with_tax` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '含税 1 是  0 否',
  `pay_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '付款方式',
  `pay_status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '付款状态 0-未付款 1-部分付款 2-已付款',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '状态 0 未开始  1生产中 2 完成  3 暂定 4 取消',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务订单';

-- ----------------------------
-- Records of biz_order
-- ----------------------------
INSERT INTO `biz_order` VALUES ('9c2e3070-773b-11ea-a149-3923e6a81090', '00001', 'AAA公司2020年订单', 'T100', '10000', '5000', '氧化铝', 'xxx之家', 'custom#ea5ebf72-183d-45ff-bb96-1329d1f34f5b', '2020-04-05 20:47:29', '2020-04-05 21:07:16', '2020-04-06 00:00:00', null, '2020-04-17 00:00:00', 'AAA公司2020年订单', '1', '0', '0', '1', '0');

-- ----------------------------
-- Table structure for biz_order_process
-- ----------------------------
DROP TABLE IF EXISTS `biz_order_process`;
CREATE TABLE `biz_order_process` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `order_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单id',
  `step_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '流程模板id',
  `user_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '用户id',
  `pro_num` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '数量',
  `form_data` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '表单数据',
  `plan_date` datetime DEFAULT NULL COMMENT '预计时间',
  `finish_date` datetime DEFAULT NULL COMMENT '完成时间',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '状态 0-待处理 1-处理中 2-完成 3-取消',
  `process_status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '是否激活 0-否 1-是',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '删除标记',
  `sort_no` int(4) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单流程';

-- ----------------------------
-- Records of biz_order_process
-- ----------------------------
INSERT INTO `biz_order_process` VALUES ('97244b30-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '72873570-7036-11ea-a6a5-4b1e2f1cc8c3', '1', '10', '{}', '2020-04-06 07:00:00', '2020-04-05 21:02:45', '2020-04-05 21:01:40', '2020-04-05 21:02:45', '生产10个', '2', '0', '0', '1');
INSERT INTO `biz_order_process` VALUES ('972cafa0-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '323f8fd0-6d02-11ea-b8ac-635441d89dad', '1', '10000', '{\"c2\":\"device#5718416f-3744-434e-b44d-b2465c32e2cc\",\"c1\":\"20\",\"c3\":\"100\",\"c4\":\"200\"}', '2020-04-08 04:06:00', '2020-04-05 21:04:07', '2020-04-05 21:02:46', '2020-04-05 21:04:07', null, '2', '0', '0', '2');
INSERT INTO `biz_order_process` VALUES ('972d9a00-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '89e8df10-773a-11ea-a149-3923e6a81090', '1', '10000', '{\"c2\":\"o1\"}', '2020-04-17 00:00:00', '2020-04-05 21:04:40', '2020-04-05 21:04:07', '2020-04-05 21:04:40', null, '2', '0', '0', '3');
INSERT INTO `biz_order_process` VALUES ('972e8460-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '9d2cd130-773a-11ea-a149-3923e6a81090', '1', '10000', '{\"c1\":\"outsource#16aa8be3-bbfe-419d-8d3b-6b0acca2f3ad\",\"c2\":\"1200\"}', '2020-04-23 00:00:00', '2020-04-05 21:04:59', '2020-04-05 21:04:40', '2020-04-05 21:04:59', '0001', '2', '0', '0', '4');
INSERT INTO `biz_order_process` VALUES ('972f20a0-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '00828130-773b-11ea-a149-3923e6a81090', '1', '10000', '{}', '2020-04-25 00:00:00', '2020-04-05 21:05:13', '2020-04-05 21:04:59', '2020-04-05 21:05:13', '10000', '2', '0', '0', '5');
INSERT INTO `biz_order_process` VALUES ('972fbce0-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '1378c880-773b-11ea-a149-3923e6a81090', '1', null, '{}', null, null, '2020-04-05 21:05:13', '2020-04-05 21:07:25', null, '1', '1', '0', '6');
INSERT INTO `biz_order_process` VALUES ('97303210-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '1a43d3d0-773b-11ea-a149-3923e6a81090', null, null, '{}', null, null, '2020-04-05 21:01:40', null, null, '0', '0', '0', '7');
INSERT INTO `biz_order_process` VALUES ('9730ce50-773d-11ea-bbb7-7541c5822b84', '9c2e3070-773b-11ea-a149-3923e6a81090', '27845060-773b-11ea-a149-3923e6a81090', null, null, '{}', null, null, '2020-04-05 21:01:40', null, null, '0', '0', '0', '8');

-- ----------------------------
-- Table structure for biz_process
-- ----------------------------
DROP TABLE IF EXISTS `biz_process`;
CREATE TABLE `biz_process` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '流程名称',
  `step_config` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '环节定义',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注',
  `status` char(1) DEFAULT NULL COMMENT '状态 1 正常  0 冻结',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务流程';

-- ----------------------------
-- Records of biz_process
-- ----------------------------
INSERT INTO `biz_process` VALUES ('4a0615b0-773b-11ea-a149-3923e6a81090', '正常产品流程', '[\"72873570-7036-11ea-a6a5-4b1e2f1cc8c3\",\"323f8fd0-6d02-11ea-b8ac-635441d89dad\",\"89e8df10-773a-11ea-a149-3923e6a81090\",\"9d2cd130-773a-11ea-a149-3923e6a81090\",\"00828130-773b-11ea-a149-3923e6a81090\",\"1378c880-773b-11ea-a149-3923e6a81090\",\"1a43d3d0-773b-11ea-a149-3923e6a81090\",\"27845060-773b-11ea-a149-3923e6a81090\"]', '2020-04-05 20:45:11', null, null, '1', '0');
INSERT INTO `biz_process` VALUES ('5608e220-773b-11ea-a149-3923e6a81090', '快速产品流程', '[\"72873570-7036-11ea-a6a5-4b1e2f1cc8c3\",\"323f8fd0-6d02-11ea-b8ac-635441d89dad\",\"89e8df10-773a-11ea-a149-3923e6a81090\",\"27845060-773b-11ea-a149-3923e6a81090\"]', '2020-04-05 20:45:31', null, null, '1', '0');

-- ----------------------------
-- Table structure for biz_step
-- ----------------------------
DROP TABLE IF EXISTS `biz_step`;
CREATE TABLE `biz_step` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `order_step` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '订单流程环节（sys_dict）',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '环节名称',
  `form_config` varchar(1000) DEFAULT NULL COMMENT '表单定义',
  `sort_no` int(4) DEFAULT NULL COMMENT '排序',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `status` char(1) DEFAULT NULL COMMENT '状态 1 正常  0 冻结',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务环节';

-- ----------------------------
-- Records of biz_step
-- ----------------------------
INSERT INTO `biz_step` VALUES ('00828130-773b-11ea-a149-3923e6a81090', 'order_step#f47e95c5-64a8-4156-9103-78155f37434b', '高温质检', '[]', '6', '2020-04-05 20:43:08', null, null, '1', '0');
INSERT INTO `biz_step` VALUES ('1378c880-773b-11ea-a149-3923e6a81090', 'order_step#bf7a6011-fd23-4d2c-b923-d653ee653512', '抛光', '[]', '7', '2020-04-05 20:43:40', null, null, '1', '0');
INSERT INTO `biz_step` VALUES ('1a43d3d0-773b-11ea-a149-3923e6a81090', 'order_step#bf7a6011-fd23-4d2c-b923-d653ee653512', '抛光质检', '[]', '8', '2020-04-05 20:43:51', null, null, '1', '0');
INSERT INTO `biz_step` VALUES ('27845060-773b-11ea-a149-3923e6a81090', 't3', '入库', '[]', '10', '2020-04-05 20:44:13', null, null, '1', '0');
INSERT INTO `biz_step` VALUES ('323f8fd0-6d02-11ea-b8ac-635441d89dad', 't2', '成型（干压）', '[{\"name\":\"设备\",\"work\":\"1\",\"key\":\"c2\",\"type\":\"dict_device\",\"def\":\"0\"},{\"name\":\"高度\",\"work\":\"123\",\"key\":\"c1\",\"type\":\"Input\",\"def\":\"0\"},{\"name\":\"重量\",\"key\":\"c3\",\"type\":\"Input\",\"def\":\"0\"},{\"name\":\"成型压力\",\"key\":\"c4\",\"type\":\"Input\",\"def\":\"0\"}]', '2', '2020-03-23 20:31:18', '2020-04-05 20:38:36', '成型（干压） -- 测试', '1', '0');
INSERT INTO `biz_step` VALUES ('72873570-7036-11ea-a6a5-4b1e2f1cc8c3', 't1', '模具生产', '[]', '1', '2020-03-27 22:22:54', '2020-04-05 20:37:04', '尝试', '1', '0');
INSERT INTO `biz_step` VALUES ('89e8df10-773a-11ea-a149-3923e6a81090', 't2', '素烧', '[{\"name\":\"外协单位\",\"key\":\"c2\",\"type\":\"dict_outsource\",\"def\":\"1\"}]', '3', '2020-04-05 20:39:49', null, '素烧 测试', '1', '0');
INSERT INTO `biz_step` VALUES ('9d2cd130-773a-11ea-a149-3923e6a81090', 'order_step#f47e95c5-64a8-4156-9103-78155f37434b', '高温', '[{\"name\":\"外协单位\",\"key\":\"c1\",\"type\":\"dict_outsource\",\"def\":\"1\"},{\"name\":\"升温曲线\",\"key\":\"c2\",\"type\":\"Input\",\"def\":\"0\"}]', '4', '2020-04-05 20:40:21', '2020-04-05 20:42:49', '高温高温', '1', '0');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `value` varchar(100) NOT NULL COMMENT '数据值',
  `label` varchar(100) NOT NULL COMMENT '标签名',
  `type` varchar(100) NOT NULL COMMENT '类型',
  `description` varchar(100) NOT NULL COMMENT '描述',
  `sort` decimal(10,0) NOT NULL COMMENT '排序（升序）',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_dict_value` (`value`),
  KEY `sys_dict_label` (`label`),
  KEY `sys_dict_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('0a22f3278a624882a822e0820f27efcb', '1', '主表', 'table_type', '表类型', '20', '2016-01-05 21:47:14', '2016-01-05 21:53:34', '', '0');
INSERT INTO `sys_dict` VALUES ('1c0ac576c33d41fcb4c16602bf4fad5d', 'post', 'post', 'interface_type', '接口类型', '20', '2015-11-30 15:52:25', '2015-11-30 15:52:39', '', '0');
INSERT INTO `sys_dict` VALUES ('221a918bd1e149239a17ab0fdeaf5ecd', 'get', 'get', 'interface_type', '接口类型', '10', '2015-11-30 15:51:56', '2015-11-30 15:51:56', '', '0');
INSERT INTO `sys_dict` VALUES ('43c9472f411c4d3eafb3bf5319ffe499', '2', '异常报告', 'report_type', '异常的报告', '20', '2015-12-08 17:49:57', '2015-12-08 17:49:57', '', '0');
INSERT INTO `sys_dict` VALUES ('5b899603552c48519e7ba8eb9da0b41f', '0', '单表', 'table_type', '表类型', '10', '2016-01-05 21:46:39', '2016-01-05 21:53:50', '', '0');
INSERT INTO `sys_dict` VALUES ('680ddd8c91fe43588a7bb7aafe816633', '1', '正常报告', 'report_type', '正常的报告', '10', '2015-12-08 17:49:28', '2015-12-08 17:49:28', '正常的报告', '0');
INSERT INTO `sys_dict` VALUES ('71804c6b820048b09c9f6f2c11121113', 'ace', 'ACE风格', 'theme', '主题方案', '15', '2016-04-20 21:57:21', '2016-04-20 21:57:21', '', '0');
INSERT INTO `sys_dict` VALUES ('86bfebb0-f1ec-11e7-b55b-a7aaa2233168', '1', '支付宝', 'order_type', '交易类型', '1', '2018-01-05 15:46:23', '2018-01-05 15:46:23', null, '0');
INSERT INTO `sys_dict` VALUES ('885b16c0-6d00-11ea-b8ac-635441d89dad', '1', '启用', 'status_type', '状态', '1', '2020-03-23 20:19:24', null, null, '0');
INSERT INTO `sys_dict` VALUES ('970c1340-6d00-11ea-b8ac-635441d89dad', '0', '停用', 'status_type', '状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('97538ae0-f1ec-11e7-b55b-a7aaa2233168', '2', '微信', 'order_type', '交易类型', '2', '2018-01-05 15:46:51', '2018-01-05 15:46:23', null, '0');
INSERT INTO `sys_dict` VALUES ('a1', '2', '完成', 'order_status', '订单状态', '3', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('a2', '0', '未开始', 'order_status', '订单状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('a3', '1', '生产中', 'order_status', '订单状态', '2', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('a4', '3', '暂停', 'order_status', '订单状态', '4', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('a5', '4', '取消', 'order_status', '订单状态', '5', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('b1', '1', '是', 'boolean_type', '状态', '1', '2020-03-23 20:19:24', null, null, '0');
INSERT INTO `sys_dict` VALUES ('b2', '0', '否', 'boolean_type', '状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('bde6043665ef4571b85d0edab667cd15', '3', '树结构表', 'table_type', '表类型', '40', '2016-01-06 19:48:50', '2016-01-06 19:48:50', '', '0');
INSERT INTO `sys_dict` VALUES ('cc94b0c5df554a46894991210a5fc486', '2', '附表', 'table_type', '表类型', '30', '2016-01-05 21:47:38', '2016-01-05 21:53:44', '', '0');
INSERT INTO `sys_dict` VALUES ('d4853790-772f-11ea-935f-717677812547', 'custom#ea5ebf72-183d-45ff-bb96-1329d1f34f5b', '测试客户1', 'custom', '客户', '1', '2020-04-05 19:23:10', null, null, '0');
INSERT INTO `sys_dict` VALUES ('d88710c0-772f-11ea-935f-717677812547', 'custom#65fd9cdb-8f33-4bef-9300-49900e26db0f', '测试客户2', 'custom', '客户', '2', '2020-04-05 19:23:16', null, null, '0');
INSERT INTO `sys_dict` VALUES ('ecb77a30-7739-11ea-a149-3923e6a81090', 'order_step#f47e95c5-64a8-4156-9103-78155f37434b', '高温', 'order_step', '订单环节', '3', '2020-04-05 20:35:25', '2020-04-05 20:35:52', null, '0');
INSERT INTO `sys_dict` VALUES ('ee6ae4a0-773b-11ea-a149-3923e6a81090', 'device#5718416f-3744-434e-b44d-b2465c32e2cc', '设备A', 'device', '设备', '1', '2020-04-05 20:49:47', null, null, '0');
INSERT INTO `sys_dict` VALUES ('f0792b30-773b-11ea-a149-3923e6a81090', 'device#51d94caf-2c62-4c10-bf22-fd46f365aae5', '设备B', 'device', '设备', '1', '2020-04-05 20:49:50', null, null, '0');
INSERT INTO `sys_dict` VALUES ('f0bf6de0-7739-11ea-a149-3923e6a81090', 'order_step#bf7a6011-fd23-4d2c-b923-d653ee653512', '抛光', 'order_step', '订单环节', '4', '2020-04-05 20:35:32', '2020-04-05 20:35:56', null, '0');
INSERT INTO `sys_dict` VALUES ('f3aa9500-773b-11ea-a149-3923e6a81090', 'device#5d1871da-5946-426c-aa88-f7ab9e0e110a', '设备C', 'device', '设备', '1', '2020-04-05 20:49:56', null, null, '0');
INSERT INTO `sys_dict` VALUES ('fc647800-773b-11ea-a149-3923e6a81090', 'outsource#16aa8be3-bbfe-419d-8d3b-6b0acca2f3ad', '龙鼎', 'outsource', '外协单位', '1', '2020-04-05 20:50:10', null, null, '0');
INSERT INTO `sys_dict` VALUES ('o1', 'o1', '唯达', 'outsource', '外协单位', '1', '2020-03-23 20:19:48', '2020-04-05 20:50:19', null, '0');
INSERT INTO `sys_dict` VALUES ('o2', 'o2', '素烧工厂B', 'outsource', '外协单位', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('o3', 'o3', '素烧工厂C', 'outsource', '外协单位', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('op1', '0', '待处理', 'order_process_type', '订单生产状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('op2', '1', '处理中', 'order_process_type', '订单生产状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('op3', '2', '完成', 'order_process_type', '订单生产状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('op4', '3', '取消', 'order_process_type', '订单生产状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('p1', '0', '银联', 'pay_type', '付款方式', '1', '2020-03-23 20:19:48', '2020-04-05 18:36:34', null, '0');
INSERT INTO `sys_dict` VALUES ('p2', '1', '支付宝', 'pay_type', '付款方式', '2', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('ps0', '0', '未付款', 'pay_status', '付款状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('ps1', '1', '部分付款', 'pay_status', '付款状态', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('ps2', '2', '已付款', 'pay_status', '付款状态', '2', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('s1', 'Input', '文本', 'field_type', '类型', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('s2', 'InputNumber', '数字', 'field_type', '类型', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('s3', 'dict_device', '设备', 'field_type', '类型', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('s4', 'dict_outsource', '外协单位', 'field_type', '类型', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('s5', 'dict_custom', '客户', 'field_type', '类型', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('t1', 't1', '模具', 'order_step', '订单环节', '1', '2020-03-23 20:19:48', null, null, '0');
INSERT INTO `sys_dict` VALUES ('t2', 't2', '成型', 'order_step', '订单环节', '2', '2020-03-23 20:19:48', '2020-04-05 20:34:41', null, '0');
INSERT INTO `sys_dict` VALUES ('t3', 't3', '入库', 'order_step', '订单环节', '5', '2020-03-23 20:19:48', '2020-04-05 20:35:59', null, '0');

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COMMENT='日志';

-- ----------------------------
-- Records of sys_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `pid` varchar(64) NOT NULL COMMENT '父级编号',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `sort` decimal(10,0) NOT NULL COMMENT '排序',
  `href` varchar(2000) DEFAULT NULL COMMENT '链接',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `is_show` char(1) NOT NULL COMMENT '是否在菜单中显示',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sys_menu_parent_id` (`pid`),
  KEY `sys_menu_del_flag` (`del_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8 COMMENT='菜单表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '0', 'sys_admin', '1', null, 'android-settings', '1', '2017-12-15 15:48:13', '2018-01-05 15:46:23', null, '0', '系统设置');
INSERT INTO `sys_menu` VALUES ('2', '1', 'sys_menu', '1', 'sys/sys_menu', 'android-menu', '1', '2017-12-15 15:50:39', '2018-01-05 15:46:23', null, '0', '菜单管理');
INSERT INTO `sys_menu` VALUES ('41', '1', 'sys_dict', '2', 'sys/sys_dict', 'cube', '1', '2017-12-25 23:19:01', '2017-12-25 23:19:45', null, '0', '字典管理');
INSERT INTO `sys_menu` VALUES ('49', '1', 'sys_user', '3', 'sys/sys_user', 'person', '1', '2018-01-08 16:16:56', '2018-01-05 15:46:23', null, '0', '用户管理');
INSERT INTO `sys_menu` VALUES ('51', '1', 'sys_role', '4', 'sys/sys_role', 'ios-cog-outline', '1', '2018-01-10 14:46:28', '2018-01-05 15:46:23', null, '0', '角色管理');
INSERT INTO `sys_menu` VALUES ('55', '0', 'demo', '9', null, '9', '1', '2018-01-16 16:22:52', '2020-04-05 17:51:08', null, '1', '演示页面');
INSERT INTO `sys_menu` VALUES ('56', '55', 'text-editor', '1', 'demo/neditor_demo', 'compose', '1', '2018-01-16 16:23:37', '2018-01-16 16:23:47', null, '1', '富文本编辑器');
INSERT INTO `sys_menu` VALUES ('57', '55', 'dict_demo', '2', 'demo/dict_demo', 'pound', '1', '2018-01-16 16:28:23', '2018-01-05 15:46:23', null, '1', '数据字典演示');
INSERT INTO `sys_menu` VALUES ('58', '55', 'file-upload', '7', 'demo/my-components/file-upload/file-upload', 'android-upload', '1', '2018-01-16 16:28:55', '2018-01-16 16:36:22', null, '1', '文件上传');
INSERT INTO `sys_menu` VALUES ('59', '55', 'md-editor', '3', 'demo/my-components/markdown-editor/markdown-editor', 'pound', '1', '2018-01-16 16:34:17', '2018-01-05 15:46:23', null, '1', 'Markdown编辑器');
INSERT INTO `sys_menu` VALUES ('60', '55', 'image-editor', '4', 'demo/my-components/image-editor/image-editor', 'crop', '1', '2018-01-16 16:34:50', '2018-01-16 16:34:56', null, '1', '图片预览编辑');
INSERT INTO `sys_menu` VALUES ('61', '55', 'draggable-list', '5', 'demo/my-components/draggable-list/draggable-list', 'arrow-move', '1', '2018-01-16 16:35:24', '2018-01-05 15:46:23', null, '1', '可拖拽列表');
INSERT INTO `sys_menu` VALUES ('62', '55', 'area-linkage', '6', 'demo/my-components/area-linkage/area-linkage', 'ios-more', '1', '2018-01-16 16:36:16', '2018-01-05 15:46:23', null, '1', '城市级联');
INSERT INTO `sys_menu` VALUES ('63', '55', 'count-to', '8', 'demo/my-components/count-to/count-to', 'arrow-graph-up-right', '1', '2018-01-16 16:36:46', '2018-01-05 15:46:23', null, '1', '数字渐变');
INSERT INTO `sys_menu` VALUES ('64', '55', 'shopping', '9', 'demo/advanced-router/component/shopping-info', 'ios-cart', '1', '2018-01-16 16:38:14', '2018-01-05 15:46:23', null, '1', '购物详情');
INSERT INTO `sys_menu` VALUES ('65', '0', 'international', '3', 'demo/international/international', 'earth', '1', '2018-01-16 16:38:59', '2018-01-05 15:46:23', null, '1', '国际化');
INSERT INTO `sys_menu` VALUES ('66', '0', 'error-page', '4', 'error-page/error-page', 'android-sad', '1', '2018-01-16 16:39:29', '2018-01-05 15:46:23', null, '1', '错误页面');
INSERT INTO `sys_menu` VALUES ('67', '0', 'form', '5', null, 'android-checkbox', '1', '2018-01-16 16:40:19', '2018-01-05 15:46:23', null, '1', '表单编辑');
INSERT INTO `sys_menu` VALUES ('68', '67', 'artical-publish', '1', 'demo/form/article-publish/article-publish', 'compose', '1', '2018-01-16 16:40:45', '2018-01-05 15:46:23', null, '1', '文章发布');
INSERT INTO `sys_menu` VALUES ('69', '67', 'workflow', '2', 'demo/form/work-flow/work-flow', 'arrow-swap', '1', '2018-01-16 16:41:07', '2018-01-05 15:46:23', null, '1', '工作流');
INSERT INTO `sys_menu` VALUES ('70', '67', 'preview', '3', 'demo/form/article-publish/preview', 'arrow-swap', '1', '2018-01-16 16:41:32', '2018-01-05 15:46:23', null, '1', '文章');
INSERT INTO `sys_menu` VALUES ('71', '0', 'tables', '6', null, 'ios-grid-view', '1', '2018-01-16 16:43:53', '2018-01-05 15:46:23', null, '1', '表格');
INSERT INTO `sys_menu` VALUES ('72', '71', 'dragable-table', '1', 'demo/tables/dragable-table', 'arrow-move', '1', '2018-01-16 16:44:21', '2018-01-05 15:46:23', null, '1', '可拖拽排序');
INSERT INTO `sys_menu` VALUES ('73', '71', 'editable-table', '2', 'demo/tables/editable-table', 'edit', '1', '2018-01-16 16:44:49', '2018-01-05 15:46:23', null, '1', '可编辑表格');
INSERT INTO `sys_menu` VALUES ('74', '71', 'searchable-table', '3', 'demo/tables/searchable-table', 'search', '1', '2018-01-16 16:45:42', '2018-01-05 15:46:23', null, '1', '可搜索表格');
INSERT INTO `sys_menu` VALUES ('75', '71', 'exportable-table', '4', 'demo/tables/exportable-table', 'code-download', '1', '2018-01-16 16:46:54', '2018-01-05 15:46:23', null, '1', '表格导出数据');
INSERT INTO `sys_menu` VALUES ('76', '71', 'table-to-image', '5', 'demo/tables/table-to-image', 'images', '1', '2018-01-16 16:47:23', '2018-01-05 15:46:23', null, '1', '表格转图片');
INSERT INTO `sys_menu` VALUES ('77', '0', 'advanced-router', '7', null, 'ios-infinite', '1', '2018-01-16 16:48:10', '2018-01-05 15:46:23', null, '1', '高级路由');
INSERT INTO `sys_menu` VALUES ('78', '77', 'mutative-router', '1', 'demo/advanced-router/mutative-router', 'link', '1', '2018-01-16 16:48:32', '2018-01-05 15:46:23', null, '1', '动态路由');
INSERT INTO `sys_menu` VALUES ('79', '77', 'argument-page', '2', 'demo/advanced-router/argument-page', 'android-send', '1', '2018-01-16 16:48:53', '2018-01-05 15:46:23', null, '1', '带参页面');
INSERT INTO `sys_menu` VALUES ('80', '1', 'sys_generator', '2', 'sys/generator', 'arrow-swap', '1', '2020-03-20 21:53:38', null, null, '0', '代码生成');
INSERT INTO `sys_menu` VALUES ('81', '0', 'biz', '2', '', 'android-locate', '1', '2020-03-22 19:13:21', '2020-04-05 20:23:51', null, '0', '业务');
INSERT INTO `sys_menu` VALUES ('82', '81', 'step', '2', 'biz/biz_step', 'logo-steam', '1', '2020-03-22 19:13:38', '2020-03-28 19:40:26', null, '0', '环节定义');
INSERT INTO `sys_menu` VALUES ('83', '81', 'process', '2', 'biz/biz_process', 'analytics-outline', '1', '2020-03-27 23:06:48', '2020-03-28 19:41:55', null, '0', '流程定义');
INSERT INTO `sys_menu` VALUES ('84', '81', 'order', '3', 'biz/biz_order', '1', '1', '2020-03-28 22:17:35', null, null, '0', '订单管理');
INSERT INTO `sys_menu` VALUES ('85', '81', 'order_process', '4', 'biz/biz_order_process', '1', '1', '2020-03-30 22:06:15', null, null, '0', '订单生产');
INSERT INTO `sys_menu` VALUES ('86', '0', 'config', '1', null, 'android-apps', '1', '2020-04-05 17:50:52', '2020-04-05 20:22:24', null, '0', '业务配置');
INSERT INTO `sys_menu` VALUES ('87', '86', 'pay_type', '1', 'config/pay_type', '1', '1', '2020-04-05 18:09:11', null, null, '0', '付款方式');
INSERT INTO `sys_menu` VALUES ('88', '86', 'custom', '1', 'config/custom', '1', '1', '2020-04-05 18:09:11', null, null, '0', '客户');
INSERT INTO `sys_menu` VALUES ('89', '86', 'device', '1', 'config/device', '1', '1', '2020-04-05 18:09:11', null, null, '0', '设备');
INSERT INTO `sys_menu` VALUES ('90', '86', 'order_step', '1', 'config/order_step', '1', '1', '2020-04-05 18:09:11', null, null, '0', '订单环节');
INSERT INTO `sys_menu` VALUES ('91', '86', 'outsource', '1', 'config/outsource', '1', '1', '2020-04-05 18:09:11', null, null, '0', '外协单位');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `name` varchar(100) NOT NULL COMMENT '角色名称',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `sys_role_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1c54e003c1fc4dcd9b087ef8d48abac3', '操作员', '2015-11-11 15:59:43', '2020-04-05 21:48:04', '', '0');
INSERT INTO `sys_role` VALUES ('58260050-773c-11ea-a149-3923e6a81090', '员工', '2020-04-05 20:52:44', '2020-04-05 21:48:13', null, '0');
INSERT INTO `sys_role` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '管理员', '2018-01-10 16:22:48', '2020-04-05 21:47:48', null, '0');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` varchar(64) NOT NULL COMMENT '角色编号',
  `menu_id` varchar(64) NOT NULL COMMENT '菜单编号',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-菜单';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('1c54e003c1fc4dcd9b087ef8d48abac3', '81');
INSERT INTO `sys_role_menu` VALUES ('1c54e003c1fc4dcd9b087ef8d48abac3', '82');
INSERT INTO `sys_role_menu` VALUES ('1c54e003c1fc4dcd9b087ef8d48abac3', '83');
INSERT INTO `sys_role_menu` VALUES ('1c54e003c1fc4dcd9b087ef8d48abac3', '84');
INSERT INTO `sys_role_menu` VALUES ('1c54e003c1fc4dcd9b087ef8d48abac3', '85');
INSERT INTO `sys_role_menu` VALUES ('58260050-773c-11ea-a149-3923e6a81090', '81');
INSERT INTO `sys_role_menu` VALUES ('58260050-773c-11ea-a149-3923e6a81090', '85');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '1');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '49');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '51');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '81');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '82');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '83');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '84');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '85');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '86');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '87');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '88');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '89');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '90');
INSERT INTO `sys_role_menu` VALUES ('711911f0-f5df-11e7-8d24-11bfb4b0f3be', '91');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` varchar(64) NOT NULL COMMENT '编号',
  `login_name` varchar(100) NOT NULL COMMENT '登录名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `name` varchar(100) NOT NULL COMMENT '姓名',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(200) NOT NULL COMMENT '电话',
  `login_ip` varchar(100) DEFAULT NULL COMMENT '最后登陆IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登陆时间',
  `create_date` datetime NOT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记',
  `role_id` varchar(64) DEFAULT NULL COMMENT '角色ID',
  `status` char(1) DEFAULT NULL COMMENT '状态 1 正常  0 冻结',
  PRIMARY KEY (`id`),
  KEY `sys_user_login_name` (`login_name`),
  KEY `sys_user_update_date` (`update_date`),
  KEY `sys_user_del_flag` (`del_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', 'admin', '96e79218965eb72c92a549dd5a330112', '超级管理员', 'justciffer@163.com', '18068279907', '', '2020-04-05 20:50:25', '2017-12-14 11:52:46', '2020-04-05 20:50:25', null, '0', null, '1');
INSERT INTO `sys_user` VALUES ('3f28fab0-e082-11e7-9787-67e0bff90b39', 'test', '96e79218965eb72c92a549dd5a330112', '测试', null, '', '', '2020-04-05 20:54:13', '2017-12-14 11:52:46', '2020-04-05 20:53:36', null, '0', '711911f0-f5df-11e7-8d24-11bfb4b0f3be', '1');
