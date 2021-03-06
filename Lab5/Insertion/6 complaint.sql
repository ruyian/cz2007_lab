

SET IDENTITY_INSERT [dbo].[complaint] ON 

INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (1, N'Horrible Service.', N'Resolved', CAST(N'2021-08-03T00:00:00.000' AS DateTime), 4, 1, CAST(N'2021-09-04T22:22:00.000' AS DateTime), CAST(N'2021-09-03T22:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (2, N'Horrible packaging by the shop.', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 13, 1, CAST(N'2021-09-03T20:00:00.000' AS DateTime), CAST(N'2021-09-01T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (3, N'Terrible replying timings.', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 27, 2, CAST(N'2021-09-03T00:24:00.000' AS DateTime), CAST(N'2021-09-01T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (4, N'Rude', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 87, 2, CAST(N'2021-09-20T22:22:00.000' AS DateTime), CAST(N'2021-09-20T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (5, N'Broken Product', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 69, 3, CAST(N'2021-09-01T15:30:00.000' AS DateTime),CAST(N'2021-09-01T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (6, N'Product looks nothing like in pictures.', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 73, 3, CAST(N'2021-09-04T22:00:00.000' AS DateTime), CAST(N'2021-09-01T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (7, N'Wrong colour', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 4, 4, CAST(N'2021-08-25T10:00:00.000' AS DateTime),CAST(N'2021-08-20T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (8, N'Delivery was SO slow.', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 20, 4, CAST(N'2021-09-01T11:20:00.000' AS DateTime),CAST(N'2021-09-01T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (9, N'Horrible Service.', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 19, 1, CAST(N'2021-09-02T10:10:00.000' AS DateTime),CAST(N'2021-09-01T00:00:00.000' AS DateTime))
INSERT [dbo].[complaint] ([complaint_id], [complain_description], [complaint_status], [file_timestamp], [user_id], [employee_id], [resolved_timestamp], [assigned_timestamp]) 
    VALUES (10, N'D:<', N'Resolved', CAST(N'2021-08-01T00:00:00.000' AS DateTime), 87, 2, CAST(N'2021-08-22T00:00:00.000' AS DateTime),CAST(N'2021-08-20T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[complaint] OFF
