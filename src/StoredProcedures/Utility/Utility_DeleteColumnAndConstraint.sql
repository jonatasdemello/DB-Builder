EXEC dbo.ProvisionSproc 'Utility', 'DeleteColumnAndConstraint'
GO

ALTER PROCEDURE [Utility].[DeleteColumnAndConstraint]
(
	@SchemaName nvarchar(200),
	@TableName nvarchar(200),
	@ColumnName nvarchar(200)
)
AS
BEGIN
	-- Remove columns
	DECLARE @ConstraintName nvarchar(200), @SQL nvarchar(500)

	IF EXISTS (SELECT * FROM information_schema.columns
		WHERE table_schema = @SchemaName
		AND table_name = @TableName
		AND column_name = @ColumnName
	)
	BEGIN
		-- check if there is any constraint on this column
		SELECT
			@ConstraintName = OBJECT_NAME(dc.object_id)
		FROM
			sys.default_constraints dc
			INNER JOIN sys.columns c ON (c.column_id = dc.parent_column_id AND c.object_id = dc.parent_object_id)
		WHERE
			SCHEMA_NAME(dc.schema_id) = @SchemaName
			AND OBJECT_NAME(dc.parent_object_id) = @TableName AND c.name = @ColumnName

		IF @ConstraintName IS NOT NULL
		BEGIN
			SELECT @SQL = 'ALTER TABLE ['+ @SchemaName +'].['+ @TableName +'] DROP CONSTRAINT '+ @ConstraintName;
			EXEC(@SQL);
		END

		-- remove column
		SELECT @SQL = 'ALTER TABLE ['+ @SchemaName +'].['+ @TableName +'] DROP COLUMN '+ @ColumnName;
		EXEC(@SQL);
	END
END
GO

