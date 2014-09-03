package edu.pitt.sis.paws.authoring.servlets;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSession;

public class qpSessionListener implements javax.servlet.http.HttpSessionAttributeListener 
{
	private HttpSession session = null;
	private String name = null;
	private String cl = null;

	public void attributeAdded(HttpSessionBindingEvent event)
	{
		name = event.getName();
		cl = event.getSource().getClass().toString();
		session = event.getSession();
//		System.out.println("qpSessionListener: attribute " + name + " added by " + cl);
	}

	public void attributeRemoved(HttpSessionBindingEvent event)
	{
		name = event.getName();
		session = event.getSession();
		cl = event.getSource().getClass().toString();
//		System.out.println("qpSessionListener: attribute " + name + " removed by " + cl);
	}

	public void attributeReplaced(HttpSessionBindingEvent event)
	{	
		name = event.getName();
		session = event.getSession();
		cl = event.getSource().getClass().toString();
//		System.out.println("qpSessionListener: attribute " + name + " replaced by " + cl);
	}
}