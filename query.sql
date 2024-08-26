
CREATE TABLE teachers ( id INT AUTO_INCREMENT, name VARCHAR(100), subject VARCHAR(50), PRIMARY KEY(id) ); 
INSERT INTO teachers (name, subject) VALUES ('Pak Anton', 'Matematika'); 
INSERT INTO teachers (name, subject) VALUES ('Bu Dina', 'Bahasa Indonesia'); 
INSERT INTO teachers (name, subject) VALUES ('Pak Eko', 'Biologi'); 
CREATE TABLE classes ( id INT AUTO_INCREMENT, name VARCHAR(50), teacher_id INT, PRIMARY KEY(id), FOREIGN KEY (teacher_id) REFERENCES teachers(id) ); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 10A', 1); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 11B', 2); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 12C', 3); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 12C', 3); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 10B', 3);
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 11A', 2); 
CREATE TABLE students ( id INT AUTO_INCREMENT, name VARCHAR(100), age INT, class_id INT, PRIMARY KEY(id), FOREIGN KEY (class_id) REFERENCES classes(id) ); 
INSERT INTO students (name, age, class_id) VALUES ('Budi', 16, 1); 
INSERT INTO students (name, age, class_id) VALUES ('Ani', 17, 2); 
INSERT INTO students (name, age, class_id) VALUES ('Candra', 18, 3);




-- 1. Tampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut.

SELECT s.id, s.name AS student_name, s.age AS student_age, t.name AS teacher_name, t.subject, c.name AS class_name 
FROM classes AS c 
INNER JOIN teachers AS t ON c.teacher_id = t.id 
INNER JOIN students AS s ON s.class_id = c.id;



-- 2. Tampilkan daftar kelas yang diajar oleh guru yang sama.

SELECT c.id, c.name AS class_name, t.name AS teacher_name, t.subject 
FROM classes AS c 
INNER JOIN teachers AS t ON c.teacher_id = t.id 
WHERE t.id 
IN (SELECT teacher_id FROM classes GROUP BY teacher_id HAVING COUNT(*) > 1);


-- 3. buat query view untuk siswa, kelas, dan guru yang mengajar.

CREATE VIEW school_view AS 
SELECT s.name AS student_name, s.age AS student_age, t.name AS teacher_name, t.subject, c.name AS class_name 
FROM classes AS c 
INNER JOIN teachers AS t ON c.teacher_id = t.id 
INNER JOIN students AS s ON s.class_id = c.id;

-- 4. buat query yang sama tapi menggunakan store_procedure.

CREATE PROCEDURE get_school()
BEGIN
    SELECT s.name AS student_name, s.age AS student_age, t.name AS teacher_name, t.subject, c.name AS class_name 
    FROM classes AS c 
    INNER JOIN teachers AS t ON c.teacher_id = t.id 
    INNER JOIN students AS s ON s.class_id = c.id;
END;



-- 5. buat query input, yang akan memberikan warning error jika ada data yang sama pernah masuk.

-- add student

CREATE PROCEDURE  add_student(IN student_name VARCHAR(100), IN student_age INT, IN class_id INT)
BEGIN
    DECLARE students_exist INT;

    SELECT COUNT(*) INTO students_exist
    FROM students WHERE name = student_name AND age = student_age AND class_id = class_id;


    IF students_exist > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Student is already exists.";
    ELSE
        INSERT INTO students (name, age, class_id) VALUES (student_name, student_age, class_id); 
    END IF;

END ;

-- add teacher


CREATE PROCEDURE  add_teacher(IN teacher_name VARCHAR(100),IN subject VARCHAR(50))
BEGIN
    DECLARE teachers_exist INT;

    SELECT COUNT(*) INTO teachers_exist
    FROM teachers WHERE name = teacher_name AND subject = subject;


    IF teachers_exist > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Teacher is already exists.";
    ELSE
        INSERT INTO teachers (name, subject) VALUES (teacher_name,subject); 
    END IF;

END;

-- add class

CREATE PROCEDURE  add_class(IN class_name VARCHAR(50),IN teacher_id INT)
BEGIN
    DECLARE classes_exist INT;

    SELECT COUNT(*) INTO classes_exist
    FROM classes WHERE name = class_name AND teacher_id = teacher_id;


    IF classes_exist > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Class is already exists.";
    ELSE
        INSERT INTO classes (name, teacher_id) VALUES (class_name, teacher_id);
    END IF;

END;