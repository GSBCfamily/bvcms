CREATE FUNCTION [dbo].[LastChanged](@pid int, @field nvarchar(20))
RETURNS DATETIME
AS
BEGIN
	DECLARE @dt DATETIME
	SELECT TOP 1 @dt = Created FROM ChangeLog
	WHERE PeopleId = @pid
	AND Data LIKE ('%<td>' + @field + '</td>%')
	ORDER BY Created DESC
	RETURN @dt
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
