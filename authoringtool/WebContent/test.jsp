<HTML>
    <HEAD>
        <TITLE>Determining Which Button Was Clicked</TITLE>
    </HEAD>
 
    <BODY>
        <H1>Determining Which Button Was Clicked</H1>
        You clicked 
        <%= request.getParameter("buttonName") %>
    </BODY>
</HTML>