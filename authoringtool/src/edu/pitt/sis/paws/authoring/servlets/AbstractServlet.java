/*
 * Date  : May, 15, 2006
 * Author: Sergey Sosnovsky
 * Email : sas15@pitt.edu
 */
package edu.pitt.sis.paws.authoring.servlets;

import java.sql.Connection;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;

/**
 * 
 * Base class for all servlets that want to use the database
 * 
 */
public abstract class AbstractServlet extends HttpServlet {

    protected ServletContext context;
    protected String action;
    protected Connection dbConn;
    protected HttpSession session;
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.context = getServletContext();
    }    
}
