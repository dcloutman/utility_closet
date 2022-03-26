CREATE TABLE `users` (
  `user_id` binary(16) PRIMARY KEY DEFAULT (uuid()),
  `created_at` timestamp
);

CREATE TABLE `user_groups` (
  `user_group_id` unsigned bigint PRIMARY KEY AUTO_INCREMENT,
  `group_name` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `group_members` (
  `user_id` binary(16),
  `user_group_id` int,
  `username` varchar(255),
  `created_at` timestamp,
  PRIMARY KEY (`user_id`, `user_group_id`)
);

CREATE TABLE `permissions` (
  `permission_id` unsigned int PRIMARY KEY AUTO_INCREMENT,
  `permission_token` varchar(255),
  `title` varchar(255),
  `notes` text
);

CREATE TABLE `permission_set_members` (
  `permission_set_id` unsigned int,
  `permission_id` unsigned int,
  `permission_token` varchar(255),
  `title` varchar(255),
  `notes` text,
  PRIMARY KEY (`permission_set_id`, `permission_id`)
);

CREATE TABLE `permission_grants` (
  `user_group_id` unsigned int,
  `permission_set_id` unsigned int,
  PRIMARY KEY (`user_group_id`, `permission_set_id`)
);

CREATE TABLE `permissions_sets` (
  `permission_set_id` unsigned int PRIMARY KEY,
  `name` varchar(255),
  `notes` text
);

ALTER TABLE `users` ADD FOREIGN KEY (`user_id`) REFERENCES `group_members` (`user_id`);

ALTER TABLE `user_groups` ADD FOREIGN KEY (`user_group_id`) REFERENCES `group_members` (`user_group_id`);

ALTER TABLE `permission_set_members` ADD FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`);

ALTER TABLE `permission_set_members` ADD FOREIGN KEY (`permission_set_id`) REFERENCES `permissions_sets` (`permission_set_id`);

ALTER TABLE `permission_grants` ADD FOREIGN KEY (`user_group_id`) REFERENCES `user_groups` (`user_group_id`);

ALTER TABLE `permission_grants` ADD FOREIGN KEY (`permission_set_id`) REFERENCES `permissions_sets` (`permission_set_id`);

