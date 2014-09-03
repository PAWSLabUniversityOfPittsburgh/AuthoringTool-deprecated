/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky
 * Email : sas15@pitt.edu
 */

package edu.pitt.sis.paws.authoring.beans;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

public class ConceptBean implements java.io.Serializable {
    int id;
    int authorId;
    String title = null;
    int typeId;
    String description = null;
    int parentId;
    
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
    
    public int getId() {
        return this.id;
    }

    public String getTitle() {
        return this.title;
    }

    public void setAuthorId(int i) {
        this.authorId = i;
    }

    public void setDescription(String s) {
        this.description = new String(s);
    }
    
    public void setId(int i) {
        this.id = i;
    }

    public void setTitle(String s) {
        this.title = new String(s);
    }

    public void setParentId(int cid) {
        this.parentId = cid;
    }
    
    public int getParentId() {
        return this.parentId;
    }

    public int getTypeId() {
        return this.typeId;
    }
    
    public void setTypeId(int i) {
       this.typeId = i;
    }
    
 }
