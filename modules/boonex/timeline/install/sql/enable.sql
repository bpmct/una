-- PAGES & BLOCKS
INSERT INTO `sys_objects_page`(`object`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `uri`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_timeline_view', '_bx_timeline_page_title_sys_view', '_bx_timeline_page_title_view', 'bx_timeline', 5, 2147483647, 1, 'view', 'page.php?i=view', '', '', '', 0, 1, 0, '', '');

INSERT INTO `sys_pages_blocks` (`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES
('bx_timeline_view', 1, 'bx_timeline', '_bx_timeline_page_block_title_post', 11, 2147483647, 'service', 'a:2:{s:6:"module";s:11:"bx_timeline";s:6:"method";s:14:"get_block_post";}', 0, 0, 1),
('bx_timeline_view', 1, 'bx_timeline', '_bx_timeline_page_block_title_view', 11, 2147483647, 'service', 'a:2:{s:6:"module";s:11:"bx_timeline";s:6:"method";s:14:"get_block_view";}', 0, 1, 1);

SET @iPBCellProfile = 1;
SET @iPBOrderProfile = (SELECT MAX(`order`) FROM `sys_pages_blocks` WHERE `object`='bx_persons_view_profile' AND `cell_id` = @iPBCellProfile LIMIT 1);
INSERT INTO `sys_pages_blocks` (`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES
('bx_persons_view_profile', @iPBCellProfile, 'bx_timeline', '_bx_timeline_page_block_title_post_profile', 11, 2147483647, 'service', 'a:2:{s:6:"module";s:11:"bx_timeline";s:6:"method";s:22:"get_block_post_profile";}', 0, 0, @iPBOrderProfile + 1),
('bx_persons_view_profile', @iPBCellProfile, 'bx_timeline', '_bx_timeline_page_block_title_view_profile', 11, 2147483647, 'service', 'a:2:{s:6:"module";s:11:"bx_timeline";s:6:"method";s:22:"get_block_view_profile";}', 0, 1, @iPBOrderProfile + 2);


-- SETTINGS
SET @iTypeOrder = (SELECT MAX(`order`) FROM `sys_options_types` WHERE `group` = 'modules');
INSERT INTO `sys_options_types`(`group`, `name`, `caption`, `icon`, `order`) VALUES 
('modules', 'bx_timeline', '_bx_timeline', 'bx_timeline@modules/boonex/timeline/|std-mi.png', IF(ISNULL(@iTypeOrder), 1, @iTypeOrder + 1));
SET @iTypeId = LAST_INSERT_ID();

INSERT INTO `sys_options_categories` (`type_id`, `name`, `caption`, `order`)
VALUES (@iTypeId, 'bx_timeline', '_bx_timeline', 1);
SET @iCategId = LAST_INSERT_ID();

INSERT INTO `sys_options` (`name`, `value`, `category_id`, `caption`, `type`, `check`, `check_error`, `extra`, `order`) VALUES
('bx_timeline_enable_guest_comments', '', @iCategId, 'Allow non-members to post in Timeline', 'checkbox', '', '', '', 1),
('bx_timeline_enable_delete', 'on', @iCategId, 'Allow Timeline owner to remove events', 'checkbox', '', '', '', 2),
('bx_timeline_events_per_page_profile', '10', @iCategId, 'Number of events are displayed on Profile page', 'digit', '', '', '', 3),
('bx_timeline_events_per_page_account', '20', @iCategId, 'Number of events are displayed on Account page', 'digit', '', '', '', 4),
('bx_timeline_rss_length', '5', @iCategId, 'The length of RSS feed', 'digit', '', '', '', 5),
('bx_timeline_events_hide', '', @iCategId, 'Hide events from Timeline', 'list', '', '', 'PHP:return BxDolService::call(\'bx_timeline\', \'get_actions_checklist\');', 6);


-- ACL
INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_timeline', 'post', NULL, '_bx_timeline_acl_action_post', '', 1, 1);
SET @iIdActionPostComment = LAST_INSERT_ID();

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_timeline', 'delete', NULL, '_bx_timeline_acl_action_delete', '', 1, 1);
SET @iIdActionDeleteComment = LAST_INSERT_ID();

SET @iUnauthenticated = 1;
SET @iStandard = 2;
SET @iUnconfirmed = 3;
SET @iPending = 4;
SET @iSuspended = 5;
SET @iModerator = 6;
SET @iAdministrator = 7;
SET @iPremium = 8;

INSERT INTO `sys_acl_matrix` (`IDLevel`, `IDAction`) VALUES

-- post comment
(@iStandard, @iIdActionPostComment),
(@iModerator, @iIdActionPostComment),
(@iAdministrator, @iIdActionPostComment),
(@iPremium, @iIdActionPostComment),

-- delete comment
(@iModerator, @iIdActionDeleteComment),
(@iAdministrator, @iIdActionDeleteComment);


-- ALERTS
INSERT INTO `sys_alerts_handlers`(`name`, `class`, `file`, `eval`) VALUES 
('bx_timeline', '', '', 'BxDolService::call(\'bx_timeline\', \'response\', array($this));');


-- COMMENTS
INSERT INTO `sys_objects_cmts` (`Name`, `TableCmts`, `TableTrack`, `CharsPostMin`, `CharsPostMax`, `CharsDisplayMax`, `Nl2br`, `PerView`, `PerViewReplies`, `BrowseType`, `IsBrowseSwitch`, `PostFormPosition`, `NumberOfLevels`, `IsDisplaySwitch`, `IsRatable`, `ViewingThreshold`, `IsOn`, `RootStylePrefix`, `BaseUrl`, `TriggerTable`, `TriggerFieldId`, `TriggerFieldTitle`, `TriggerFieldComments`, `ClassName`, `ClassFile`) VALUES
('bx_timeline', 'bx_timeline_comments', 'bx_timeline_comments_track', 1, 5000, 1000, 1, 5, 3, 'tail', 1, 'bottom', 1, 1, 1, -3, 1, 'cmt', '', '', '', '', '', 'BxTimelineCmts', 'modules/boonex/timeline/classes/BxTimelineCmts.php');
