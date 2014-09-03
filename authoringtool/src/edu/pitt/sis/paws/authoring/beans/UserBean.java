/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.beans;

import edu.pitt.sis.paws.authoring.data.Const;



/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

//TODO Set setter and getter restrictions on read only attribs.
public class UserBean implements Cloneable, java.io.Serializable{

	private int id;	
	private String name = null;
    private String login = null;
	private String password = null;
	private String role = null;
    private GroupBean groupBean = null;
    private int rights; //Rights of the user for the current group
	
	public Object clone() {
		try {
			return(super.clone());
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
			return null;
		}	
	}

	public int getId() {
		return this.id;
	}

	public String getPassword() {
		return this.password;
	}

	public String getRole() {
		return this.role;
	}

	public String getName() {
		return this.name;
	}
    
    public String getLogin() {
        return this.login;
    }

	public void setId(int i) {
        this.id = i;
	}

	public void setPassword(String s) {		
        this.password = new String(s);
	}

	public void setRole(String s) {
        this.role = new String(s);
	}

	public void setName(String s) {
        this.name = new String(s);
	}
    
    public void setLogin(String s) {
        this.login =new String(s);
    }

	public boolean isAdmin() {
		if(role.equals(Const.ROLE_ADMIN))
			return true;
		else
			return false;
	}

	public boolean isSuperUser() {
		if(this.role.equals(Const.ROLE_SUPERUSER))
				return true;
			else
				return false;
	}
    

    public boolean isGroupOwner(GroupBean gBean) {
        if(gBean.getOwnerId() == this.id)
            return true;
        else
            return false;
    }
    
    public void setGroupBean(GroupBean gBean) {
        this.groupBean = (GroupBean) gBean.clone();
    }
    
    public GroupBean getGroupBean() {
        return this.groupBean;
    }
    
    public int getRights() {
        return rights; 
    }
    
    public void setRights(int i) {
        rights = i;
    }
}
