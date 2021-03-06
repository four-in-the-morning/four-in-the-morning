package FourInTheMorning;

import java.io.*;
import java.util.*;
import java.sql.*;

public class MySQLHelper {

	private static final String databaseHostIp = "sunshining.cloudapp.net";
	private static final String databaseHostPort = "3306";
	private static final String databaseName = "13354146_PROJECT";
	private static final String databaseUserName = "user";
	private static final String databaseUserPassword = "Crash";

	private static final String accountTable = "USER_WEB";
	private static final String courseTable = "COURSE";
	private static final String classTable = "COURSE_CLASS";
	private static final String clsStuTable = "CLASS_COURSE_STUDENT";
	private static final String taPushHomeworkTable = "ADD_HOMEWORK";
	private static final String stuSubmitHomeworkTable = "STUDENT_HOMEWORK";

	/*
	 *	描述：获取数据库连接对象，失败返回null
	 *	输入：空
	 *	输出：数据库连接对象Connection
	 */
	private static Connection getConnection() {
		String connectString = "jdbc:mysql://" + databaseHostIp 
								+ ":" + databaseHostPort 
								+ "/" + databaseName 
								+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(connectString, databaseUserName, databaseUserPassword);
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
			java.util.Date date = new java.util.Date(); // java.util.Date 和 java.sql.Date 重复
	 		Timestamp timestamp = new Timestamp(date.getTime());
			String sql = String.format("SELECT * FROM (" 
				+ "(%s C1 INNER JOIN %s C2 ON C1.class_id = C2.class_id) " 
				+ "INNER JOIN %s A ON A.course_id = C2.course_id) " 
				+ "WHERE C1.student_id = '%s' AND A.ddl > '%s'",
				clsStuTable, courseTable, taPushHomeworkTable, stuId, timestamp.toString());
			//System.out.println("\n" + sql + "\n");
			ResultSet rs = query(sql);
			while (rs.next()) {
				homeworkPostList.add(new HomeworkPost(
					rs.getString("course_id"), 
					rs.getString("homework_id"), 
					rs.getString("homework_title"), 
					rs.getString("homework_description"), 
					rs.getString("detail_attach_file"), 
					rs.getString("post_date"), 
					rs.getString("ddl")));
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
			String sql = String.format("SELECT detail_attach_file FROM %s C1" 
				+ " INNER JOIN %s S ON C1.course_id=S.course_id " 
				+ "WHERE C1.class_id='%s' AND S.homework_id='%s'",
				courseTable, stuSubmitHomeworkTable, classId, hwId);
			System.out.println("\n" + sql + "\n");
			ResultSet rs = query(sql);
			while (rs.next()) {
				fileSrcList.add(new String(rs.getString("detail_attach_file")));
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

	public static class HomeworkPost {
		public String course_id;
		public String homework_id;
		public String homework_title;
		public String homework_description;
		public String detail_attach_file;
		public String post_date;
		public String ddl;
		public HomeworkPost(String _course_id, String _homework_id, String _homework_title,
					String _homework_description, String _detail_attach_file, String _post_date, String _ddl) {
			this.course_id = _course_id;
			this.homework_id = _homework_id;
			this.homework_title = _homework_title;
			this.homework_description = _homework_description;
			this.detail_attach_file = _detail_attach_file;
			this.post_date = _post_date;
			this.ddl = _ddl;
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
