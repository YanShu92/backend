-- database_01_thanhk4;

-- create courses table
CREATE TABLE courses (
	id int NOT NULL,
	name varchar(50) NOT NULL,
    price float,
    detail text,
    teacher_id integer NOT NULL,
    active integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- add description column before detail
-- rename table
ALTER TABLE courses RENAME TO old_courses;

-- tạo table moi
CREATE TABLE courses (
	id int NOT NULL primary key GENERATED ALWAYS AS IDENTITY,
	name varchar(50)  NOT NULL,
    price float,
	description text NOT NULL,
    detail text,
    teacher_id integer NOT NULL,
    active integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
	CONSTRAINT courses_name_price_unique UNIQUE (name, price)
);

-- copy data from old to new table
INSERT INTO courses (name, price, detail, teacher_id, active, created_at, updated_at) 
SELECT name, price, detail, teacher_id, active, created_at, updated_at
FROM old_courses;

-- Drop table
DROP TABLE old_courses;

-- rename detail
ALTER TABLE courses
RENAME COLUMN detail
TO content;

-- set contraint
ALTER TABLE courses 
ALTER COLUMN content
SET NOT NULL;

-- create teacher table
CREATE TABLE teacher
(
    id int NOT NULL primary key GENERATED ALWAYS AS IDENTITY,
    name varchar(50) NOT NULL,
    bio text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
	CONSTRAINT teacher_bio_unique UNIQUE (bio)
);

-- add foreign key for teacher_id
ALTER TABLE courses
ADD CONSTRAINT courses_teacher_id_foreign
FOREIGN KEY (teacher_id) REFERENCES teacher(id);

-- add 3 teachers:
INSERT INTO teacher( name, bio)
VALUES ( 'Trần Văn A', 'Bio Trần Văn A');

INSERT INTO teacher( name, bio)
VALUES ( 'Trần Văn B', 'Bio Trần Văn B');

INSERT INTO teacher( name, bio)
VALUES ( 'Trần Văn C', 'Bio Trần Văn C');


-- add 3 courses/teacher:
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Toán 10', 99, 'Toán THPT lớp 10','Toán THPT lớp 10', 1, 1);
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Toán 11', 199, 'Toán THPT lớp 11','Toán THPT lớp 11', 1, 1);
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Toán 12', 299, 'Toán THPT lớp 12','Toán THPT lớp 12', 1, 1);

INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Văn 10', 91, 'Văn THPT lớp 10','Văn THPT lớp 10', 2, 1);
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Văn 11', 191, 'Văn THPT lớp 11','Văn THPT lớp 11', 2, 1);
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Văn 12', 291, 'Văn THPT lớp 12','Văn THPT lớp 12', 2, 1);

INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Anh 10', 90, 'Anh THPT lớp 10','Anh THPT lớp 10', 3, 1);
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Anh 11', 190, 'Anh THPT lớp 11','Anh THPT lớp 11', 3, 1);
INSERT INTO courses(name, price, description, content, teacher_id, active)
VALUES ('Anh 12', 290, 'Anh THPT lớp 12','Anh THPT lớp 12', 3, 1);

-- update name and price
UPDATE courses
SET name='Toán học 10', price=990, updated_at=NOW()
WHERE id = 1;
UPDATE courses
SET name='Toán học 11', price=1990, updated_at=NOW()
WHERE id = 2;
UPDATE courses
SET name='Toán học 12', price=2990, updated_at=NOW()
WHERE id = 3;

UPDATE courses
SET name='Ngữ văn 10', price=910, updated_at=NOW()
WHERE id = 4;
UPDATE courses
SET name='Ngữ văn 11', price=1910, updated_at=NOW()
WHERE id = 5;
UPDATE courses
SET name='Ngữ văn 12', price=2910, updated_at=NOW()
WHERE id = 6;

UPDATE courses
SET name='Anh văn 10', price=900, updated_at=NOW()
WHERE id = 7;
UPDATE courses
SET name='Anh văn 11', price=1900, updated_at=NOW()
WHERE id = 8;
UPDATE courses
SET name='Anh văn 12', price=2900, updated_at=NOW()
WHERE id = 9;

-- update bio
UPDATE teacher
SET bio='Đây là bio của Trần Văn A', updated_at=NOW()
WHERE id = 1;
UPDATE teacher
SET bio='Đây là bio của Trần Văn B', updated_at=NOW()
WHERE id = 2;
UPDATE teacher
SET bio='Đây là bio của Trần Văn C', updated_at=NOW()
WHERE id = 3;

-- show tables
SELECT * FROM teacher;
SELECT * FROM courses;
