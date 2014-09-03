/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */
package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.pitt.sis.paws.authoring.beans.*;
import edu.pitt.sis.paws.authoring.data.Const;
import edu.pitt.sis.paws.utils.SqlUtil;

import java.sql.*;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.Set;
import java.util.Vector;




/**
 * 
 * Checks login. Loads userBean with details about user. 
 * 
 * Valid Requests 
 * --------------
 * LOGIN
 * LOGOUT
 * MODIFYUSERINFO
 * SWITCHGROUP
 * 
 * GETADDUSERLIST
 * GETDELETEUSERLIST
 * CREATEGROUP 
 * MODIFYGROUP
 * DELETEGROUP
 * ADDUSERTOGROUP
 * REMOVEUSERFROMGROUP
 * MODIFYUSERRIGHTS
 * 
 * CREATEUSER
 * MODIFYUSER
 * DELETEUSER
 * --------------
 */

@SuppressWarnings("serial")
public class SecurityServlet extends AbstractServlet {
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

	public void service(HttpServletRequest req, HttpServletResponse res) {
		
        this.action = req.getParameter(Const.REQ_PARAM_ACT);
        this.session = req.getSession();
        try {
            String dbdrv = this.context.getInitParameter(Const.CON_PARAM_DB_DRIVER);
            String dburl = this.context.getInitParameter(Const.CON_PARAM_WEBEX21_URL);            
            String dbuser = this.context.getInitParameter(Const.CON_PARAM_DB_USER);
            String dbpass = this.context.getInitParameter(Const.CON_PARAM_DB_PASSWORD);
            if (dbdrv == null || dburl == null || dbuser == null || dbpass == null) {
                throw new Exception("db initialization failed: loadData(" +                        
                           "driver = " + dbdrv + ", url = " + dburl +
                           ", user = " + dbuser + ", dbpass = " + dbpass);
            }
            this.dbConn = SqlUtil.getConnection(dbdrv, dburl, dbuser, dbpass);
            // Inherited method to initialize connection to database
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

		try {
            /********************************************************************/
            /************************ USER's ACTIONS ****************************/    
            /********************************************************************/ 
			if (this.action.equalsIgnoreCase("LOGIN")) {
                if (checkLogin(req))
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath()+"/home.jsp"));
                else 
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath()+"/index.html?" +
                            Const.REQ_PARAM_ACT + "=LOGINFAILED"));               
			} 
            else if (this.action.equalsIgnoreCase("LOGOUT")) {
				req.getSession().invalidate();
				res.sendRedirect(res.encodeRedirectURL(req.getContextPath()+"/index.html?" +
                            Const.REQ_PARAM_ACT + "=LOGGEDOUT"));                
            } 
            else if (this.action.equalsIgnoreCase("MODIFYUSERINFO")) {
            	//argument changed by @roya
                if (modifyUserInfo(req,res))
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYUSERINFOOK"));                 
                else 
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYUSERINFOFAILED"));            
            } 
            else if (this.action.equalsIgnoreCase("SWITCHGROUP")) {
                switchGroup();
//Sharon 2007
/*		if (this.session.getAttribute("userBean", uBean) == "example_test")
		res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/example_home.jsp"));
		else
		*/
                res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/home.jsp"));
            }
            /********************************************************************/
            /************************ SUPERUSER's ACTIONS ***********************/    
            /********************************************************************/        
                
            else if (this.action.equalsIgnoreCase("CREATEGROUP")) {
                if (createGroup())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                             "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEGROUPOK"));
                else {
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                                     "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEGROUPFAILED"));
                }
            } 
            else if (this.action.equalsIgnoreCase("MODIFYGROUP")) {
                if (modifyGroup())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                             "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYGROUPOK"));
                else {
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                                     "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYGROUPFAILED"));
                }
            }
            else if (this.action.equalsIgnoreCase("DELETEGROUP")) {
                if (deleteGroup())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                             "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=DELETEGROUPOK"));
                else {
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                                     "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=DELETEGROUPFAILED"));
                }
            }
            
			else if (this.action.equalsIgnoreCase("GETADDUSERLIST")) {
				if (getUserList())
				    res.sendRedirect(res.encodeRedirectURL(req.getContextPath()	+ "/addUser.jsp"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=GETADDUSERLISTFAILED"));
			} 
            else if (this.action.equalsIgnoreCase("GETDELETEUSERLIST")) {
				if (getUserList())
				    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/deleteUser.jsp"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=GETDELETEUSERLISTFAILED"));                
			} 
            else if (this.action.equalsIgnoreCase("MODIFYUSERRIGHTS")) {
                if (modifyUsersRights())
                       res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                                "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYUSERRIGHTSOK"));
                else {
                   res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                                    "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYUSERRIGHTSF"));
                }
            }
            
            else if (this.action.equalsIgnoreCase("ADDUSERSTOGROUP")) {
                if (addUSersToGroup())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=ADDUSERSTOGROUPOK"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=ADDUSERSTOGROUPFAILED"));
            }
            
            else if (this.action.equalsIgnoreCase("REMOVEUSERSFROMGROUP")) {
                if (removeUsersFromGroup())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=REMOVEUSERSFROMGROUPOK"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=REMOVEUSERSFROMGROUPFAILED"));
            }
            /********************************************************************/
            /************************ ADMIN's ACTIONS ***************************/    
            /********************************************************************/              
            else if (this.action.equalsIgnoreCase("CREATEUSER")) {
				if (createUser())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEUSEROK"));
				else 
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                             "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEUSERFAILED"));
			} else if (this.action.equalsIgnoreCase("DELETEUSER")) {
                if (deleteUser())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                                     "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=DELETEUSEROK"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=DELETEUSERFAILED"));                
			} else if (this.action.equalsIgnoreCase("MODIFYUSER")) {
				if (modifyUser())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                             "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYUSEROK"));
				else 
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                             "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYUSERFAILED"));
                
			}            
            else
                res.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "This Security Action is not defined");
		} catch (Exception e) {
			System.out.println("[Authoring] service(): Exception while trying to redirect");
			e.printStackTrace();
		}
    }
/********************************************************************/
/************************ USER's ACTIONS ****************************/    
/********************************************************************/    
    /**
     * checkLogin(HttpServletRequest): checks if the user with the given login and password exists in the DB
     * retreives his data and stores in the userBean attribute in the session
     * It also retrieves the list of all groups from the DB, where user participates and
     *  assignes current group to a user and puts the entire list to the groupList attribute of the session
     * For every group it retreive all its users and their rights and puts it toi the users member of GroupBean     
     * @param req - containes two parameters "login" and "password"   
     * @return true if the user was successfuly retrieved from the DB, false if an error occured
     */ 
    boolean checkLogin(HttpServletRequest req) {

        UserBean uBean = new UserBean();
        Vector<GroupBean> groupList = new Vector<GroupBean>();
        GroupBean teacherGBean = new GroupBean();

        String login = req.getParameter("login");
        String password = req.getParameter("password");
//      if no user name has been received
        if(login == null || password == null)
            return false;
       
        try {
//          retrieve user information
            String querGetUserPass = "SELECT * FROM ent_user" +
                                     " WHERE login = '" + login + "'" +                                    
                                     " AND password = '" + password+"'";      
            ResultSet rsUser = SqlUtil.executeStatement(this.dbConn, querGetUserPass);
            if (rsUser.next()) {
                uBean.setId(rsUser.getInt("ent_user.id"));
                uBean.setLogin(rsUser.getString("ent_user.login"));
                uBean.setName(rsUser.getString("ent_user.name"));
                uBean.setPassword(rsUser.getString("ent_user.password"));
                uBean.setRole(rsUser.getString("ent_user.role"));
            } else {
//              if there is no user with such name and password in the DB
                System.out.println("[Authoring] checkLogin(): Login failed for the user: " +
                                   login + " with passowrd: " + password);
                return false;
            }
            
            String querGetUserGroups = "SELECT * FROM rel_group_user, ent_group " +
                                       "WHERE rel_group_user.groupid = ent_group.id " +
                                       "AND rel_group_user.userid = " + uBean.getId();
            
            ResultSet rsGroup = SqlUtil.executeStatement(this.dbConn, querGetUserGroups);
            while(rsGroup.next()) {
//              populate group bean
                GroupBean gBean = new GroupBean();
                gBean.setId(rsGroup.getInt("ent_group.id"));
                gBean.setOwnerId(rsGroup.getInt("ent_group.ownerId"));
                gBean.setName(rsGroup.getString("ent_group.name"));
                groupList.add((GroupBean) gBean.clone());
                
                String querGetGroupUsers = "SELECT * " +
                                           "FROM rel_group_user " +
                                           "WHERE rel_group_user.groupid = " + gBean.getId();
                ResultSet rsGroupUsers = SqlUtil.executeStatement(this.dbConn, querGetGroupUsers);
                while (rsGroupUsers.next())
                    gBean.addUser(rsGroupUsers.getInt("rel_group_user.userid"), 
                                  rsGroupUsers.getInt("rel_group_user.rights"));             
                
                if (gBean.getOwnerId() == uBean.getId()) { 
                    uBean.setGroupBean(gBean);
                    uBean.setRights(rsGroup.getInt("rel_group_user.rights"));
                }
            }
            
            
            /*
             * add teacherGroup for teachers' use
             * @author : roya
             */
			String querTeachersGroup = "SELECT * FROM rel_group_user, ent_group "
					+ "WHERE rel_group_user.groupid = ent_group.id "
					+ "AND ent_group.name = 'teachers' ";

			rsGroup = SqlUtil.executeStatement(this.dbConn,querTeachersGroup);
			while (rsGroup.next()) {
				// populate group bean
				GroupBean gBean = new GroupBean();
				gBean.setId(rsGroup.getInt("ent_group.id"));
				gBean.setOwnerId(rsGroup.getInt("ent_group.ownerId"));
				gBean.setName(rsGroup.getString("ent_group.name"));
				teacherGBean = (GroupBean) gBean.clone();				
			}

            if (uBean.getGroupBean() == null) 
            {
            	if (groupList.isEmpty() == false)
            	{
                    uBean.setGroupBean(groupList.firstElement());
                    rsGroup.first();
                    uBean.setRights(rsGroup.getInt("rel_group_user.rights"));
            	}
            	else 
            		uBean.setGroupBean(teacherGBean);
            }
            
            ListIterator i = groupList.listIterator();
            boolean isAdmin = false;
            GroupBean adminGBean = null;
			while(i.hasNext()) {
				GroupBean gBean = (GroupBean) i.next();
				if (gBean.getName().equals("admin"))
				{
					adminGBean = gBean;
					isAdmin = true;
					break;
				}
			}
			
			if (isAdmin)
				this.session.setAttribute("groupBean", adminGBean);
			else
				this.session.setAttribute("groupBean", teacherGBean );
//            if(groupList.size() == 0) {
//                System.out.println("[Authoring] checkLogin(): No group is found for " +
//                        "the user " + login);
//                return false;
//            }    
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        
        this.session.setAttribute("userBean", uBean);
        this.session.setAttribute("groupList", groupList);
        

        return true;
    }
  
/**
 * switchGroup(): changes groupBean member of userBean to newGroupBean 
 * modifys userBean in the session, removes newGroupBean from the session
 * @return nothing
 */ 
    private void switchGroup() {        
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        GroupBean newGroupBean = (GroupBean) this.session.getAttribute("newGroupBean");
        uBean.setGroupBean(newGroupBean);
        uBean.setRights(newGroupBean.getUsers().get(uBean.getId()));
        this.session.setAttribute("userBean", uBean);
        this.session.removeAttribute("newGroupBean");
    }    
    
/**
 * modifyUserInfo(): get the userBean and newUserInfo from the session, changes userBean's 
 * password and name and stores new info in the DB
 * Updates userBean in the session, remove newUserInfo from the session
 * @param res 
 * @param req 
 * @return true if the password has been changed successfully, false if an error occured
 */ 
	private boolean modifyUserInfo(HttpServletRequest req, HttpServletResponse res) {
		UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        //@Roya changed this part due to null pointer exception  
		//UserBean newUserInfo = (UserBean) this.session.getAttribute("newUserInfo");
        //this.session.removeAttribute("newUserInfo");
//        uBean.setPassword(newUserInfo.getPassword());
//        uBean.setName(newUserInfo.getName());
		uBean.setLogin(req.getParameter("login"));
		uBean.setPassword(req.getParameter("password"));
		uBean.setName(req.getParameter("name"));
		String querUpdateUserInfo =	"Update ent_user " +									"SET password = \"" + uBean.getPassword() +
                                    "\", name = \"" + uBean.getName() +									"\" WHERE id = " + uBean.getId();		
		try {
			SqlUtil.executeUpdate(this.dbConn, querUpdateUserInfo);
		} catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        this.session.setAttribute("userBean", uBean);
		return true;
	}

    
/********************************************************************/
/************************ SUPERUSER's ACTIONS ***********************/    
/********************************************************************/   
  
/**
 * getUserList(): retrieves the list of all users form the DB and put them as a Vector of UserBeans
 * to the userList attribute of the session   
 * @return true if the user lust was retreived from the DB, false if an error occured
 */     
	private boolean getUserList() {
        String querUserList = "SELECT * FROM user";
        Vector<UserBean> userList = new Vector<UserBean>();        
        try {
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querUserList);
            while (rs.next()) {
                UserBean uBean = new UserBean();
                uBean.setId(rs.getInt("id"));
                uBean.setName(rs.getString("name"));
                uBean.setLogin(rs.getString("login"));
                uBean.setRole(rs.getString("role"));
                userList.add(uBean);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        this.session.setAttribute("userList", userList);
        System.out.println("[Authoring] getUserList(): " + userList.size() + "users");
        return true;
    }
    
    /**
     * modifyUsersRights(): retrieves new rights of users for the current gtoup of the current user 
     * as a session attribute modifyUsersRights and modifys users member of the groupBean memeber 
     * of the current userBean
     * save new users' right to the usergroupmap table of the DB
     * modifys userBean and groupList atributes of the session
     * remove newUsersRights attribute form the session  
     * @return true if the user lust was retreived from the DB, false if an error occured
     */ 
    private boolean modifyUsersRights() {
//      modify user rights for the current group of userBean             
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        Hashtable<Integer, Integer> newUsersRights = (Hashtable<Integer, Integer>) this.session.getAttribute("newUsersRights");
        this.session.removeAttribute("newUserRights");
        uBean.getGroupBean().setUsers(newUsersRights);
//      modify user rights for the group from the groupList            
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("groupList");
        ListIterator i = groupList.listIterator();
        while (i.hasNext())
            if (((GroupBean) i.next()).getId() == uBean.getGroupBean().getId()) {
                ((GroupBean) i.previous()).setUsers(newUsersRights);
                i.next();
            }
        
        Set ids = newUsersRights.keySet();
        try {           
            Iterator j = ids.iterator();
            while (j.hasNext()) {
                int curId = ((Integer) j.next()).intValue();
                String querUpdateGroup = "MODIFY usergroupmap";
                querUpdateGroup = querUpdateGroup.concat(" SET rights = " + 
                                                  ((Integer) newUsersRights.get(curId)).intValue());
                querUpdateGroup = querUpdateGroup.concat(" WHERE userid = " + curId);
                querUpdateGroup = querUpdateGroup.concat(" AND groupid = " + uBean.getGroupBean().getId());
                SqlUtil.executeUpdate(dbConn, querUpdateGroup);
            }
        } catch (Exception e) {          
            e.printStackTrace();
            return false;
        }
        this.session.setAttribute("userBean", uBean);
        this.session.setAttribute("groupList", groupList);
        return true;
    }

    private boolean createGroup() {
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        GroupBean gBean = (GroupBean) this.session.getAttribute("newGroupBean");
        this.session.removeAttribute("newGroupBean");
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("groupList");
               
        try {
            String querInsertGroup = "INSERT INTO group (name, ownerId) VALUES (";
            querInsertGroup = querInsertGroup.concat(gBean.getName() + ", ");
            querInsertGroup = querInsertGroup.concat(uBean.getId() + ", ");
            SqlUtil.executeUpdate(this.dbConn, querInsertGroup);
            System.out.println("[Authoring] group " + gBean.getName() + "has been created");
            String querSelectGroupId = "SELECT max(id) FROM group";
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querSelectGroupId);
            if (rs.next())
                gBean.setId(rs.getInt(1));
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception while saving group to database");
            this.session.removeAttribute("newGroupBean");
            return false;
        }
        groupList.add(gBean); 
        this.session.setAttribute("groupList", groupList);
        return true;
    }
    
    public boolean modifyGroup() {
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        GroupBean gBean = (GroupBean) this.session.getAttribute("modifyGroupBean");
        this.session.removeAttribute("modifyGroupBean");
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("groupList");
//      modify groupList        
        ListIterator i = groupList.listIterator();
        while (i.hasNext())
            if (((GroupBean) i.next()).getId() == gBean.getId()) {
                groupList.setElementAt(gBean, groupList.indexOf((GroupBean) i.previous()));
                break;
            }
//      modify DB        
        try {              
            String querUpdateGroup = "MODIFY group ";
            querUpdateGroup = querUpdateGroup.concat("SET name = " + gBean.getName());
            querUpdateGroup = querUpdateGroup.concat(", ownerId = " + gBean.getOwnerId()); 
            querUpdateGroup = querUpdateGroup.concat(" WHERE id = " + gBean.getId());            
            SqlUtil.executeUpdate(this.dbConn, querUpdateGroup);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception while saving group to database");
            this.session.removeAttribute("modifyGroupBean");
            return false;
        }
        this.session.setAttribute("groupList", groupList);
        return true;
        
    }
    
    private boolean deleteGroup() {
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        int deleteGroupId = (Integer) this.session.getAttribute("deleteGroupId");
        this.session.removeAttribute("deleteGroupId");
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("groupList");

        String querDeleteUserGroupMap = "DELETE FROM usergroupmap WHERE groupid = " + deleteGroupId;
        String querDeleteGroup = "DELETE FROM group WHERE id = " + deleteGroupId;

        try {
            SqlUtil.executeUpdate(this.dbConn, querDeleteUserGroupMap);
            SqlUtil.executeUpdate(this.dbConn, querDeleteGroup);
            
            ListIterator i = groupList.listIterator();
            while (i.hasNext())
                if (((GroupBean) i.next()).getId() == deleteGroupId) {
                    groupList.remove((GroupBean) i.previous());
                    break;
                }            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        this.session.setAttribute("groupList", groupList);
        return true;
    }

    private boolean removeUsersFromGroup() {
//      modify users for the current group of userBean             
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        Vector<Integer> removeUsersId = (Vector<Integer>) this.session.getAttribute("removeUsersId");
        this.session.removeAttribute("removeUsersId");
        ListIterator i = removeUsersId.listIterator();
        while (i.hasNext())
            if (uBean.getGroupBean().getUsers().contains((Integer) i.next())) {
                uBean.getGroupBean().removeUser(((Integer) i.previous()).intValue());
                i.next();
            }
//      modify users for the group from the groupList            
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("groupList");
        i = groupList.listIterator();
        while (i.hasNext())
            if (((GroupBean) i.next()).getId() == uBean.getGroupBean().getId()) {
                ((GroupBean) i.previous()).setUsers(uBean.getGroupBean().getUsers());
                i.next();
            }
        
        try {           
            i = removeUsersId.listIterator();
            while (i.hasNext()) {
                String querDeleteUserFromGroup = "DELETE FROM usergroupmap" +
                                                 " WHERE userid = " + ((Integer) i.next()).intValue();                
                SqlUtil.executeUpdate(dbConn, querDeleteUserFromGroup);
            }
        } catch (Exception e) {          
            e.printStackTrace();
            return false;
        }
        this.session.setAttribute("userBean", uBean);
        this.session.setAttribute("groupList", groupList);
        return true;
    }
    
    private boolean addUSersToGroup() {

//      modify users for the current group of userBean             
        Hashtable<Integer, Integer> newUsersRights = (Hashtable) this.session.getAttribute("newUsersRights");
        this.session.removeAttribute("newUsersRights");        
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");        
        uBean.getGroupBean().setUsers(newUsersRights);
        
//      modify users for the group from the groupList            
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("groupList");
        ListIterator i = groupList.listIterator();
        while (i.hasNext())
            if (((GroupBean) i.next()).getId() == uBean.getGroupBean().getId()) {
                ((GroupBean) i.previous()).setUsers(uBean.getGroupBean().getUsers());
                i.next();
            }
        
        Set ids = newUsersRights.keySet();
        try {           
            Iterator j = ids.iterator();
            while (j.hasNext()) {
                int curId = ((Integer) j.next()).intValue();
                String querAddUserToGroup = "INSERT INTO usergroupmap " +
                                            "(userid, groupid, rights) " +
                                            "VALUES (";
                querAddUserToGroup = querAddUserToGroup.concat(curId + ", ");
                querAddUserToGroup = querAddUserToGroup.concat(uBean.getGroupBean().getId() + ", ");
                querAddUserToGroup = querAddUserToGroup.concat(newUsersRights.get(curId) + ")");
                SqlUtil.executeUpdate(dbConn, querAddUserToGroup);
            }
            this.session.setAttribute("userBean", uBean);
            this.session.setAttribute("groupList", groupList);
            return true;
        } catch (Exception e) {          
            e.printStackTrace();
            return false;
        }
    }
    
/********************************************************************/
/************************ ADMIN's ACTIONS ***************************/    
/********************************************************************/ 
/**
 * createUser(): retrieves newUserBean attribute from the session and saves it to the DB
 * removes newUserBean from the session
 * @return true if the user was successfuly saved in the DB, false if an error occured
 * 
 */ 
	private boolean createUser() {
		try {
			String querGetUserList = "SELECT login FROM user";
			ResultSet rs = SqlUtil.executeStatement(this.dbConn, querGetUserList);
//          check if a user with such name is already in DB
			UserBean newUserBean = 	(UserBean) this.session.getAttribute("newUserBean");
            this.session.removeAttribute("newUserBean");
			while (rs.next()) {
				if(rs.getString("login").equals(newUserBean.getLogin())) {
					System.out.println("[Authoring] saveUser(): user with login " +
					                   newUserBean.getLogin() + "already exists in the DB");                            
					return false;
				}
			}
//          insert a user in DB
			String querInsertUser = "INSERT INTO user " +
                                    "(login, name, password, role) " +
                                    " VALUES(";
            querInsertUser=querInsertUser.concat(newUserBean.getLogin() + ", ");
            querInsertUser=querInsertUser.concat(newUserBean.getName() + ", ");
            querInsertUser=querInsertUser.concat(newUserBean.getPassword() + ", ");
            querInsertUser=querInsertUser.concat(newUserBean.getRole() + ")");				
            SqlUtil.executeUpdate(this.dbConn, querInsertUser);
            System.out.println("[Authoring] createUser(): user " + newUserBean.getLogin() + 
                               "has been added to the DB");
		}catch(Exception e) {
			System.out.println("[Authoring] createUser(): Error");	
			e.printStackTrace();
			return false;
	 	 }
		 return true;
	}
    
    /**
     * modifyUser(): retrieves newUserBean attribute from the session , and modify it in the DB
     * removes newUserBean from the session
     * @return true if the user was successfuly saved in the DB, false if an error occured     * 
     */   
    private boolean modifyUser() {
        UserBean uBean = (UserBean) session.getAttribute("newUserBean");
        this.session.removeAttribute("newUserBean");
        try {            
            String querUpdateUser = "MODIFY user SET";
            querUpdateUser = querUpdateUser.concat(" login = " + uBean.getLogin());
            querUpdateUser = querUpdateUser.concat(" name = " + uBean.getName());
            querUpdateUser = querUpdateUser.concat(", password = " + uBean.getPassword());
            querUpdateUser = querUpdateUser.concat(", role = " + uBean.getRole());
            querUpdateUser = querUpdateUser.concat(" WHERE id = " + uBean.getId());
            SqlUtil.executeUpdate(this.dbConn, querUpdateUser);                
            System.out.println("[Authoring] modifyUser(): user " + uBean.getId() + 
                               "has been modified");
        } catch(Exception e) {
            System.out.println("[Authoring] modifyUser(): Error");  
            e.printStackTrace();
            return false;
        }
        return true;        
    }

    /**
     * deleteUser(): get the deleteUserId from the session delete user from the session and 
     * deletes corresponding tuples in ther DB from the user and usergroupmap tables
     * modifys corrsponding tuples in quiz, question and concept tables (authorid = 1 "deleted user")
     * removes deleteUserId attribute from the session 
     * @return true if the user has been deleted successfully, false if an error occured
     */
    
    private boolean deleteUser() {        
        Integer deleteUserId = null;
        String tmp = (String) this.session.getAttribute("deleteUserId");
        this.session.removeAttribute("deleteUserId");
        try {
            deleteUserId = new Integer (tmp);
        } catch (NumberFormatException e){
            System.out.println("[Authoring] deleteUser(): Incorrect user id");
            return false;
        }
        
//      modify and save groupList        
        Vector<GroupBean> groupList = (Vector<GroupBean>) this.session.getAttribute("grouplList");
        ListIterator i = groupList.listIterator();
        while (i.hasNext())
            if (((GroupBean) i.next()).getUsers().containsKey(deleteUserId)) {
                ((GroupBean) i.previous()).removeUser(deleteUserId.intValue());
                i.next();
            }
        
//      modify Database        
        String querDeleteUserGRoup = "DELETE FROM usergroupmap WHERE userid = " + deleteUserId.intValue();
        String querDeleteUser = "DELETE FROM user WHERE id = " + deleteUserId.intValue();
        String querModifyQuiz = "MODIFY quiz SET authorid = 1 WHERE authorid = " + deleteUserId.intValue();
        String querModifyQuestion = "MODIFY question SET authorid = 1 WHERE authorid = " + deleteUserId.intValue();
        String querModifyConcept = "MODIFY concept SET authorid = 1 WHERE authorid = " + deleteUserId.intValue();
        System.out.println("[Authoring] deleteUser(): " + deleteUserId.intValue()); 
        try {
            SqlUtil.executeUpdate(this.dbConn, querDeleteUserGRoup);
            SqlUtil.executeUpdate(this.dbConn, querModifyQuiz);
            SqlUtil.executeUpdate(this.dbConn, querModifyQuestion);
            SqlUtil.executeUpdate(this.dbConn, querModifyConcept);
            SqlUtil.executeUpdate(this.dbConn, querDeleteUser);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        this.session.setAttribute("groupList", groupList); 
        return true;
    }
    
 }
