USE `isupipe`;

DROP TABLE IF EXISTS `users`;
-- ユーザ (配信者、視聴者)
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `display_name` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  UNIQUE `uniq_user_name` (`name`),
  INDEX `i_users_1` (`name`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `icons`;
-- プロフィール画像
CREATE TABLE `icons` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `image` LONGBLOB NOT NULL,
  INDEX `i_icons_1` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `themes`;
-- ユーザごとのカスタムテーマ
CREATE TABLE `themes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `dark_mode` BOOLEAN NOT NULL,
  INDEX `i_themes_1` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `livestreams`;
-- ライブ配信
CREATE TABLE `livestreams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` text NOT NULL,
  `playlist_url` VARCHAR(255) NOT NULL,
  `thumbnail_url` VARCHAR(255) NOT NULL,
  `start_at` BIGINT NOT NULL,
  `end_at` BIGINT NOT NULL,
  INDEX `i_livestreams_1` (`user_id`),
  INDEX `i_livestreams_2` (`start_at`),
  INDEX `i_livestreams_3` (`end_at`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `reservation_slots`;
-- ライブ配信予約枠
CREATE TABLE `reservation_slots` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `slot` BIGINT NOT NULL,
  `start_at` BIGINT NOT NULL,
  `end_at` BIGINT NOT NULL,
  INDEX `i_reservation_slots_1` (`slot`),
  INDEX `i_reservation_slots_2` (`start_at`),
  INDEX `i_reservation_slots_3` (`end_at`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `tags`;
-- ライブストリームに付与される、サービスで定義されたタグ
CREATE TABLE `tags` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  UNIQUE `uniq_tag_name` (`name`),
  INDEX `i_tags_1` (`name`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `livestream_tags`;
-- ライブ配信とタグの中間テーブル
CREATE TABLE `livestream_tags` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `livestream_id` BIGINT NOT NULL,
  `tag_id` BIGINT NOT NULL,
  INDEX `i_livestream_tags_1` (`livestream_id`),
  INDEX `i_livestream_tags_2` (`tag_id`, `livestream_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `livestream_viewers_history`;
-- ライブ配信視聴履歴
CREATE TABLE `livestream_viewers_history` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `created_at` BIGINT NOT NULL,
  INDEX `i_livestream_viewers_history_1` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `livecomments`;
-- ライブ配信に対するライブコメント
CREATE TABLE `livecomments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `comment` VARCHAR(255) NOT NULL,
  `tip` BIGINT NOT NULL DEFAULT 0,
  `created_at` BIGINT NOT NULL,
  INDEX `i_livecomments_1` (`user_id`),
  INDEX `i_livecomments_2` (`livestream_id`, `tip`),
  INDEX `i_livecomments_3` (`created_at` DESC)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `livecomment_reports`;
-- ユーザからのライブコメントのスパム報告
CREATE TABLE `livecomment_reports` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `livecomment_id` BIGINT NOT NULL,
  `created_at` BIGINT NOT NULL,
  INDEX `i_livecomment_reports_1` (`user_id`),
  INDEX `i_livecomment_reports_2` (`livestream_id`),
  INDEX `i_livecomment_reports_3` (`livecomment_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

DROP TABLE IF EXISTS `ng_words`;
-- 配信者からのNGワード登録
CREATE TABLE `ng_words` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `word` VARCHAR(255) NOT NULL,
  `created_at` BIGINT NOT NULL,
  INDEX `i_ng_words_1` (`user_id`),
  INDEX `i_ng_words_2` (`livestream_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE INDEX ng_words_word ON ng_words(`word`);

DROP TABLE IF EXISTS `reactions`;
-- ライブ配信に対するリアクション
CREATE TABLE `reactions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  -- :innocent:, :tada:, etc...
  `emoji_name` VARCHAR(255) NOT NULL,
  `created_at` BIGINT NOT NULL,
  INDEX `i_reactions_1` (`user_id`),
  INDEX `i_reactions_2` (`livestream_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;