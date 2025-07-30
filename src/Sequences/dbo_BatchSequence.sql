IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = 'BatchSequence')
BEGIN
	CREATE SEQUENCE dbo.BatchSequence
		AS INT
		START WITH 1
		INCREMENT BY 1;
		-- to use: 	SELECT NEXT VALUE FOR dbo.BatchSequence;
END
GO
