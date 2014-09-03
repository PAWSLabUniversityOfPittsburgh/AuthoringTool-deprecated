/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.beans;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;


public class QuizBean implements java.io.Serializable{

	private int id;
	private int authorId;
	private int groupId;
	private int permission;
	private String title;
	private URL url;
	private String description;
	private Date modified;
//  Hashtable containes all questions of the quiz. 
//  index is the question postion, vlaue is the question itself      
	private Hashtable<Integer, QuestionBean> questions = new Hashtable<Integer, QuestionBean>();
    
    public Object clone()
    {
        try {
            return(super.clone());
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
            return null;
        }
        
    }
    	
	public int getAuthorId() {
		return this.authorId;
	}

	public String getDescription() {
		return this.description;
	}
	
	public URL getUrl() {
		return this.url;
	}

	public int getId() {
		return this.id;
	}

	public Date getModified() {
		return this.modified;
	}

	public int getPermission() {
		return this.permission;
	}

	public String getTitle() {
		return this.title;
	}

	public void setAuthorid(int i) {
        this.authorId = i;
	}

	public void setDescription(String s) {
        this.description = new String(s);
	}
	
	public void setUrl(String s) {
		try {
            this.url = new URL(s);
        } catch (MalformedURLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
	}

	public void setId(int i) {
        this.id = i;
	}

	public void setModified(Date d) {
        this.modified = new Date (d.getTime());
	}

	public void setPermission(int i) {
        this.permission = i;
	}

	public void setTitle(String s) {
        this.title = new String(s);
	}

    public Hashtable<Integer, QuestionBean> getQuestions () {
        return this.questions;
    }

	public void setQuestions(Hashtable<Integer, QuestionBean> qq) {
        this.questions.clear();
        Set positions = qq.keySet();
        Iterator i = positions.iterator();
        while (i.hasNext()) {
            int curPos = ((Integer) i.next()).intValue();
            this.questions.put(new Integer(curPos), (QuestionBean) qq.get(curPos).clone());
        }       
    }

	public boolean addQuestion(int pos, QuestionBean ques) {
        if (this.questions.containsKey(pos)) 
            return false;
        else {
            this.questions.put(new Integer (pos), (QuestionBean) ques.clone());
            return true;
        }
    }
	
	public void removeQuestion(QuestionBean q) {		
        this.questions.remove(q);
	}
	
	public int getGroupId() {
		return this.groupId;
	}

	public void setGroupId(int i) {
        this.groupId = i;
	}

}
