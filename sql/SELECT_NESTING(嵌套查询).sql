SELECT homework_title FROM 
	((CLASS_COURSE_STUDENT C1 INNER JOIN COURSE C2 ON
			C1.class_id = C2.class_id) 
			INNER JOIN ADD_HOMEWORK A ON A.course_id = C2.course_id) 
				WHERE C1.student_id = '13354494' 
					AND A.ddl > '2016-1-29 00:00:00';
					
SELECT * FROM 
	COURSE C1 INNER JOIN STUDENT_HOMEWORK S ON
		C1.course_id = S.course_id 
			WHERE C1.class_id = '1' AND S.homework_id = 'EX01';
			
SELECT * FROM ADD_HOMEWORK WHERE course_id = '123' AND homework_id = 'EX_01';

SELECT course_id, course_name, C.class_id, ta_id FROM COURSE C INNER JOIN COURSE_CLASS CC ON C.class_id = CC.class_id WHERE teacher_id = "t1";