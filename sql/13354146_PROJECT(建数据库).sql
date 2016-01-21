DROP DATABASE IF EXISTS 13354146_PROJECT;
CREATE DATABASE 13354146_PROJECT;
USE 13354146_PROJECT;

DROP TABLE IF EXISTS USER_WEB;
CREATE TABLE USER_WEB
(
	user_id varchar(20) PRIMARY KEY NOT NULL,
	password varchar(20),
	realname varchar(20),
	user_type int
);

DROP TABLE IF EXISTS COURSE;
CREATE TABLE COURSE
(
	course_id varchar(20),
	course_name varchar(20),
	class_id varchar(20),
	ta_id varchar(20)
);

DROP TABLE IF EXISTS COURSE_CLASS;
CREATE TABLE COURSE_CLASS
(
	class_id varchar(20),
	class_name varchar(40),
	teacher_id varchar(40)
);

DROP TABLE IF EXISTS CLASS_COURSE_STUDENT;
CREATE TABLE CLASS_COURSE_STUDENT
(
	class_id varchar(20),
	student_id varchar(20)
);

DROP TABLE IF EXISTS ADD_HOMEWORK;
CREATE TABLE ADD_HOMEWORK
(
	course_id varchar(20),
	homework_id varchar(20),
	homework_title varchar(40),
	homework_description text,
	detail_attach_file varchar(100),
	post_date datetime,
	ddl datetime
);

DROP TABLE IF EXISTS STUDENT_HOMEWORK;
CREATE TABLE STUDENT_HOMEWORK
(
	course_id varchar(20),
	homework_id varchar(20),
	student_id varchar(20),
	post_date datetime,
	detail_attach_file text,
	score varchar(20)
);

