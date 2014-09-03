/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.beans;

import java.util.Date;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

public class QuestionBean implements java.io.Serializable{
	
	private int id;
	private int authorId;
	private int groupId;
	private int permission;
    private Date modified = null; 
	private int minRandom;
	private int maxRandom;
	private float difficulty;
	private float complexity;
	private String title = null;
	private String description = null;
	private String code = null;
	private String answerType = null;
	private String targetVar = null;
    private Vector<ConceptBean> concepts = new Vector<ConceptBean>();
	
    public Object clone()
    {
        try {
            return(super.clone());
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
            return null;
        }
        
    }    
    
	public String getAnswerType() {
		return this.answerType;
	}

	public int getAuthorId() {
		return this.authorId;
	}

	public String getCode() {
		return this.code;
	}

	public float getComplexity() {
		return this.complexity;
	}

	public String getDescription() {
		return this.description;
	}

	public float getDifficulty() {
		return this.difficulty;
	}

	public int getId() {
		return this.id;
	}

	public int getMaxRandom() {
		return this.maxRandom;
	}

	public int getMinRandom() {
		return this.minRandom;
	}

	public int getPermission() {
		return this.permission;
	}

	public String getTargetVar() {
		return this.targetVar;
	}

	public String getTitle() {
		return this.title;
	}

	public void setAnswerType(String s) {
        this.answerType = new String(s);
	}

	public void setAuthorId(int i) {
        this.authorId = i;
	}

	public void setCode(String s) {
        this.code = new String(s);
	}

	public void setComplexity(float f) {
        this.complexity = f;
	}

	public void setDescription(String s) {
        this.description = new String(s);
	}

	public void setDifficulty(float f) {
        this.difficulty = f;
	}

	public void setId(int i) {
        this.id = i;
	}

	public void setMaxRandom(int i) {
        this.maxRandom = i;
	}

	public void setMinRandom(int i) {
        this.minRandom = i;
	}

	public void setPermission(int i) {
        this.permission = i;
	}

	public void setTargetVar(String s) {
        this.targetVar = new String(s);
	}

	public void setTitle(String s) {
        this.title = new String(s);
	}
	public int getGroupId() {
		return this.groupId;
	}

	public void setGroupId(int i) {
        this.groupId = i;
	}
    
    public void setModified(Date d) {
        this.modified = new Date (d.getTime());        
    }
    
    public void setModified(Long d) {
        this.modified = new Date (d);        
    }
    
    public Date getModified(Date d) {
        return this.modified;        
    }
    
    public Vector<ConceptBean> getConcepts() {
        return this.concepts;
    }
    
    public void setConcepts(Vector<ConceptBean> cc) {
        this.concepts.clear();
        Iterator i = cc.iterator();
        while (i.hasNext())
            this.concepts.add((ConceptBean)((ConceptBean) i.next()).clone());
    }
    
    public boolean addConcept(ConceptBean c) {
        if (this.concepts.contains(c))
            return false;
        else {
            this.concepts.add((ConceptBean) c.clone());
            return true;
        }
        
    }
}
