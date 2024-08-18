SET NOCOUNT ON;

-- First, create a test class.
-- A test class is a schema that is specially marked by tSQLt.
-- That way tSQLt knows how to find your test cases.

EXEC tSQLt.NewTestClass 'SampleTestClass';
GO

-- Next, create your test cases (a test procedure on this test class).
-------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SampleTestClass.[test_failure]
AS
BEGIN
    EXEC tSQLt.Fail 'This is what a failure looks like';
END;
GO

CREATE PROCEDURE SampleTestClass.[test_passes]
AS
BEGIN
    DECLARE @sum INT;
    SELECT @sum = 1 + 2;

    EXEC tSQLt.AssertEquals 3, @sum;
END
GO

-- Then, run all your tests:
-------------------------------------------------------------------------------------------------------------------------------
EXEC tSQLt.RunAll
GO

-- Run all tests in test class
EXEC tSQLt.Run 'SampleTestClass';

-- Run one test only in test class
EXEC tSQLt.Run 'SampleTestClass.[test_passes]';

-- Runs using the parameter provided last time tSQLt.Run was executed
--EXEC tSQLt.Run;


-- to remove all your tests:
-------------------------------------------------------------------------------------------------------------------------------
EXEC tSQLt.DropClass 'SampleTestClass';
GO

-- to rename your test class:
-- EXEC tSQLt.RenameClass 'testFinancialApp', 'FinancialAppTests';
-- GO

