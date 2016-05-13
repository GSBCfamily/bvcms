CREATE PROC [dbo].[AddUserFromOtherId](@name VARCHAR(50), @user VARCHAR(50), @password VARCHAR(100), @fieldname VARCHAR(50), @id INT, @roles VARCHAR(500))
AS
BEGIN
	INSERT  INTO dbo.Users ( Username ,[Password] , TempPassword,Name ,PeopleId, MustChangePassword, IsApproved )
	VALUES  (@user, 'thisisanencryptedpassword' ,@password ,@name
	        ,( SELECT PeopleId FROM dbo.PeopleExtra
	           WHERE Field = @fieldname AND IntValue = @id ), 1, 1)

	DECLARE @userid INT = @@IDENTITY

	INSERT dbo.UserRole ( RoleId, UserId )
	SELECT r.RoleId, @userid
	FROM dbo.Split(@roles, ',') rr
	JOIN dbo.Roles r ON r.RoleName = rr.Value

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
