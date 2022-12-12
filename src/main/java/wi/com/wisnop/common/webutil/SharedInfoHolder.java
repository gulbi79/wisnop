package wi.com.wisnop.common.webutil;

public class SharedInfoHolder {

	private static final long serialVersionUID = 1L;
	
	private static String jobType;
	private static StringBuffer jobSql = new StringBuffer();

	public static String getJobType() {
		return jobType;
	}

	public static void setJobType(String jobType) {
		SharedInfoHolder.jobType = jobType;
	}

	public static StringBuffer getJobSql() {
		return jobSql;
	}
	
	public static void setJobSql(String jobSql) {
		SharedInfoHolder.jobSql.append(jobSql);
	}
	
	public static void setInitJobSql() {
		SharedInfoHolder.jobSql = new StringBuffer();
	}
}
