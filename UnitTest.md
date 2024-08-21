# Unit Test

## tSQLt - unit testing framework for Microsoft SQL Server

reference:

https://github.com/tSQLt-org/tSQLt

https://tsqlt.org/user-guide/quick-start/



Setup: to install the tSQLt in your database (only once):

- Execute the `PrepareServer.sql` file;
- Execute the `tSQLt.class.sql` file;

Then write your tests:

First, create a test class. A test class is a schema that is specially marked by tSQLt. That way tSQLt knows how to find your test cases.

```sql
EXEC tSQLt.NewTestClass 'TryItOut';
GO
```

Next, create your test cases (a test procedure on this test class).


```sql
CREATE PROCEDURE TryItOut.[test this causes a failure]
AS
BEGIN
    EXEC tSQLt.Fail 'This is what a failure looks like';
END;
GO

CREATE PROCEDURE TryItOut.[test this one passes]
AS
BEGIN
    DECLARE @sum INT;
    SELECT @sum = 1 + 2;

    EXEC tSQLt.AssertEquals 3, @sum;
END
GO
```

Then, run all your tests:

```sql
EXEC tSQLt.RunAll
GO

-- Run all tests in test class
EXEC tSQLt.Run 'TryItOut';

-- Run one test only in test class
EXEC tSQLt.Run 'TryItOut.[test this one passes]';

-- Runs using the parameter provided last time tSQLt.Run was executed
EXEC tSQLt.Run;
```

If you want, you can remove all your tests:

```sql
EXEC tSQLt.DropClass 'TryItOut';
GO
```

If you want to rename your test class:

```sql
EXEC tSQLt.RenameClass 'testFinancialApp', 'FinancialAppTests';
GO
```
