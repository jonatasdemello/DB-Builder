-- add an if to check if the assembly is already loaded
IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
BEGIN
	IF EXISTS(SELECT * FROM information_schema.routines WHERE routine_type = 'function' AND routine_schema = 'dbo' AND routine_name = 'BCrypt')
	BEGIN
		DROP FUNCTION dbo.BCrypt
	END
END
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
BEGIN

declare @sql nvarchar(max) = N'
CREATE FUNCTION [dbo].[BCrypt](@password [nvarchar](4000), @rounds [int])
RETURNS [nvarchar](4000) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [BCrypt].[BCryptPackage.UserDefinedFunctions].[BCrypt]
'
EXEC sys.sp_executesql @sql

END
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
	EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'BCrypt'
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
	EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'BCryptAssembly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'BCrypt'
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
	EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=813 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'BCrypt'
GO

