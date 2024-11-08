CREATE DATABASE BlogDB
USE BlogDB


CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Tags(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Users(
Id INT PRIMARY KEY IDENTITY,
UserName NVARCHAR(30) NOT NULL UNIQUE,
FullName NVARCHAR(50) NOT NULL,
Age INT NOT NULL CHECK(Age >= 0 AND Age <= 150)
)

CREATE TABLE Blogs(
Id INT PRIMARY KEY IDENTITY,
Title NVARCHAR(50) NOT NULL,
UserId INT REFERENCES Users(Id),
CategoryId INT REFERENCES Categories(Id)
)

CREATE TABLE Comments(
Id INT PRIMARY KEY IDENTITY,
Content NVARCHAR(250) NOT NULL UNIQUE,
UserId INT REFERENCES Users(Id),
BlogId INT REFERENCES Blogs(Id)
)

CREATE TABLE Tags_Blogs(
Id INT PRIMARY KEY IDENTITY,
TagId INT REFERENCES Tags(Id),
BlogId INT REFERENCES Blogs(Id)
)


INSERT INTO Users VALUES
('İlgarcanavar', N'İlqar Beydullayev', 19),
('AzeLebo', N'Rəvan Quliyev', 20)

INSERT INTO Categories VALUES
(N'Universitet fənnləri'),
(N'Davamiyyət')

INSERT INTO Tags VALUES
(N'Universitet daxilində'),
(N'Ümumi məsələlər')

INSERT INTO Blogs VALUES
(N'Fənlərin hamısı əvəz olunması', 1, 2),
(N'Qayıb limitinin yetərliliyi', 2, 1)

INSERT INTO Comments VALUES
(N'Fənlərin hamısı əvəz olunmalıdır ki ixtisasa daha yaxşı fokuslanaq.', 1, 1),
(N'Qayıb limitinin az olması səbəbindən dərsin başlanma saatı biraz daha gecikdirilməlidir', 2, 2)


CREATE VIEW GetUsersBlogs AS
SELECT B.Title, U.UserName, U.FullName FROM Blogs AS B
INNER JOIN Users AS U
ON B.UserId = U.Id

CREATE VIEW GetCategoriesBlogs AS
SELECT B.Title, C.Name FROM Blogs AS B
INNER JOIN Categories AS C
ON B.CategoryId = C.Id


CREATE PROCEDURE usp_GetUserComments @UserId INT
AS
SELECT C.Content FROM Comments AS C
WHERE C.UserId = @UserId

CREATE PROCEDURE usp_GetUserBlogs @UserId INT 
AS
SELECT B.Title FROM Blogs AS B
WHERE B.UserId = @UserId


CREATE FUNCTION BlogsCount(@categoryId INT)
RETURNS INT AS
BEGIN 
DECLARE @count INT
SELECT @count = COUNT(*) FROM Blogs WHERE Blogs.CategoryId = @categoryId
RETURN @count
END


CREATE FUNCTION GetBlogs(@userId INT)
RETURNS TABLE AS
RETURN SELECT * FROM Blogs WHERE Blogs.UserId = @UserId


ALTER TABLE Blogs
ADD IsDeleted BIT DEFAULT 0


UPDATE Blogs SET IsDeleted = 0


CREATE TRIGGER BlogDeleter
ON Blogs
INSTEAD OF DELETE AS
BEGIN 
UPDATE Blogs SET IsDeleted = 1 WHERE Id IN (SELECT Id FROM deleted)
END


SELECT * FROM GetUsersBlogs

SELECT * FROM GetCategoriesBlogs


EXEC usp_GetUserComments 1

EXEC usp_GetUserBlogs 2


SELECT dbo.BlogsCount(1) AS [Blog Count]

SELECT Title FROM dbo.GetBlogs(1)


--DELETE FROM Blogs WHERE Id = 2