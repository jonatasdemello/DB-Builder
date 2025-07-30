IF EXISTS(SELECT * FROM information_schema.routines WHERE routine_type = 'function' AND routine_schema = 'dbo' AND routine_name = 'CheckPassword')
BEGIN
	DROP FUNCTION dbo.CheckPassword
END
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
BEGIN

declare @sql nvarchar(max) = N'
CREATE FUNCTION [dbo].[CheckPassword](@password [nvarchar](4000), @hashed [nvarchar](4000))
RETURNS [bit] WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [BCrypt].[BCryptPackage.UserDefinedFunctions].[CheckPassword]
'
EXEC sys.sp_executesql @sql
END
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
	EXEC sys.sp_addextendedproperty @name=N'AutoDeployed', @value=N'yes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CheckPassword'
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFile', @value=N'BCryptAssembly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CheckPassword'
GO

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'BCrypt')
	EXEC sys.sp_addextendedproperty @name=N'SqlAssemblyFileLine', @value=820 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CheckPassword'
GO
