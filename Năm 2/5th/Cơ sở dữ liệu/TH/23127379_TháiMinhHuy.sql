CREATE DATABASE GK_23127379_CongTrinh
GO
USE GK_23127379_CongTrinh
CREATE TABLE Architects
(
    arch_id CHAR(10) NOT NULL,
    name NVARCHAR(50),
    BestProject CHAR(10),
    birthdate DATE,
    Gender NVARCHAR(10) CHECK (Gender IN (N'Male', N'Female')),
    email CHAR(50)
    PRIMARY KEY(arch_id)
)

CREATE TABLE Projects
(
    Proj_id CHAR(10) NOT NULL,
    Proj_name NVARCHAR(50) NOT NULL,
    keyArch_id CHAR(10),
    budget CHAR(20) NOT NULL,
    Key_item CHAR(10),
    start_date DATE,
    end_data DATE,
    PRIMARY KEY(Proj_id)
)

CREATE TABLE Items
(
    Item_id CHAR(10) NOT NULL,
    project_id CHAR(10) NOT NULL,
    ItemName CHAR(50),
    start_date DATE,
    end_date DATE,
    cost INT CHECK (cost > 0),
    PRIMARY KEY(Item_id, project_id)
)

CREATE TABLE Architects_Projects
(
    architect_id CHAR(10) NOT NULL,
    project_id CHAR(10) NOT NULL,
    Item_ID CHAR(10) NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY(architect_id, project_id, Item_ID)
)

ALTER TABLE Projects
ADD CONSTRAINT FK_Projects_Architects
FOREIGN KEY(keyArch_id)
REFERENCES Architects(arch_id)

ALTER TABLE Architects
ADD CONSTRAINT FK_Architects_Projects
FOREIGN KEY(BestProject)
REFERENCES Projects(Proj_id)

ALTER TABLE Projects
ADD CONSTRAINT FK_Projects_Items
FOREIGN KEY(Key_item, Proj_id)
REFERENCES Items(Item_id, project_id)

ALTER TABLE Architects_Projects
ADD CONSTRAINT FK_Architects_Projects_Architects
FOREIGN KEY(architect_id)
REFERENCES Architects(arch_id)

ALTER TABLE Architects_Projects
ADD CONSTRAINT FK_Architects_Projects_Items
FOREIGN KEY(Item_ID, project_id)
REFERENCES Items(Item_id, project_id)

INSERT INTO Architects(arch_id, name, BestProject, birthdate, Gender, email) VALUES
('1', N'John Smith', NULL, '07-12-1985', N'Male', 'john.smith@example.com'),
('2', N'Emily Johnson', NULL, '05-22-1990', N'Female', 'emily.johnson@example.com'),
('3', N'Michael Brown', NULL, '03-15-1980', N'Male', 'michael.brown@example.com')

INSERT INTO Projects(Proj_id, Proj_name, keyArch_id, budget, Key_item, start_date, end_data) VALUES
('101', N'Project A', '1', '500.0000', NULL, '01-01-2023', '12-31-2023'),
('102', N'Project B', '2', '8.000.000', NULL, '03-01-2023', '02-28-2024'),
('103', N'Project C', '2', '10.000.000', NULL, '06-01-2023', '05-31-2024')

UPDATE Architects SET BestProject = '101' WHERE arch_id = '1'
UPDATE Architects SET BestProject = '102' WHERE arch_id = '2'
UPDATE Architects SET BestProject = '103' WHERE arch_id = '3'

INSERT INTO ITEMS(Item_id, project_id, ItemName, start_date, end_date, cost) VALUES
('201', '101', 'Foundation Work', '01-01-2023', NULL, 1000000),
('202', '101', 'Wall Construction', '03-02-2023', NULL, 1500000),
('203', '102', 'Roof Framing', '03-01-2023', '05-15-2023', 2000000),
('204', '102', 'Roof Installation', '05-16-2023', NULL, 2500000)

UPDATE Projects SET Key_item = '201' WHERE Proj_id = '101'
UPDATE Projects SET Key_item = '204' WHERE Proj_id = '102'

INSERT INTO Architects_Projects(architect_id, project_id, Item_ID, salary) VALUES
('1', '101', '201', 50000),
('1', '102', '203', 55000),
('2', '101', '201', 60000),
('2', '102', '204', 65000)

-- Cho danh sách các kiến trúc sư chưa từng tham gia công trình nào trong 2 năm trở lại đây
SELECT arch_id 'ID kiến trúc sư', name 'Tên kiến trúc sư'
FROM Architects
EXCEPT
SELECT arch.arch_id 'ID Kiến trúc sư', arch.name 'Tên kiến trúc sư'
FROM Architects arch, Projects pj
WHERE arch.arch_id = pj.keyArch_id
-- Cho danh sách công trình (mã công trình, tên công trình, tên hạng mục chính)
-- do kiến trúc sư Emily Johnson làm trưởng phụ trách
SELECT pj.Proj_id 'Mã công trình', pj.Proj_name 'Tên công trình', it.ItemName 'Tên hạng mục chính'
FROM Architects arch, Projects pj, Items it
WHERE arch.arch_id = pj.keyArch_id and pj.Proj_id = arch.BestProject
      AND pj.Proj_id = it.project_id and pj.Key_item = it.Item_id AND arch.name = N'Emily Johnson'

-- Cho danh sách mỗi hạng mục (mã hạn mục, tên hạn mục, kinh phí thực hiện hạng mục, tổng thù lao cho kiến trúc sư cho hạng mục này)
-- thuộc các công trình bắt đầu từ sau 1/1/2023 mà chưa kết thúc
SELECT arch_pj.architect_id'Mã kiến trúc sư',it.Item_id 'Mã hạng mục', it.ItemName 'Tên hạng mục', it.cost 'Kinh phí thực hiện hạng mục', SUM(arch_pj.salary) 'Tổng thù lao kiến trúc sư nhận được'
FROM Items it, Architects_Projects arch_pj
WHERE it.Item_id = arch_pj.Item_ID AND it.project_id = arch_pj.project_id
      AND it.end_date IS NULL AND (DAY(it.start_date) > 1 OR DAY(it.start_date) = 1) AND (MONTH(it.start_date) > 1 OR MONTH(it.start_date) = 1) AND (YEAR(it.start_date) > 2023 OR YEAR(it.start_date) = 2023) 
GROUP BY arch_pj.architect_id, it.Item_id, it.ItemName, it.cost
