package api;

public class Constants {
	
	
	public static final class DB{
		public static final String DRIVER = "com.mysql.jdbc.Driver";
		public static final String WEBEX_URL = "jdbc:mysql://localhost:3306/webex21";
		public static final String TREEMAP_URL = "jdbc:mysql://localhost:3306/treemap";
		public static final String GUANGIE_URL = "jdbc:mysql://localhost:3306/guanjie";
		public static final String UM2_URL = "jdbc:mysql://localhost:3306/um2";


		public static final String USER = "root";
		public static final String PASSWORD = "123456";		
	}
	
	public static final class PATH 
	{
		public static final String CLASS_RELATIVE_PATH = "/WEB-INF/class/";
		public static final String RESOURCES_RELATIVE_PATH_JAVA = "./WEBContent/WEB-INF/resources/";
		public static final String RESOURCES_RELATIVE_PATH_WEB = "/WEB-INF/resources/";
	}	
	
	public static final String RELATED_WEIGHT = "Related";
	public static final String STRONGLY_RELATED_WEIGHT = "Strongly related";
	public static final String WEAKLY_RELATED_WEIGHT = "Weakly related";

	
	public static final String[] WEIGHTS = {RELATED_WEIGHT,STRONGLY_RELATED_WEIGHT,WEAKLY_RELATED_WEIGHT};
}
