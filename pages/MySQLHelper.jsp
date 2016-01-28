<%@ page language="java" import="java.util.*,java.io.*,java.sql.*"%>
<%!
public static class MySQLHelper {

	private static final String databaseHostIp = "202.116.76.22";
	private static final String databaseHostPort = "53306";
	private static final String databaseName = "13354146_PROJECT";
	private static final String databaseUserName = "user";
	private static final String databaseUserPassword = "123456";
	
	// private static final String databaseHostIp = "sunshining.cloudapp.net";
	// private static final String databaseHostPort = "3306";
	// private static final String databaseName = "13354146_PROJECT";
	// private static final String databaseUserName = "user";
	// private static final String databaseUserPassword = "Crash";
	
	private static final String accountTable = "USER_WEB";
	private static final String courseTable = "COURSE";
	private static final String classTable = "COURSE_CLASS";
	private static final String clsStuTable = "CLASS_COURSE_STUDENT";
	private static final String taPushHomeworkTable = "ADD_HOMEWORK";
	private static final String stuSubmitHomeworkTable = "STUDENT_HOMEWORK";

	private static Connection getConnection() {
		String connectString = "jdbc:mysql://" + databaseHostIp 
								+ ":" + databaseHostPort 
								+ "/" + databaseName 
								+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
		
		/****y****/
		/*String connectString = "jdbc:mysql://localhost/13354146_PROJECT?"
				+ "autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";*/
		/****y****/
								
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			
			conn = DriverManager.getConnection(connectString, databaseUserName, databaseUserPassword);
			/***y****/
			//conn = DriverManager.getConnection(connectString, "root", "131413");
			/***y****/
			return conn;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private static boolean update(String sql) {
		Connection conn = null;
		try {
			conn = getConnection();
			Statement stat = conn.createStatement();
			stat.executeUpdate(sql);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch	(Exception e) {
				e.printStackTrace();
			}
		}
		return false;
	}

	private static ResultSet query(String sql) {
		ResultSet rs = null;
		try {
			Connection conn = getConnection();
			Statement stat = conn.createStatement();
			rs = stat.executeQuery(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rs;
	}

	public static boolean addAccount(String id, String pwd, String name, int type) {
		String sql = String.format("INSERT INTO " + accountTable + " values('%s', '%s', '%s', %d)",
									id, pwd, name, type);
		if (update(sql)) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean checkPwd(String id, String pwd) {
		boolean exist = false;
		String sql = String.format("SELECT * FROM " + accountTable + " WHERE user_id='%s' AND password='%s'",
									id, pwd);
		try {
			ResultSet rs = query(sql);
			while (rs.next()) {
				String _id = rs.getString("user_id");
				String _pwd = rs.getString("password");
				if (_id.equals(id) && _pwd.equals(pwd)) {
					exist = true;
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return exist;
	}

	public static boolean modifyPwd(String id, String oldPwd, String newPwd) {
		boolean status = false;
		if (checkPwd(id, oldPwd)) {
			String sql = String.format("UPDATE " + accountTable + " SET password='%s' WHERE user_id='%s'",
										newPwd, id);
			if (update(sql)) {
				status = true;
			}
		}
		return status;
	}

	public static ArrayList<HomeworkPost> queryDDLHomework(String stuId) {
		ArrayList<HomeworkPost> homeworkPostList = new ArrayList<HomeworkPost>();
		try {
			java.util.Date date = new java.util.Date(); 
			Timestamp timestamp = new Timestamp(date.getTime());
			String sql = String.format("SELECT * FROM (" 
				+ "(%s C1 INNER JOIN %s C2 ON C1.class_id = C2.class_id) " 
				+ "INNER JOIN %s A ON A.course_id = C2.course_id) " 
				+ "WHERE C1.student_id = '%s' AND A.ddl > '%s'",
				clsStuTable, courseTable, taPushHomeworkTable, stuId, timestamp.toString());
			ResultSet rs = query(sql);
			while (rs.next()) {
				homeworkPostList.add(new HomeworkPost(
					rs.getString("course_id"), 
					rs.getString("homework_id"), 
					rs.getString("homework_title"), 
					rs.getString("homework_description"), 
					rs.getString("detail_attach_file"), 
					rs.getString("post_date"), 
					rs.getString("ddl")
					rs.getString("class_id")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return homeworkPostList;
	}

	public static boolean addHomework(HomeworkPost hwp) {
		String sql = String.format("INSERT INTO " + taPushHomeworkTable 
			+ " values('%s', '%s', '%s', '%s', '%s', '%s', '%s')", 
			hwp.course_id, hwp.homework_id, hwp.homework_title, 
			hwp.homework_description, hwp.detail_attach_file, 
			hwp.post_date, hwp.ddl);
		if (update(sql)) {
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList<String> queryDownloadHomework(String classId, String hwId) {
		ArrayList<String> fileSrcList = new ArrayList<String>();
		try {
			ArrayList<String> studentsIdList = new ArrayList<String>();
			String sql = String.format("SELECT * FROM " + clsStuTable + " WHERE class_id='%s'", classId);
			ResultSet rs = query(sql);
			while (rs.next()) {
				studentsIdList.add(new String(rs.getString("student_id")));
			}
			for (String s : studentsIdList) {
				String sql2 = String.format("SELECT * FROM " + stuSubmitHomeworkTable 
					+ " WHERE homework_id='%s', student_id='%s'", 
					hwId, s);
				ResultSet rs2 = query(sql2);
				while (rs2.next()) {
					fileSrcList.add(new String(rs2.getString("detail_attach_file")));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fileSrcList;
	}

	public static boolean submitHomework(Homework hw) {
		String sql = String.format("INSERT INTO " + stuSubmitHomeworkTable 
			+ " values('%s', '%s', '%s', '%s', '%s', '%s')", 
			hw.course_id, hw.homework_id, hw.student_id, 
			hw.post_date, hw.detail_attach_file, hw.score);
		if (update(sql)) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean isTA(String stuId) {
		String sql = String.format("SELECT COUNT(*) from " + courseTable + " where ta_id = '%s'", stuId);
		ResultSet rs = query(sql);
		Integer recordCount = 0;
		try {
			if (rs.next()) {
				recordCount = rs.getInt(1); 
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		if(recordCount > 0)
			return true;
		return false;
	}
	
	public static boolean isTeacher(String teacherId) {
		String sql = String.format("SELECT COUNT(*) from " + classTable + " where teacher_id = '%s'", teacherId);
		ResultSet rs = query(sql);
		Integer recordCount = 0;
		try {
			if (rs.next()) {
				recordCount = rs.getInt(1); 
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		if(recordCount > 0)
			return true;
		return false;
	}
	
	public static boolean chooseTA(String course_name, String class_id, String ta_id) {
		String course_id = "";
		String sub_sql = String.format("SELECT course_id FROM %s WHERE course_name = '%s'", courseTable, course_name);
		ResultSet sub_rs = query(sub_sql);
		try {
			if (sub_rs.next()) {
				course_id = sub_rs.getString("course_id");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		String sql = String.format("INSERT INTO " + courseTable 
				+ " values('%s', '%s', '%s', '%s')", 
				course_id, course_name, class_id, ta_id);
		if (update(sql)) {
			return true;
		} else {
			return false;
		}
	}
	
	
	public static ArrayList<CourseInfo> queryCourseInfo(String teacherId) {
		
		ArrayList<CourseInfo> courseInfoList = new ArrayList<CourseInfo>();
		try {
			String sql = String.format("SELECT course_id, course_name, C.class_id, ta_id FROM %s " +
			"C INNER JOIN %s CC ON C.class_id = CC.class_id " + 
			"WHERE teacher_id = '%s'", courseTable, classTable, teacherId);
			ResultSet rs = query(sql);
			while(rs.next()) {
				String sub_sql = String.format("SELECT realname FROM %s WHERE user_id = '%s'", accountTable, rs.getString("ta_id"));
				ResultSet sub_rs = query(sub_sql);
				String ta_name = "";
				if (sub_rs.next()) {
					ta_name = sub_rs.getString("realname");
				}
				courseInfoList.add(new CourseInfo(
						rs.getString("course_id"),
						rs.getString("course_name"),
						rs.getString("class_id"),
						ta_name));
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return courseInfoList;
	}

	public static ArrayList<String> queryCourseForTeacher(String teacherId) {
		ArrayList<String> courseForTeacher = new ArrayList<String>();
		try {
			String sql = String.format("SELECT DISTINCT course_name FROM %s C INNER JOIN %s CC ON C.class_id = CC.class_id WHERE teacher_id = '%s'", courseTable, classTable, teacherId);
			ResultSet rs = query(sql);
			while(rs.next()) {
				courseForTeacher.add(rs.getString("course_name"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return courseForTeacher;
	}

	public static ArrayList<HomeworkToMark> queryHomeworkToMarkForTA(String TAId) {
		ArrayList<HomeworkToMark> toMarkList = new ArrayList<HomeworkToMark>();
		try {
			String sql = String.format("SELECT DISTINCT course_name, class_id, homework_title FROM %s " +
			"C INNER JOIN %s TP ON C.course_id = TP.course_id " + 
			"WHERE ta_id = '%s'", courseTable, taPushHomeworkTable, TAId);
			ResultSet rs = query(sql);
			while(rs.next()) {
				toMarkList.add(new HomeworkToMark(
						rs.getString("course_name"),
						rs.getString("class_id"),
						rs.getString("homework_title")));
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return toMarkList;
	}

	public static class HomeworkToMark {
		public String course_name;
		public String class_id;
		public String homework_title;
		public HomeworkToMark(String _course_name, String _class_id, String _homework_title) {
			this.course_name = _course_name;
			this.class_id = _class_id;
			this.homework_title = _homework_title;
		}
	}
	
	public static class CourseInfo {
		public String course_id;
		public String course_name;
		public String class_id;
		public String ta_name;
		public CourseInfo (String _course_id, String _course_name, String _class_id, String _ta_name){
			this.course_id = _course_id;
			this.course_name = _course_name;
			this.class_id = _class_id;
			this.ta_name = _ta_name;
		}
	}
	
	public static class HomeworkPost {
		public String course_id;
		public String homework_id;
		public String homework_title;
		public String homework_description;
		public String detail_attach_file;
		public String post_date;
		public String ddl;
		public String class_id;
		public HomeworkPost(String _course_id, String _homework_id, String _homework_title,
					String _homework_description, String _detail_attach_file, String _post_date, String _ddl, String _class_id) {
			this.course_id = _course_id;
			this.homework_id = _homework_id;
			this.homework_title = _homework_title;
			this.homework_description = _homework_description;
			this.detail_attach_file = _detail_attach_file;
			this.post_date = _post_date;
			this.ddl = _ddl;
			this.class_id = _class_id;
		}
	}

	public static class Homework {
		public String course_id;
		public String homework_id;
		public String student_id;
		public String post_date;
		public String detail_attach_file;
		public String score;
		public Homework(String _course_id, String _homework_id, String _student_id, 
				String _post_date, String _detail_attach_file, String _score) {
			this.course_id = _course_id;
			this.homework_id = _homework_id;
			this.student_id = _student_id;
			this.post_date = _post_date;
			this.detail_attach_file = _detail_attach_file;
			this.score = _score;
		}
	}
}

%>