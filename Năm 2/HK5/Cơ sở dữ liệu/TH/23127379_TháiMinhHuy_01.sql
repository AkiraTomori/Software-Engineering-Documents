CREATE DATABASE GK_23127379_Cinema
GO
USE GK_23127379_Cinema

CREATE TABLE Actors
(
    actor_id CHAR(10) NOT NULL,
    fisrt_name NVARCHAR(20),
    last_name NVARCHAR(20),
    birthdate DATE,
    Gender NVARCHAR(10) CHECK (Gender IN (N'Nam', N'Nữ')) DEFAULT N'Nữ',
    careerDefiningFilm CHAR(10),
    PRIMARY KEY(actor_id)
)

CREATE TABLE Movies
(
    movie_id CHAR(10) NOT NULL,
    title NVARCHAR(50) NOT NULL,
    release_date DATE,
    director_id CHAR(10),
    MovieRevenue INT,
    ProductionBudget INT NOT NUll,
    PRIMARY KEY(movie_id)
)

CREATE TABLE Directors
(
    director_id CHAR(10) NOT NULL,
    Name NVARCHAR(50),
    DateOfBirth DATE,
    Nationality NVARCHAR(20),
    Gender NVARCHAR(10) CHECK (Gender In (N'Nam', N'Nữ')),
    best_movie_id CHAR(10),
    PRIMARY KEY(director_id)
)

CREATE TABLE Participation
(
    movie_id CHAR(10) NOT NULL,
    actor_id CHAR(10) NOT NULL,
    salary INT NOT NULL,
    character NVARCHAR(20) NOT NULL,
    PRIMARY KEY(movie_id, actor_id)
)

ALTER TABLE Actors
ADD CONSTRAINT FK_ACTORS_MOVIES
FOREIGN KEY(careerDefiningFilm)
REFERENCES Movies(movie_id)

ALTER TABLE Movies
ADD CONSTRAINT FK_MOVIES_DIRECTORS
FOREIGN KEY(director_id)
REFERENCES Directors(director_id)

ALTER TABLE Directors
ADD CONSTRAINT FK_DIRECTORS_MOVIES
FOREIGN KEY(best_movie_id)
REFERENCES Movies(movie_id)

ALTER TABLE Participation
ADD CONSTRAINT FK_PARTICIPATION_MOVIES
FOREIGN KEY(movie_id)
REFERENCES Movies(movie_id)

ALTER TABLE Participation
ADD CONSTRAINT FK_PARTICIPATION_ACTORS
FOREIGN KEY(actor_id)
REFERENCES Actors(actor_id)

INSERT INTO Movies(movie_id, title, release_date, director_id, MovieRevenue, ProductionBudget) VALUES
('M1', N'Iron Man', '05-02-2008', NULL, 585000000, 140000000),
('M2', N'Gạo nếp gạo tẻ', '07-17-2018', NULL, 100000, 30000)

INSERT INTO Directors(director_id, Name, DateOfBirth, Nationality, Gender, best_movie_id) VALUES
('D1', N'Jon Favreau', '09-25-1966', N'Mỹ', N'Nam', NULL),
('D2', N'Trần Thanh Hương', '10-19-1974', N'Việt Nam', N'Nữ','M2')

UPDATE Movies SET director_id = 'D1' WHERE movie_id = 'M1'
UPDATE Movies SET director_id = 'D2' WHERE movie_id = 'M2'

INSERT INTO Actors(actor_id, fisrt_name, last_name, birthdate, Gender, careerDefiningFilm) VALUES
('A1', N'Robert', N'Downey', '04-04-1965', N'Nam', 'M1'),
('A2', N'Thúy Diễm', NULL, '08-25-1986', N'Nữ', NULL),
('A3', N'Stan Lee', NULL, NULL, N'Nam', NULL)

INSERT INTO Participation(movie_id, actor_id, salary, character) VALUES
('M1', 'A1', 100000, N'Chính'),
('M1', 'A3', 10000, N'Khách mời'),
('M2', 'A2', 10000, N'Chính')


-- Cho danh sách các diễn viên chưa từng tham gia bộ phim do Jon Favreau đạo diễn
SELECT fisrt_name, last_name
FROM Actors
EXCEPT
SELECT ac.fisrt_name, ac.last_name
FROM Directors dir, Participation pa, Actors ac, Movies mv
WHERE mv.movie_id = pa.movie_id AND pa.actor_id = ac.actor_id AND dir.Name = N'Jon Favreau' AND dir.director_id = mv.director_id

-- Cho danh sách diễn viên (mã diễn viên, tên diễn viên, tên bộ phim làm nên tên tuổi diễn viên)
-- đã từng tham gia hơn 2 bộ phim
SELECT pa.actor_id 'Mã diễn viên', ac.fisrt_name 'Tên diễn viên', mv.title 'Tên bộ phim'
FROM Actors ac, Movies mv, Participation pa
WHERE ac.actor_id = pa.actor_id AND mv.movie_id = pa.movie_id
GROUP BY pa.actor_id, ac.fisrt_name, mv.title
HAVING COUNT(*) > 2
-- Cho danh sách các bộ phim (mã bộ phim, tên phim, kinh phí bộ phim, tổng thu lao chi cho diễn viên)
--có tổng kinh phí vượt quá doanh thu phim

SELECT mv.movie_id 'Mã bộ phim', mv.title 'Tên phim', mv.ProductionBudget 'Kinh phí bộ phim', SUM(pa.salary) 'Tổng thu lao chi cho diễn viên'
FROM Movies mv, Actors ac, Participation pa
WHERE pa.movie_id = mv.movie_id AND pa.actor_id = ac.actor_id AND mv.ProductionBudget > mv.MovieRevenue
GROUP BY ac.actor_id ,mv.movie_id, mv.title, mv.ProductionBudget
