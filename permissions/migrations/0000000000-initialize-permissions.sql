CREATE DATABASE `YourUtilituClosetDatabaseName` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_bin';

USE `YourUtilityClosetDatabaseName`;

-- Authorization and Authentication --

-- USE UUID() for user_id. Most ORMs still choke on `DEFAULT UUID()`
CREATE TABLE `Users` (
    `user_id` CHAR(40) PRIMARY KEY NOT NULL,
    `name` VARCHAR(1024),
    `username` VARCHAR(512) NOT NULL UNIQUE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT="Associates a login name with an internal unique identifier.";


CREATE TABLE `UserGroups` (
    `user_group_id` CHAR(40) PRIMARY KEY NOT NULL,
    `group_name` VARCHAR(256),
    `description` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT="Master records for user groups that can associate multiple users with and individual permission or set of permissions.";


CREATE TABLE `UserGroupMemberships` (
    `user_id` CHAR(40),
    `user_group_id` CHAR(40),
    `access_granted` DATETIME NOT NULL,
    `access_expiry` DATETIME NOT NULL,
    `has_access` BOOLEAN NOT NULL DEFAULT 0,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`, `user_group_id`),
    CONSTRAINT `FK1_user`
        FOREIGN KEY (`user_id`)
        REFERENCES `Users`(`user_id`),
    CONSTRAINT `FK1_user_group`
        FOREIGN KEY (`user_group_id`)
        REFERENCES `UserGroups`(`user_group_id`)
) COMMENT="An entity that allows multiple groups to have multiple users and users to have multiple groups.";



CREATE TABLE `Permissions` (
    `permission_id` CHAR(40) PRIMARY KEY NOT NULL,
    `permission_token` VARCHAR(256) NOT NULL,
    `permission_title` VARCHAR(256) NOT NULL,
    `notes` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT="A permission is a token (e.g. a string) that can be used programmatically to limit or constrain an application's behavior based on a user's association or non-association.";


CREATE TABLE `PermissionSets` (
    `permission_set_id` CHAR(40) PRIMARY KEY NOT NULL,
    `permission_set_token` VARCHAR(256) NOT NULL,
    `title` VARCHAR(256) NOT NULL,
    `notes` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT="A permission set is a group of related permissions. This table provides a master record for each permision set.";


CREATE TABLE `PermissionSetPermissions` (
    `permission_set_id` CHAR(40) NOT NULL,
    `permission_id` CHAR(40) NOT NULL,
    `notes` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,  PRIMARY KEY (`permission_set_id`, `permission_id`),
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `FK1_permission`
    FOREIGN KEY (`permission_id`) REFERENCES `Permissions`(`permission_id`),
  CONSTRAINT `FK3_permission_set`
    FOREIGN KEY (`permission_set_id`) REFERENCES `PermissionSets`(`permission_set_id`)
) COMMENT="Associates individual permissions with permission sets.";


CREATE TABLE `PermissionSetMembers` (
    `permission_set_id` CHAR(40) NOT NULL,
    `user_id` CHAR(40) NOT NULL,
    `access_granted` DATETIME NOT NULL,
    `access_expiry` DATETIME NOT NULL,
    `has_access` BOOLEAN NOT NULL DEFAULT 0,
    `notes` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`permission_set_id`, `user_id`),
        CONSTRAINT `FK2_user`
        FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`),
    CONSTRAINT `FK1_permission_set`
        FOREIGN KEY (`permission_set_id`) REFERENCES `PermissionSets`(`permission_set_id`)
) COMMENT="Associates individual users with permission sets.";


CREATE TABLE `PermissionSetGroupMembers` (
    `user_group_id` CHAR(40) NOT NULL,
    `permission_set_id` CHAR(40) NOT NULL,
    `access_granted` DATETIME NOT NULL,
    `access_expiry` DATETIME NOT NULL,
    `has_access` BOOLEAN NOT NULL DEFAULT 0,
    `notes` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_group_id`, `permission_set_id`),
    CONSTRAINT `FK2_user_group`
        FOREIGN KEY (`user_group_id`) REFERENCES `UserGroups` (`user_group_id`),
    CONSTRAINT `FK2_permission_set`
        FOREIGN KEY (`permission_set_id`) REFERENCES `PermissionSets` (`permission_set_id`)
) COMMENT="Associates user groups with permission sets.";

