SET NOCOUNT ON
BEGIN TRANSACTION

BEGIN TRY
	-- 1. Setup test data.

	-- 2. Run the unit tests.
	--SELECT 1 / 0  -- Simulating an error

	-- 3. Roll everything back.
	ROLLBACK TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;

	THROW 51000, 'Error in EducatorTableGetBySchoolId Unit Tests!', 16;
END CATCH

