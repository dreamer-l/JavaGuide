-- ========== 1. 地理、赛事体系基础表 ==========

CREATE TABLE `continent` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '大洲ID，主键',
    `name` VARCHAR(64) NOT NULL COMMENT '大洲名称，如欧洲、亚洲、南美洲'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='大洲信息表';

CREATE TABLE `country` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '国家ID，主键',
    `continent_id` INT NOT NULL COMMENT '所属大洲ID，外键，关联continent表',
    `name` VARCHAR(64) NOT NULL COMMENT '国家全称，如中国、英格兰',
    `code` VARCHAR(8) COMMENT '国家编码，如CHN、ENG',
    `flag_url` VARCHAR(256) COMMENT '国旗图片URL',
    FOREIGN KEY (`continent_id`) REFERENCES `continent`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='国家信息表';

CREATE TABLE `league` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '联赛ID，主键',
    `country_id` INT NOT NULL COMMENT '所属国家ID，外键，关联country表',
    `name` VARCHAR(64) NOT NULL COMMENT '联赛全称，如英格兰超级联赛',
    `short_name` VARCHAR(32) COMMENT '联赛简称，如英超',
    `logo_url` VARCHAR(256) COMMENT '联赛Logo图片URL',
    `level` INT DEFAULT 0 COMMENT '联赛级别，1为顶级，2为次级等',
    `type` VARCHAR(32) COMMENT '联赛类型，如联赛、杯赛、锦标赛',
    `is_hot` TINYINT DEFAULT 0 COMMENT '是否为热门赛事，1为是，0为否',
    FOREIGN KEY (`country_id`) REFERENCES `country`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联赛信息表';

CREATE TABLE `league_i18n` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '多语言主键',
    `league_id` BIGINT NOT NULL COMMENT '关联联赛ID',
    `lang` VARCHAR(8) NOT NULL COMMENT '语言代码，如zh-CN、en',
    `name` VARCHAR(64) NOT NULL COMMENT '多语言联赛全称',
    `short_name` VARCHAR(32) COMMENT '多语言联赛简称',
    `description` VARCHAR(256) COMMENT '多语言描述',
    FOREIGN KEY (`league_id`) REFERENCES `league`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联赛多语言扩展表';

CREATE TABLE `season` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '赛季ID，主键',
    `league_id` BIGINT NOT NULL COMMENT '所属联赛ID，外键，关联league表',
    `year` VARCHAR(16) NOT NULL COMMENT '赛季年度，如2024-2025',
    `type` VARCHAR(32) COMMENT '赛季类型，如春季、秋季、全年',
    `start_date` DATE COMMENT '赛季开始日期',
    `end_date` DATE COMMENT '赛季结束日期',
    FOREIGN KEY (`league_id`) REFERENCES `league`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联赛赛季表';

CREATE TABLE `match_stage` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '阶段ID，主键',
    `season_id` INT NOT NULL COMMENT '所属赛季ID，外键，关联season表',
    `name` VARCHAR(64) NOT NULL COMMENT '阶段名称，如春季联赛、附加赛、决赛',
    `seq` INT DEFAULT 0 COMMENT '阶段顺序，数值越小越靠前',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事阶段表';

CREATE TABLE `match_group` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '分组ID，主键',
    `name` VARCHAR(64) NOT NULL COMMENT '分组名称，如A组、B组',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `stage_id` INT COMMENT '阶段ID，外键，关联match_stage表',
    `description` VARCHAR(128) COMMENT '分组描述',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`stage_id`) REFERENCES `match_stage`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事分组/小组表';

CREATE TABLE `match_round` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '轮次ID，主键',
    `stage_id` INT NOT NULL COMMENT '所属阶段ID，外键，关联match_stage表',
    `name` VARCHAR(32) NOT NULL COMMENT '轮次名称，如第1轮、半决赛、决赛',
    `seq` INT DEFAULT 0 COMMENT '轮次顺序，数值越小越靠前',
    FOREIGN KEY (`stage_id`) REFERENCES `match_stage`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事轮次表';

-- ========== 2. 球队、球员、教练、裁判、资料库扩展 ==========

CREATE TABLE `team` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '球队ID，主键',
    `country_id` INT COMMENT '所属国家ID，外键，关联country表',
    `name` VARCHAR(64) NOT NULL COMMENT '球队全称',
    `short_name` VARCHAR(32) COMMENT '球队简称',
    `logo_url` VARCHAR(256) COMMENT '球队Logo图片URL',
    `founded_year` INT COMMENT '球队成立年份',
    `home_stadium` VARCHAR(128) COMMENT '主场球场名称',
    FOREIGN KEY (`country_id`) REFERENCES `country`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队信息表';

CREATE TABLE `team_honor` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '荣誉ID，主键',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `honor_title` VARCHAR(128) NOT NULL COMMENT '荣誉名称，如英超冠军',
    `honor_season` VARCHAR(32) NOT NULL COMMENT '获奖赛季，如2023-2024',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队荣誉表';

CREATE TABLE `player` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '球员ID，主键',
    `team_id` BIGINT NOT NULL COMMENT '所属球队ID，外键，关联team表',
    `name` VARCHAR(64) NOT NULL COMMENT '球员姓名',
    `position` VARCHAR(32) COMMENT '球员场上位置，如前锋/中场/后卫/门将',
    `number` INT COMMENT '球衣号码',
    `nationality` VARCHAR(64) COMMENT '国籍',
    `birthday` DATE COMMENT '出生日期',
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球员信息表';

CREATE TABLE `player_transfer` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '转会ID，主键',
    `player_id` BIGINT NOT NULL COMMENT '球员ID，外键，关联player表',
    `from_team_id` BIGINT COMMENT '转出球队ID，外键，关联team表',
    `to_team_id` BIGINT COMMENT '转入球队ID，外键，关联team表',
    `transfer_date` DATE COMMENT '转会日期',
    `transfer_fee` DECIMAL(12,2) COMMENT '转会费',
    FOREIGN KEY (`player_id`) REFERENCES `player`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球员转会表';

CREATE TABLE `injury_suspend` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '伤病/停赛ID，主键',
    `player_id` BIGINT NOT NULL COMMENT '球员ID，外键，关联player表',
    `team_id` BIGINT COMMENT '球队ID，外键，关联team表',
    `match_id` BIGINT COMMENT '比赛ID，外键，关联`match`表',
    `injury_type` VARCHAR(32) COMMENT '伤病类型',
    `suspend_reason` VARCHAR(64) COMMENT '停赛原因',
    `start_date` DATE COMMENT '伤病/停赛开始日期',
    `end_date` DATE COMMENT '伤病/停赛结束日期',
    FOREIGN KEY (`player_id`) REFERENCES `player`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='伤病与停赛信息表';

CREATE TABLE `coach` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '教练ID，主键',
    `team_id` BIGINT COMMENT '当前执教球队ID，外键，关联team表',
    `name` VARCHAR(64) NOT NULL COMMENT '教练姓名',
    `nationality` VARCHAR(64) COMMENT '国籍',
    `birthday` DATE COMMENT '出生日期',
    `career_info` VARCHAR(512) COMMENT '执教经历',
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教练信息表';

CREATE TABLE `referee` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '裁判ID，主键',
    `name` VARCHAR(64) NOT NULL COMMENT '裁判姓名',
    `nationality` VARCHAR(64) COMMENT '国籍',
    `birthday` DATE COMMENT '出生日期',
    `referee_level` VARCHAR(32) COMMENT '裁判等级'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='裁判信息表';

-- ========== 3. 赛事主表与事件、比分、技术统计、推送、历史对阵 ==========

CREATE TABLE `match` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '比赛ID，主键',
    `match_uuid` VARCHAR(64) NOT NULL UNIQUE COMMENT '第三方数据源唯一比赛ID',
    `league_id` BIGINT NOT NULL COMMENT '联赛ID，外键，关联league表',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `stage_id` INT COMMENT '阶段ID，外键，关联match_stage表',
    `group_id` INT COMMENT '分组ID，外键，关联match_group表',
    `round_id` INT COMMENT '轮次ID，外键，关联match_round表',
    `home_team_id` BIGINT NOT NULL COMMENT '主队ID，外键，关联team表',
    `away_team_id` BIGINT NOT NULL COMMENT '客队ID，外键，关联team表',
    `match_time` DATETIME NOT NULL COMMENT '比赛开始时间',
    `status` VARCHAR(16) NOT NULL COMMENT '比赛状态，如未开赛、进行中、已完赛',
    `period` VARCHAR(16) COMMENT '当前比赛阶段period，如上半场/下半场/加时/点球',
    `venue` VARCHAR(128) COMMENT '比赛场馆',
    `referee_id` BIGINT COMMENT '主裁判ID，外键，关联referee表',
    `weather` VARCHAR(64) COMMENT '天气情况',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`league_id`) REFERENCES `league`(`id`),
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`stage_id`) REFERENCES `match_stage`(`id`),
    FOREIGN KEY (`group_id`) REFERENCES `match_group`(`id`),
    FOREIGN KEY (`round_id`) REFERENCES `match_round`(`id`),
    FOREIGN KEY (`home_team_id`) REFERENCES `team`(`id`),
    FOREIGN KEY (`away_team_id`) REFERENCES `team`(`id`),
    FOREIGN KEY (`referee_id`) REFERENCES `referee`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛主表，记录每场比赛基础信息';

CREATE TABLE `match_event` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '事件ID，主键',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `event_time` INT NOT NULL COMMENT '事件发生时间（第几分钟）',
    `team_id` BIGINT COMMENT '涉及球队ID，外键，关联team表',
    `player_id` BIGINT COMMENT '涉及球员ID，外键，关联player表',
    `event_type` VARCHAR(32) NOT NULL COMMENT '事件类型，如进球、乌龙、点球、红牌、黄牌、换人',
    `event_subtype` VARCHAR(32) COMMENT '事件子类型，如乌龙、点球进球',
    `event_icon` VARCHAR(128) COMMENT '事件图标URL',
    `description` VARCHAR(256) COMMENT '事件描述',
    `push_status` TINYINT DEFAULT 0 COMMENT '推送状态，0未推送，1已推送',
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛事件表，记录进球、红黄牌等重要事件';

CREATE TABLE `match_score` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '比分记录ID，主键',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `home_score` INT NOT NULL DEFAULT 0 COMMENT '主队进球数',
    `away_score` INT NOT NULL DEFAULT 0 COMMENT '客队进球数',
    `half_home_score` INT DEFAULT NULL COMMENT '半场主队进球数',
    `half_away_score` INT DEFAULT NULL COMMENT '半场客队进球数',
    `current_minute` INT DEFAULT 0 COMMENT '当前比赛进行到第几分钟',
    `extra_minute` INT DEFAULT 0 COMMENT '补时时间，分钟',
    `match_period` VARCHAR(16) COMMENT '当前比赛阶段period，如上半场/下半场/加时/点球',
    `status` VARCHAR(16) NOT NULL COMMENT '比分状态，如正常、加时、点球',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    UNIQUE KEY `uniq_match` (`match_id`),
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛实时比分表';

CREATE TABLE `match_statistics` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '技术统计ID，主键',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `stat_type` VARCHAR(32) NOT NULL COMMENT '统计类型，如shots=射门，possession=控球率等',
    `stat_value` VARCHAR(32) NOT NULL COMMENT '统计值',
    `period` VARCHAR(16) COMMENT '统计阶段，如全场/半场/加时',
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛技术统计表，支持多类型统计';

CREATE TABLE `team_h2h_summary` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '球队历史对阵统计ID，主键',
    `team_a_id` BIGINT NOT NULL COMMENT '球队A，外键，关联team表',
    `team_b_id` BIGINT NOT NULL COMMENT '球队B，外键，关联team表',
    `match_count` INT DEFAULT 0 COMMENT '历史交锋场次',
    `team_a_win` INT DEFAULT 0 COMMENT 'A胜场数',
    `team_b_win` INT DEFAULT 0 COMMENT 'B胜场数',
    `draw` INT DEFAULT 0 COMMENT '平局数',
    `team_a_goals` INT DEFAULT 0 COMMENT 'A进球数',
    `team_b_goals` INT DEFAULT 0 COMMENT 'B进球数',
    `last_match_id` BIGINT COMMENT '最近一次交锋的比赛ID，外键，关联`match`表',
    `last_match_time` DATETIME COMMENT '最近一次交锋时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队历史对阵统计表';

CREATE TABLE `team_goal_stats` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '入球统计ID，主键',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `match_type` VARCHAR(16) NOT NULL COMMENT '场次类型 all=总，home=主场，away=客场',
    `first_half_goals` INT DEFAULT 0 COMMENT '上半场总进球数',
    `second_half_goals` INT DEFAULT 0 COMMENT '下半场总进球数',
    `more_first_half` INT DEFAULT 0 COMMENT '上半场进球多场次',
    `equal_halves` INT DEFAULT 0 COMMENT '上下半场进球相同场次',
    `more_second_half` INT DEFAULT 0 COMMENT '下半场进球多场次',
    `matches` INT DEFAULT 0 COMMENT '统计的场次数',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队入球数与上下半场分布统计';

CREATE TABLE `team_goal_time_stats` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '入球时间统计ID，主键',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `time_span` VARCHAR(16) NOT NULL COMMENT '时间区间，如1-5,6-10,11-15等',
    `goal_count` INT DEFAULT 0 COMMENT '该时间段进球次数',
    `match_type` VARCHAR(16) NOT NULL COMMENT '场次类型 all=总，home=主场，away=客场',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队分时间段入球统计';

CREATE TABLE `team_win_draw_loss_stats` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '胜平负分布ID，主键',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `match_type` VARCHAR(16) NOT NULL COMMENT '场次类型 all=总，home=主场，away=客场',
    `half_win` INT DEFAULT 0 COMMENT '半场胜场数',
    `half_draw` INT DEFAULT 0 COMMENT '半场平局数',
    `half_lose` INT DEFAULT 0 COMMENT '半场负场数',
    `full_win` INT DEFAULT 0 COMMENT '全场胜场数',
    `full_draw` INT DEFAULT 0 COMMENT '全场平局数',
    `full_lose` INT DEFAULT 0 COMMENT '全场负场数',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队半场/全场胜平负主客分布统计';

-- ========== 4. 用户、关注、个性化推送及日志 ==========

CREATE TABLE `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID，主键',
    `username` VARCHAR(64) NOT NULL UNIQUE COMMENT '用户名，唯一',
    `password` VARCHAR(128) NOT NULL COMMENT '加密存储的用户密码',
    `nickname` VARCHAR(64) COMMENT '用户昵称',
    `register_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

CREATE TABLE `user_league_favorite` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关注ID，主键',
    `user_id` BIGINT NOT NULL COMMENT '用户ID，外键，关联user表',
    `league_id` BIGINT NOT NULL COMMENT '联赛ID，外键，关联league表',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
    UNIQUE KEY `uniq_user_league` (`user_id`, `league_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
    FOREIGN KEY (`league_id`) REFERENCES `league`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关注联赛表';

CREATE TABLE `user_team_favorite` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关注ID，主键',
    `user_id` BIGINT NOT NULL COMMENT '用户ID，外键，关联user表',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '关注时间',
    UNIQUE KEY `uniq_user_team` (`user_id`, `team_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关注球队表';

CREATE TABLE `user_setting` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    `user_id` BIGINT NOT NULL COMMENT '用户ID，外键，关联user表',
    `setting_group` VARCHAR(32) NOT NULL COMMENT '设置分组，如ui（界面）、query（查询）、push（推送）、privacy（隐私）、business（商业）',
    `setting_key` VARCHAR(64) NOT NULL COMMENT '具体设置项，如theme、default_league、push_goal等',
    `setting_value` VARCHAR(1024) NOT NULL COMMENT '设置值，可为字符串、json等',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    UNIQUE KEY `uniq_user_setting` (`user_id`, `setting_group`, `setting_key`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户个性化设置表，支持多维分类';

CREATE TABLE `user_push_log` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '推送日志ID，主键',
    `user_id` BIGINT COMMENT '用户ID，外键，关联user表',
    `match_id` BIGINT COMMENT '比赛ID，外键，关联`match`表',
    `push_type` VARCHAR(32) COMMENT '推送类型，如比分、事件、盘口变动',
    `content` TEXT COMMENT '推送内容',
    `push_time` DATETIME COMMENT '推送时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户推送日志表';

-- ========== 5. 博彩公司、盘口类型、盘口玩法及盘口数据表 ==========

CREATE TABLE `bookmaker` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '博彩公司ID，主键',
    `name` VARCHAR(64) NOT NULL COMMENT '博彩公司全称',
    `short_name` VARCHAR(32) COMMENT '博彩公司简称',
    `code` VARCHAR(16) COMMENT '公司简码，用于接口或爬虫映射',
    `logo_url` VARCHAR(256) COMMENT '公司Logo',
    `is_active` TINYINT DEFAULT 1 COMMENT '是否启用，1-启用 0-停用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='博彩公司信息表';

CREATE TABLE `odds_type` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '盘口类型ID，主键',
    `code` VARCHAR(16) NOT NULL COMMENT '类型代码，如1/2/4',
    `name` VARCHAR(64) NOT NULL COMMENT '盘口类型名称，如全让球、全总进球、全胜平负',
    `description` VARCHAR(256) COMMENT '类型描述',
    `is_active` TINYINT DEFAULT 1 COMMENT '是否启用，1-启用 0-停用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='盘口类型表';

CREATE TABLE `odds_play` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '盘口玩法ID，主键',
    `code` VARCHAR(16) NOT NULL COMMENT '玩法代码',
    `name` VARCHAR(64) NOT NULL COMMENT '玩法名称，如全场、上半场、下半场',
    `description` VARCHAR(256) COMMENT '玩法描述',
    `is_active` TINYINT DEFAULT 1 COMMENT '是否启用，1-启用 0-停用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='盘口玩法表';

CREATE TABLE `match_odds` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '盘口数据ID，主键',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `bookmaker_id` INT NOT NULL COMMENT '博彩公司ID，外键，关联bookmaker表',
    `odds_type_id` INT NOT NULL COMMENT '盘口类型ID，外键，关联odds_type表',
    `odds_play_id` INT DEFAULT NULL COMMENT '盘口玩法ID，外键，关联odds_play表，可为空',
    `home_odds` DECIMAL(8,3) COMMENT '主队赔率/盘口',
    `draw_odds` DECIMAL(8,3) COMMENT '平局赔率',
    `away_odds` DECIMAL(8,3) COMMENT '客队赔率/盘口',
    `handicap` VARCHAR(16) COMMENT '让球/盘口数值',
    `odds_status` VARCHAR(16) COMMENT '盘口状态，如初盘、即盘、终盘',
    `odds_source` VARCHAR(64) COMMENT '数据源',
    `is_mainline` TINYINT DEFAULT 1 COMMENT '是否主盘口，1-主盘口',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    `fetch_time` DATETIME COMMENT '采集（抓取）时间',
    INDEX `idx_match_bookmaker_type_play` (`match_id`, `bookmaker_id`, `odds_type_id`, `odds_play_id`),
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`),
    FOREIGN KEY (`bookmaker_id`) REFERENCES `bookmaker`(`id`),
    FOREIGN KEY (`odds_type_id`) REFERENCES `odds_type`(`id`),
    FOREIGN KEY (`odds_play_id`) REFERENCES `odds_play`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛盘口数据主表';

CREATE TABLE `match_odds_history` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '盘口历史ID，主键',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `bookmaker_id` INT NOT NULL COMMENT '博彩公司ID，外键，关联bookmaker表',
    `odds_type_id` INT NOT NULL COMMENT '盘口类型ID，外键，关联odds_type表',
    `odds_play_id` INT DEFAULT NULL COMMENT '盘口玩法ID，外键，关联odds_play表',
    `home_odds` DECIMAL(8,3) COMMENT '主队赔率/盘口',
    `draw_odds` DECIMAL(8,3) COMMENT '平局赔率',
    `away_odds` DECIMAL(8,3) COMMENT '客队赔率/盘口',
    `handicap` VARCHAR(16) COMMENT '让球/盘口数值',
    `odds_status` VARCHAR(16) COMMENT '盘口状态，如初盘、即盘、终盘',
    `odds_source` VARCHAR(64) COMMENT '数据源',
    `is_mainline` TINYINT DEFAULT 1 COMMENT '是否主盘口，1-主盘口',
    `change_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '盘口变动时间',
    `fetch_time` DATETIME COMMENT '采集（抓取）时间',
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`),
    FOREIGN KEY (`bookmaker_id`) REFERENCES `bookmaker`(`id`),
    FOREIGN KEY (`odds_type_id`) REFERENCES `odds_type`(`id`),
    FOREIGN KEY (`odds_play_id`) REFERENCES `odds_play`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='比赛盘口历史数据表';

-- ========== 6. 榜单、盘口榜单、赛果、球队赛果 ==========

CREATE TABLE `standings` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '榜单ID，主键',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `stage_id` INT COMMENT '阶段ID，外键，关联match_stage表，可为空',
    `round_id` INT COMMENT '轮次ID，外键，关联match_round表，可为空',
    `type` VARCHAR(32) NOT NULL COMMENT '榜单类型，如total, home, away, half_total, half_home, half_away',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `ranking` INT NOT NULL COMMENT '当前排名',
    `played` INT DEFAULT 0 COMMENT '已赛场次',
    `win` INT DEFAULT 0 COMMENT '胜场数',
    `draw` INT DEFAULT 0 COMMENT '平局数',
    `lose` INT DEFAULT 0 COMMENT '负场数',
    `goals_for` INT DEFAULT 0 COMMENT '进球数',
    `goals_against` INT DEFAULT 0 COMMENT '失球数',
    `goal_diff` INT DEFAULT 0 COMMENT '净胜球数',
    `win_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '胜率，百分比',
    `draw_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '平率，百分比',
    `lose_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '负率，百分比',
    `avg_goals_for` DECIMAL(5,2) DEFAULT 0 COMMENT '场均进球',
    `avg_goals_against` DECIMAL(5,2) DEFAULT 0 COMMENT '场均失球',
    `points` INT DEFAULT 0 COMMENT '总积分',
    `last_6_results` VARCHAR(32) COMMENT '最近六轮赛果，如WWDLWL',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队积分榜表，支持多类型榜单';

CREATE TABLE `standings_asian_handicap` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '亚盘榜单ID，主键',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `type` VARCHAR(32) NOT NULL COMMENT '榜单类型，如total, home, away, half_total, half_home, half_away',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `ranking` INT NOT NULL COMMENT '当前排名',
    `played` INT DEFAULT 0 COMMENT '已赛场次',
    `win` INT DEFAULT 0 COMMENT '赢盘（上盘）次数',
    `push` INT DEFAULT 0 COMMENT '走盘次数',
    `lose` INT DEFAULT 0 COMMENT '输盘（下盘）次数',
    `win_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '赢盘率（%）',
    `push_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '走盘率（%）',
    `lose_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '输盘率（%）',
    `trend` VARCHAR(32) COMMENT '近期盘口走势，如WWDLWL',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队亚盘榜单，含赢盘率、走盘率、输盘率等统计';

CREATE TABLE `standings_over_under` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '大小球榜ID，主键',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `type` VARCHAR(32) NOT NULL COMMENT '榜单类型，如total, home, away, half_total, half_home, half_away',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `ranking` INT NOT NULL COMMENT '当前排名',
    `played` INT DEFAULT 0 COMMENT '已赛场次',
    `over` INT DEFAULT 0 COMMENT '大球次数',
    `push` INT DEFAULT 0 COMMENT '走盘次数',
    `under` INT DEFAULT 0 COMMENT '小球次数',
    `over_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '大球率，百分比',
    `push_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '走盘率，百分比',
    `under_rate` DECIMAL(5,2) DEFAULT 0 COMMENT '小球率，百分比',
    `trend` VARCHAR(32) COMMENT '近期盘路趋势',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队大小球榜单表';

CREATE TABLE `team_recent_results` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '球队最近N场赛果ID，主键',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `result` VARCHAR(4) NOT NULL COMMENT '赛果，W=胜 D=平 L=负',
    `is_home` TINYINT DEFAULT 0 COMMENT '是否主场，1-主场，0-客场',
    `match_time` DATETIME COMMENT '比赛时间',
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`),
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队最近N场赛果明细表';

CREATE TABLE `team_handicap_results` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '球队盘口赛果ID，主键',
    `team_id` BIGINT NOT NULL COMMENT '球队ID，外键，关联team表',
    `season_id` INT NOT NULL COMMENT '赛季ID，外键，关联season表',
    `match_id` BIGINT NOT NULL COMMENT '比赛ID，外键，关联`match`表',
    `handicap_type` VARCHAR(16) NOT NULL COMMENT '盘口类型，asian=亚盘，overunder=大小球',
    `result` VARCHAR(4) NOT NULL COMMENT '盘口赛果，W=赢盘 P=走盘 L=输盘',
    `is_home` TINYINT DEFAULT 0 COMMENT '是否主场，1-主场，0-客场',
    `match_time` DATETIME COMMENT '比赛时间',
    FOREIGN KEY (`team_id`) REFERENCES `team`(`id`),
    FOREIGN KEY (`season_id`) REFERENCES `season`(`id`),
    FOREIGN KEY (`match_id`) REFERENCES `match`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='球队盘口赛果明细表，支持亚盘和大小球';

-- ========== 7. 多媒体、数据溯源 ==========

CREATE TABLE `media_resource` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '资源ID，主键',
    `related_type` VARCHAR(32) NOT NULL COMMENT '关联类型，match=比赛、team=球队、player=球员等',
    `related_id` BIGINT NOT NULL COMMENT '关联实体ID',
    `media_type` VARCHAR(16) NOT NULL COMMENT '资源类型，image=图片、video=视频、news=新闻等',
    `url` VARCHAR(512) NOT NULL COMMENT '资源URL',
    `description` VARCHAR(256) COMMENT '资源描述',
    `publish_time` DATETIME COMMENT '发布时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='多媒体资源表，支持图片、视频、新闻等';

CREATE TABLE `data_source_log` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '抓取日志ID，主键',
    `source_name` VARCHAR(64) NOT NULL COMMENT '数据源名称，如球探、雷速',
    `data_type` VARCHAR(32) NOT NULL COMMENT '数据类型，如赛事、盘口、积分榜',
    `fetch_time` DATETIME NOT NULL COMMENT '抓取时间',
    `status` VARCHAR(16) NOT NULL COMMENT '抓取状态，如成功、失败',
    `record_count` INT DEFAULT 0 COMMENT '抓取数据条数',
    `error_message` VARCHAR(512) COMMENT '错误信息',
    `raw_data` TEXT COMMENT '原始返回数据',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '日志记录时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据抓取/同步日志表';
