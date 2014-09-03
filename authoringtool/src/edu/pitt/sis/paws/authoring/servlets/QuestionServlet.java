/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */
 
 
package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.pitt.sis.paws.authoring.beans.ConceptBean;
import edu.pitt.sis.paws.authoring.beans.GroupBean;
import edu.pitt.sis.paws.authoring.beans.QuestionBean;
import edu.pitt.sis.paws.authoring.beans.QuizBean;
import edu.pitt.sis.paws.authoring.beans.UserBean;
import edu.pitt.sis.paws.authoring.data.Const;
import edu.pitt.sis.paws.utils.SqlUtil;


/**
 *handles all requests pertaining to questions
 *
 * Valid Requests 
 * --------------
 * GETMODIFYQUESTIONLIST	// from authoring.jsp when click on ModifyQuestion
 * GETDELETEQUESTIONLIST
 * GETADDQUESTIONLIST
 * 
 * CREATEQUESTION 		// from modifyQuesParameters.jsp when new question is edited
 * MODIFYQUESTION		// from modifyQuesParameters.jsp when existing question is edited
 * DELETEQUESTION 
 * --------------
 * 
 */
@SuppressWarnings("serial")
public class QuestionServlet extends AbstractServlet {
    Vector<ConceptBean> conceptList = new Vector<ConceptBean>();
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        Iterator i = loadConcepts(this.dbConn).iterator();
        while (i.hasNext())
            this.conceptList.add((ConceptBean) ((ConceptBean) i.next()).clone());
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
            if (this.action.equalsIgnoreCase("CREATEQUESTION")) {
                if (createQuestion())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEQUESTIONOK"));          
                else 
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEQUESTIONFAILED"));          
            } else if (this.action.equalsIgnoreCase("MODIFYQUESTION")) {
				if (modifyQuestion())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYQUESTIONOK"));                 
				else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYQUESTIONFAILED"));          
			
			} else if (this.action.equalsIgnoreCase("DELETEQUESTION")) {
                if (deleteQuestion())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath()+"/servletResponse.jsp?" +
                            Const.REQ_PARAM_ACT + "=DELETEQUESTIONOK"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/servletResponse.jsp?" +
                            Const.REQ_PARAM_ACT + "=DELETEQUESTIONFAILED"));
            } else if (this.action.equalsIgnoreCase("GETADDQUESLIST")) {
                if (getAddQuestionList())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/addQuestions.jsp?referrer=QuestionServlet"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/servletResponse.jsp?" +
                            Const.REQ_PARAM_ACT + "=GETADDQUESTIONLISTFAILED")); 
            } else if (this.action.equalsIgnoreCase("GETMODIFYQUESTIONLIST")) {
                if (getModifyQuestionList()) 
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/displayModifyQuesList.jsp"));
                else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + "/servletResponse.jsp?" +
                            Const.REQ_PARAM_ACT + "=GETMODIFYQUESTIONLISTFAILED"));                
            } else if (this.action.equalsIgnoreCase("GETDELETEQUESTIONLIST")) {
				if (getModifyQuestionList())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/displayDeleteQuesList.jsp"));
				else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() +
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=GETDELETEQUESTIONLISTFAILED"));
			} else
				res.sendError(HttpServletResponse.SC_BAD_REQUEST,
					"Action Requested from QuestionServlet is not defined.");					
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    
    static public Vector<ConceptBean> loadConcepts(java.sql.Connection conn) {
        Vector<ConceptBean> cc = new Vector<ConceptBean>();
        String querGetConcepts = "SELECT * FROM concept";
        try {
            ResultSet rs = SqlUtil.executeStatement(conn, querGetConcepts);
            while (rs.next()) {
                ConceptBean c = new ConceptBean();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setAuthorId(rs.getInt("authorId"));
                c.setDescription(rs.getString("desc"));
                c.setTypeId(rs.getInt("typeId"));
                String querGetParent = "SELECT sourceId FROM relation " +
                                       "WHERE targetId = " + c.getId();
                ResultSet rsParent = SqlUtil.executeStatement(conn, querGetParent);
                if (rsParent.next())
                    c.setParentId(rsParent.getInt("sourceId"));
                else // root conceptId
                    c.setParentId(0);
                cc.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] loadConcepts(): " +
                               "failed to load concepts from the DB");
        }
        return cc;
    }

    /**
     * static QuestionBean getQuestion(java.sql.Connection dbConn, int quesId):
     * retreives a spesific question from the databes  
     * @param dbConn - connection to the database 
     * @param quesId - the id of a question in the DB  
     * @return question as QeustionBean or null if failed 
     */ 
    static public QuestionBean getQuestion(java.sql.Connection conn, int quesId) {
        String querGetQuestion = "SELECT * FROM question WHERE id = " + quesId;
        QuestionBean quesBean = new QuestionBean();
        try {
            ResultSet rs = SqlUtil.executeStatement(conn, querGetQuestion);
            if (rs.next()) {    
                quesBean.setId(rs.getInt("id"));
                quesBean.setAuthorId(rs.getInt("authorid"));
                quesBean.setPermission(rs.getInt("permission"));
                quesBean.setTitle(rs.getString("title"));
                quesBean.setDescription(rs.getString("desc"));            
                Clob codeClob = rs.getClob("code");
                quesBean.setCode(codeClob.getSubString(1, (int)codeClob.length()));            
                quesBean.setMinRandom(rs.getInt("minrandom"));
                quesBean.setMaxRandom(rs.getInt("maxrandom"));
                quesBean.setAnswerType(rs.getString("answertype"));
                quesBean.setTargetVar(rs.getString("targetvariable"));
                quesBean.setDifficulty(rs.getFloat("difficulty"));
                quesBean.setComplexity(rs.getFloat("complexity"));
                
//              get concepts           
                Vector<ConceptBean> concepts = loadConcepts(conn);
                String querGetQuesConcMap = "SELECT concId FROM quesconcmap WHERE " +
                                            "quesid = " + quesBean.getId();
                ResultSet rsConc = SqlUtil.executeStatement(conn, querGetQuesConcMap);
                while(rsConc.next()) {
                    int curId = rsConc.getInt("concId");
                    boolean isFound = false;
                    ListIterator i = concepts.listIterator();                    
                    while (i.hasNext() && !isFound)
                        if (curId == ((ConceptBean) i.next()).getId()) {
                            quesBean.addConcept((ConceptBean) i.previous());
                            isFound = true; 
                        }
                }                
            } else
                throw new Exception();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] getQuestion(): " +
                               "cannot reteive a question from the DB");
            return null;
        }
        return quesBean;

    }
    
    private boolean createQuestion() {
        QuestionBean quesBean = (QuestionBean) this.session.getAttribute("quesBean");   
        this.session.removeAttribute("quesBean");
        try {
            String querInsertQuestion = "INSERT INTO question " +
                                        "(authorId, groupId, permission, title, desc, code, " +
                                        "minRandom, maxRandom, answerType, targetVar, " +
                                        "difficulty, complexity, modified) VALUES (";              
            querInsertQuestion = querInsertQuestion.concat(quesBean.getAuthorId() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getGroupId() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getPermission() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getTitle() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getDescription() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getCode() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getMinRandom() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getMaxRandom() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getAnswerType() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getTargetVar() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getDifficulty() + ", ");
            querInsertQuestion = querInsertQuestion.concat(quesBean.getComplexity() + ", ");
            querInsertQuestion = querInsertQuestion.concat(new Date() + ")");
            SqlUtil.executeUpdate(this.dbConn, querInsertQuestion);
            
            String querSelectLstQuesId = "SELECT max(id) FROM question";
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querSelectLstQuesId);
            rs.next();
            quesBean.setId(rs.getInt(1));
            
            Iterator i = quesBean.getConcepts().iterator();
            while (i.hasNext()) {
                String querQuesConcMap = "INSERT INTO quesconcmap (quesId, concId) " +
                                         "VALUES (" + quesBean.getId() + ", ";
                querQuesConcMap = querQuesConcMap.concat(((ConceptBean) i.next()).getId() + ")");
                SqlUtil.executeUpdate(this.dbConn, querQuesConcMap);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] createQuestion(): " +
                               "Failed to save a question in the DB");
            return false;
        }
        return true;
    }
    
    private boolean modifyQuestion() {
        QuestionBean quesBean = (QuestionBean) this.session.getAttribute("quesBean");
        this.session.removeAttribute("quesBean");
        try {
            String querUpdateQuestion = "UPDATE question SET ";              
            querUpdateQuestion = querUpdateQuestion.concat("authorId = " + quesBean.getAuthorId());
            querUpdateQuestion = querUpdateQuestion.concat("groupId = " + quesBean.getGroupId());
            querUpdateQuestion = querUpdateQuestion.concat("permission = " + quesBean.getPermission());
            querUpdateQuestion = querUpdateQuestion.concat("title = " + quesBean.getTitle());
            querUpdateQuestion = querUpdateQuestion.concat("desc = " + quesBean.getDescription());
            querUpdateQuestion = querUpdateQuestion.concat("code = " + quesBean.getCode());
            querUpdateQuestion = querUpdateQuestion.concat("minRandom = " + quesBean.getMinRandom());
            querUpdateQuestion = querUpdateQuestion.concat("maxRandom = " + quesBean.getMaxRandom());
            querUpdateQuestion = querUpdateQuestion.concat("answerType = " + quesBean.getAnswerType());
            querUpdateQuestion = querUpdateQuestion.concat("targetVar = " + quesBean.getTargetVar());
            querUpdateQuestion = querUpdateQuestion.concat("difficulty = " + quesBean.getDifficulty());
            querUpdateQuestion = querUpdateQuestion.concat("complexity = " + quesBean.getComplexity());
            querUpdateQuestion = querUpdateQuestion.concat("modified" + new Date());
            querUpdateQuestion = querUpdateQuestion.concat("WHERE id = " + quesBean.getId());
            SqlUtil.executeUpdate(this.dbConn, querUpdateQuestion);
            
            String querDeleteQuesConcMap = "DELETE FROM quesconcmap " +
                                           "WHERE quesid = " + quesBean.getId();
            SqlUtil.executeUpdate(this.dbConn, querDeleteQuesConcMap);
            
            Iterator i = quesBean.getConcepts().iterator();
            while (i.hasNext()) {
                String querQuesConcMap = "INSERT INTO quesconcmap (quesId, concId) " +
                                         "VALUES (" + quesBean.getId() + ", ";
                querQuesConcMap = querQuesConcMap.concat(((ConceptBean) i.next()).getId() + ")");
                SqlUtil.executeUpdate(this.dbConn, querQuesConcMap);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] createQuestion(): " +
                               "Failed to save a question in the DB");
            return false;
        }
        return true;
    }

	private boolean deleteQuestion() {
        int quesid = 0;
        try {
            quesid = (new Integer((String) this.session.getAttribute("deleteQuesId"))).intValue();
        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.out.println("[Authoring] deleteQuestion(): invalid deleteQuesId");
            return false;
        }
        try {
            String querDelQuesConcMap = "DELETE FROM quesconcmap where quesid = " + quesid;
            SqlUtil.executeUpdate(this.dbConn, querDelQuesConcMap);
            String querDelQuizQuesMap = "DELETE FROM quizquesmap where quesid = " + quesid;
            SqlUtil.executeUpdate(this.dbConn, querDelQuizQuesMap);
            String querDelQues = "DELETE FROM question where id = " + quesid;
            SqlUtil.executeUpdate(this.dbConn, querDelQues);				
        } catch (Exception e) {
            e.printStackTrace();
			return false;
		}		
		return true;
    }
    
    public boolean getAddQuestionList() {
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        String querAddQuesList = "SELECT * FROM question ";
//      if user is an admin, he can delete anything         
        if(!uBean.isAdmin()) {
//          if user is a superuser or have right for a group artifacts, he can 
//          access any group questions and questions that can be accessed by anyone  
            if (uBean.isSuperUser() || uBean.getRights() == Const.RIGHTS_YES)
                querAddQuesList += "WHERE groupId = " + uBean.getGroupBean().getId() +
                                         " OR question.permission = " + Const.PERM_ARNW +
                                         " OR question.permission = " + Const.PERM_ARGW +
                                         " OR question.permission = " + Const.PERM_ARAW;
//          if it is an ordinary user he can access only his questions in this group and 
//          questions that can be accessed by anyone             
            else
                querAddQuesList += "WHERE (authotId = " + uBean.getId() + 
                                         " AND groupId = " + uBean.getGroupBean().getId() +
                                         ") OR question.permission = " + Const.PERM_ARNW +
                                         " OR question.permission = " + Const.PERM_ARGW +
                                         " OR question.permission = " + Const.PERM_ARAW;
        }
        Vector<QuestionBean> quesList = new Vector<QuestionBean>();
        try {
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querAddQuesList);
            while (rs.next()) {
                QuestionBean quesBean = new QuestionBean();
                quesBean.setId(rs.getInt("id"));
                quesBean.setAuthorId(rs.getInt("authorid"));
                quesBean.setPermission(rs.getInt("permission"));
                quesBean.setTitle(rs.getString("title"));
                quesBean.setDescription(rs.getString("desc"));            
                Clob codeClob = rs.getClob("code");
                quesBean.setCode(codeClob.getSubString(1, (int)codeClob.length()));            
                quesBean.setMinRandom(rs.getInt("minrandom"));
                quesBean.setMaxRandom(rs.getInt("maxrandom"));
                quesBean.setAnswerType(rs.getString("answertype"));
                quesBean.setTargetVar(rs.getString("targetvariable"));
                quesBean.setDifficulty(rs.getFloat("difficulty"));
                quesBean.setComplexity(rs.getFloat("complexity"));                
//              get concepts           
                String querGetQuesConcMap = "SELECT concId FROM quesconcmap WHERE " +
                                            "quesid = " + quesBean.getId();
                ResultSet rsConc = SqlUtil.executeStatement(this.dbConn, querGetQuesConcMap);
                while(rsConc.next()) {
                    int curId = rsConc.getInt("concId");
                    boolean isFound = false;
                    ListIterator i = this.conceptList.listIterator();                    
                    while (i.hasNext() && !isFound)
                        if (curId == ((ConceptBean) i.next()).getId()) {
                            quesBean.addConcept((ConceptBean) i.previous());
                            isFound = true; 
                        }
                }
                quesList.add(quesBean);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] getAddQuestionList(): cannot retrieve " +
                               "questions from the DB");
            return false;
        }
//      Save the list in the session
        System.out.println("[Authoring] getAddQuestionList(): " + quesList.size() +
                           "questions are retrieved from the DB");
        this.session.setAttribute("quesList", quesList);        
        return true;        
    }


    public boolean getModifyQuestionList() {
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        String querAddQuesList = "SELECT * FROM question ";
//      if user is an admin, he can delete anything         
        if(!uBean.isAdmin()) {
//          if user is a superuser or have right for a group artifacts, he can 
//          access any group questions and questions that can be accessed by anyone  
            if (uBean.isSuperUser() || uBean.getRights() == Const.RIGHTS_YES)
                querAddQuesList += "WHERE groupId = " + uBean.getGroupBean().getId() +
                                         " OR question.permission = " + Const.PERM_NRAW +
                                         " OR question.permission = " + Const.PERM_GRAW +
                                         " OR question.permission = " + Const.PERM_ARAW;
//          if it is an ordinary user he can access only his questions in this group and 
//          questions that can be accessed by anyone             
            else
                querAddQuesList += "WHERE (authotId = " + uBean.getId() + 
                                         " AND groupId = " + uBean.getGroupBean().getId() +
                                         ") OR question.permission = " + Const.PERM_NRAW +
                                         " OR question.permission = " + Const.PERM_GRAW +
                                         " OR question.permission = " + Const.PERM_ARAW;
        }
        Vector<QuestionBean> quesList = new Vector<QuestionBean>();
        try {
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querAddQuesList);
            while (rs.next()) {
                QuestionBean quesBean = new QuestionBean();
                quesBean.setId(rs.getInt("id"));
                quesBean.setAuthorId(rs.getInt("authorid"));
                quesBean.setPermission(rs.getInt("permission"));
                quesBean.setTitle(rs.getString("title"));
                quesBean.setDescription(rs.getString("desc"));            
                Clob codeClob = rs.getClob("code");
                quesBean.setCode(codeClob.getSubString(1, (int)codeClob.length()));            
                quesBean.setMinRandom(rs.getInt("minrandom"));
                quesBean.setMaxRandom(rs.getInt("maxrandom"));
                quesBean.setAnswerType(rs.getString("answertype"));
                quesBean.setTargetVar(rs.getString("targetvariable"));
                quesBean.setDifficulty(rs.getFloat("difficulty"));
                quesBean.setComplexity(rs.getFloat("complexity"));                
//              get concepts           
                String querGetQuesConcMap = "SELECT concId FROM quesconcmap WHERE " +
                                            "quesid = " + quesBean.getId();
                ResultSet rsConc = SqlUtil.executeStatement(this.dbConn, querGetQuesConcMap);
                while(rsConc.next()) {
                    int curId = rsConc.getInt("concId");
                    boolean isFound = false;
                    ListIterator i = this.conceptList.listIterator();                    
                    while (i.hasNext() && !isFound)
                        if (curId == ((ConceptBean) i.next()).getId()) {
                            quesBean.addConcept((ConceptBean) i.previous());
                            isFound = true; 
                        }
                }
                quesList.add(quesBean);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] getAddQuestionList(): cannot retrieve " +
                               "questions from the DB");
            return false;
        }
//      Save the list in the session
        System.out.println("[Authoring] getAddQuestionList(): " + quesList.size() +
                           "questions are retrieved from the DB");
        this.session.setAttribute("quesList", quesList);        
        return true;
    }

}