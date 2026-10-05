<%-- 
    Document   : Connection.jsp
    Created on : 30 Sept 2026, 12:39:23
    Author     : Rakibul Islam Jisan
--%>

<%@ page import ="java.sql.*" %>

<%!

public Connection getConnection() throws Exception {
    Class.forName("oracle.jdbc.OracleDriver");
    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "SYSTEM";
    String pass = "admin1";
    return DriverManager.getConnection(url,user,pass);
}

%>
