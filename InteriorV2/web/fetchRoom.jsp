<%-- 
    Document   : fetchRoom
    Created on : Jul 24, 2024, 8:28:05 PM
    Author     : Iqmal
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String blockID = request.getParameter("blockID");
            String roomType = request.getParameter("roomType");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                String driver = "org.apache.derby.jdbc.ClientDriver";
                String connectionString = "jdbc:derby://localhost:1527/InteriorDB";
                String dbUser = "root";
                String dbPass = "root";

                Class.forName(driver);
                conn = DriverManager.getConnection(connectionString, dbUser, dbPass);

                String query = "SELECT ROOMID, AVAILABILITY FROM ROOM WHERE BLOCKID = ? AND ROOMTYPE = ? AND AVAILABILITY > 0";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, blockID);
                pstmt.setString(2, roomType);
                rs = pstmt.executeQuery();

                StringBuilder options = new StringBuilder();
                while (rs.next()) {
                    options.append("<option value=\"").append(rs.getString("ROOMID")).append("\">")
                            .append(rs.getString("ROOMID")).append(" - ")
                            .append(rs.getInt("AVAILABILITY")).append(" Slot(s) left")
                            .append("</option>");
                }

                out.println(options.toString());
            } catch (SQLException sqle) {
                out.println(sqle.getMessage());
            } catch (Exception e) {
                out.println(e.getMessage());
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (pstmt != null) {
                        pstmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException ex) {
                    out.println(ex.getMessage());
                }
            }
        %>
    </body>

</html>

