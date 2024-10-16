SET NOCOUNT ON;

CREATE TABLE [pubs].[employee]
(
	[emp_id] [pubs].[empid] NOT NULL,
	[fname] [varchar](20) NOT NULL,
	[minit] [char](1) NULL,
	[lname] [varchar](30) NOT NULL,
	[job_id] [smallint] NOT NULL,
	[job_lvl] [tinyint] NULL,
	[pub_id] [char](4) NOT NULL,
	[hire_date] [datetime] NOT NULL
)
GO
CREATE CLUSTERED INDEX [employee_ind] ON [pubs].[employee]
(
	[lname] ASC,
	[fname] ASC,
	[minit] ASC
)
GO
ALTER TABLE [pubs].[employee] ADD CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED ([emp_id] ASC)
GO
ALTER TABLE [pubs].[employee] ADD DEFAULT ((1)) FOR [job_id]
GO
ALTER TABLE [pubs].[employee] ADD DEFAULT ((10)) FOR [job_lvl]
GO
ALTER TABLE [pubs].[employee] ADD DEFAULT ('9952') FOR [pub_id]
GO
ALTER TABLE [pubs].[employee] ADD DEFAULT (getdate()) FOR [hire_date]
GO
-- ALTER TABLE [pubs].[employee] WITH CHECK ADD FOREIGN KEY([job_id]) REFERENCES [pubs].[jobs] ([job_id])
-- GO
-- ALTER TABLE [pubs].[employee] WITH CHECK ADD FOREIGN KEY([pub_id]) REFERENCES [pubs].[publishers] ([pub_id])
-- GO
ALTER TABLE [pubs].[employee] WITH CHECK ADD CONSTRAINT [CK_emp_id] CHECK (([emp_id] like '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR [emp_id] like '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'))
GO
ALTER TABLE [pubs].[employee] CHECK CONSTRAINT [CK_emp_id]
GO
