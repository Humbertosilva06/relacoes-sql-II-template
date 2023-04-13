-- Active: 1681398196304@@127.0.0.1@3306

-- Práticas

-- o created_at é como default: DEFAULT(DATETIME()) e not null
CREATE TABLE users(
    id TEXT NOT NULL UNIQUE PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    created_at TEXT DEFAULT(DATETIME('now', 'localtime')) NOT NULL
);

INSERT INTO users (id, name, email, password)
VALUES
("u001", "tonzerapinador", "tonzerapinador@email", "13456"),
("u002", "suetam", "suetam@email", "13456"),
("u003", "tonzerapinador2", "tonzerapinador2@email", "13456");

SELECT * FROM users;

--pratica 2
-- a tabela tem duas foreign key, pois é a tabela de relações, e dentro da tabela users, um usuario pode seguir muitas pessoas e ser seguido por muitas pessoas
CREATE TABLE follows (
    follower_id TEXT NOT NULL,
    followed_id TEXT NOT NULL,
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (followed_id) REFERENCES users(id)
);

INSERT INTO follows (follower_id, followed_id)
VALUES
("u001", "u002"),
("u001", "u003"),
("u002", "u001");

SELECT * FROM follows;
-- inne join pega apenas a intersecção das tabelas (por isso nessa o user "u003" não parece, pois ele existe na users, mas a relação dele na follows não existe)
SELECT * FROM users
INNER JOIN follows
ON follows.follower_id = users.id;

-- com left join eu pego tudo da tebal da esquerda + a intersecção com a da direita

SELECT * FROM users
LEFT JOIN follows
ON follows.follower_id = users.id;

-- com right JOIN eu pego a intersecção + tudo da tabela da direita

SELECT * from users
RIGHT JOIN follows
ON follows.followed_id = users.id;

-- pratica 3
-- temos que colocar um alias no segundo users pq o sql se confunde se tiver dois iguais e ai no ON em vez de ser = users.id a gente referencia o alias, ficando = user2.id
SELECT
users.id,
users.name,
user2.id AS followed_id,
user2.name as followed_name
FROM users
LEFT JOIN follows
ON follows.follower_id = users.id
left JOIN users as user2
on follows.followed_id = user2.id;


CREATE TABLE students(
    id TEXT UNIQUE NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER NOT NULL
);

CREATE TABLE courses(
    id TEXT UNIQUE NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    area TEXT NOT NULL
);

INSERT INTO students (id, name, age)
VALUES
("s001", "humberto", 33),
("s002", "pedro", 25),
("s003", "margarete", 54);

INSERT INTO courses (id, name, area)
VALUES
("c001", "fazer balanço", "contabil"),
("c002", "fazendo pizza", "gastronomia"),
("c003", "sei la o que to fazendo", "perdidaço"),
("c004", "faculdade de churrasco", "gastronomia"),
("c005", "mexer no word", "informatica");

CREATE TABLE course_student (
    student_id TEXT NOT NULL,
    course_id TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
   
);

DROP TABLE course_student;

INSERT INTO course_student (student_id, course_id)
VALUES
("s001", "c003"),
("s001", "c005"),
("s002", "c003"),
("s002", "c004");

SELECT
students.id AS idEstudante,
students.name AS nomeEstudante,
courses.name AS nomeCurso,
courses.area as areaDoCurso
FROM students
LEFT JOIN course_student
ON course_student.student_id = students.id
LEFT JOIN courses
ON course_student.course_id = courses.id;
