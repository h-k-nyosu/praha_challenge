-- users
INSERT INTO users (id, slack_member_id) VALUES
('bf948a6f-a8f0-fc9d-cc5a-975950359661' ,'U1234A567B'),
('fa5c7639-ce06-6dc2-a662-072b87181e45' ,'U2345B678C'),
('015b1aae-1ad6-54f4-5a88-7f7d85bc298f' ,'U3456C789D'),
('31b5d740-5fb0-f072-2cd8-a3edcd1301a7' ,'U4567D890E'),
('5672016b-d8b1-1dc1-35c6-a7fa53e8da40' ,'U5678E901F');

-- task_statuses
INSERT INTO task_statuses (id, status) VALUES (1, '未対応');
INSERT INTO task_statuses (id, status) VALUES (2, '完了');


-- tasks
INSERT INTO tasks (id, content, created_by, remind_time, remind_interval, status_id) 
VALUES
('7749f499-d4ca-4d03-9da1-8e7a8242ee6d' ,'Finish the report', 'bf948a6f-a8f0-fc9d-cc5a-975950359661', '2023-02-01 11:00:00', '1 hour', 1),
('4dfde1dc-e4fd-4857-92fc-03ee58d4e067' ,'Submit expense form', 'fa5c7639-ce06-6dc2-a662-072b87181e45', '2023-02-02 12:00:00', '2 hours', 1),
('3a836581-99b7-4301-9b01-c06012be6a8c' ,'Attend virtual meeting', '015b1aae-1ad6-54f4-5a88-7f7d85bc298f', '2023-02-03 14:00:00', '3 hours', 1),
('095d2e28-d8cf-4ae9-9b7a-d44fe991bfc7' ,'Buy groceries', '31b5d740-5fb0-f072-2cd8-a3edcd1301a7', '2023-02-04 16:00:00', '4 hours', 1),
('753c4211-ece0-42dc-a6fd-395bfd04ad82' ,'Call John', '5672016b-d8b1-1dc1-35c6-a7fa53e8da40', '2023-02-05 18:00:00', '5 hours', 1);

-- reminder_recipients
INSERT INTO reminder_recipients (user_id, task_id) 
VALUES ('bf948a6f-a8f0-fc9d-cc5a-975950359661', '7749f499-d4ca-4d03-9da1-8e7a8242ee6d'), 
       ('fa5c7639-ce06-6dc2-a662-072b87181e45', '4dfde1dc-e4fd-4857-92fc-03ee58d4e067'), 
       ('015b1aae-1ad6-54f4-5a88-7f7d85bc298f', '3a836581-99b7-4301-9b01-c06012be6a8c'), 
       ('31b5d740-5fb0-f072-2cd8-a3edcd1301a7', '095d2e28-d8cf-4ae9-9b7a-d44fe991bfc7'), 
       ('5672016b-d8b1-1dc1-35c6-a7fa53e8da40', '753c4211-ece0-42dc-a6fd-395bfd04ad82'), 
       ('bf948a6f-a8f0-fc9d-cc5a-975950359661', '4dfde1dc-e4fd-4857-92fc-03ee58d4e067'), 
       ('fa5c7639-ce06-6dc2-a662-072b87181e45', '3a836581-99b7-4301-9b01-c06012be6a8c'), 
       ('015b1aae-1ad6-54f4-5a88-7f7d85bc298f', '095d2e28-d8cf-4ae9-9b7a-d44fe991bfc7'), 
       ('31b5d740-5fb0-f072-2cd8-a3edcd1301a7', '753c4211-ece0-42dc-a6fd-395bfd04ad82'), 
       ('5672016b-d8b1-1dc1-35c6-a7fa53e8da40', '7749f499-d4ca-4d03-9da1-8e7a8242ee6d');


