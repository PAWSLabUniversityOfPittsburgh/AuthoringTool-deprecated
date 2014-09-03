/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.beans;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
 
public class GroupBean implements Cloneable, java.io.Serializable{

	private int id;
	private int ownerId;
	private String name = null;
    private Hashtable<Integer, Integer> users = new Hashtable<Integer, Integer>();

	public Object clone()
	{
		try {
			return(super.clone());
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
			return null;
		}
		
	}
    
	public String getName() {
		return this.name;
	}

	public int getOwnerId() {
		return this.ownerId;
	}

	public int getId() {
		return this.id;
	}
    
	public void setName(String s) {
		this.name = new String(s);
	}

	public void setOwnerId(int i) {
		this.ownerId = i;
	}

	public void setId(int i) {
		this.id = i;
	}
    
    public void setUsers (Hashtable<Integer, Integer> uu) {
        this.users.clear();
        Set ids = uu.keySet();
        Iterator i = ids.iterator();
        while (i.hasNext()) {
            int curId = ((Integer) i.next()).intValue();
            this.users.put(new Integer(curId), new Integer(uu.get(curId).intValue()));
        }
    }
    
    public boolean addUser (int i, int r) {
        if (this.users.containsKey(i)) 
            return false;
        else {
            this.users.put(new Integer (i), new Integer(r));
            return true;
        }
    }
    
    public boolean removeUser (int i) {
        return (this.users.remove(i) == null);
    }
    
    public boolean modifyUserRights (int i, int r) {
        if (this.users.containsKey(i)) {
            this.users.put(new Integer (i), new Integer(r));
            return true;
        } else
            return false;
    }
    
    public int getUserRights (Integer i) {
        return (this.users.get(i)).intValue();
    }
    
    public Hashtable<Integer, Integer> getUsers () {
        return this.users;
    }

}
