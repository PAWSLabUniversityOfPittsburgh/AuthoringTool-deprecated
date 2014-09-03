/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.data;

public class Const {
    
/*  context parameters */
//  db parameters
    public static final String CON_PARAM_DB_DRIVER = "db.driver";
    public static final String CON_PARAM_WEBEX21_URL = "db.webexURL";
    public static final String CON_PARAM_TREEMAP_URL = "db.treemapURL";
    public static final String CON_PARAM_DB_USER = "db.user";
    public static final String CON_PARAM_DB_PASSWORD = "db.passwd";

/*  request parameters */    
//  db parameters
    public static final String REQ_PARAM_ACT ="action";
    
/*  session parameters */
   

/*  rigths, roles and permissions */
//  values of role column of user table 
    public static final String ROLE_USER = "user";
    public static final String ROLE_SUPERUSER = "superuser";
    public static final String ROLE_ADMIN = "admin";
    
//  values of right column of usergroupmap table     
    public static final int RIGHTS_NO = 0;
    public static final int RIGHTS_YES = 1;    
    
//  values of permision column of quiz and question table 
    public static final int PERM_NRNW = 00; // no rights
    public static final int PERM_GRNW = 10; // only group only reads
    public static final int PERM_ARNW = 11; // everyone only reads 
    public static final int PERM_NRGW = 20; // only group only writes
    public static final int PERM_GRGW = 30; // only group reads and writes
    public static final int PERM_ARGW = 31; // group reads and writes others only read 
    public static final int PERM_NRAW = 22; // everyone only writes
    public static final int PERM_GRAW = 32; // group reads and writes others only write
    public static final int PERM_ARAW = 33; // everyone reads and writes   
    
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
