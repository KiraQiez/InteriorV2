<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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

            StringBuilder options = new StringBuilder();

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

                boolean hasRooms = false;

                while (rs.next()) {
                    hasRooms = true;
                    options.append("<option value=\"").append(rs.getString("ROOMID")).append("\">")
                            .append(rs.getString("ROOMID")).append(" - ")
                            .append(rs.getInt("AVAILABILITY")).append(" Slot(s) left")
                            .append("</option>");
                }

                if (!hasRooms) {
                    options.append("<option value=\"\">No Option Available</option>");
                }
            } catch (SQLException sqle) {
                options.setLength(0); // Clear previous content
                options.append("<option value=\"\">Error: ").append(sqle.getMessage()).append("</option>");
            } catch (Exception e) {
                options.setLength(0); // Clear previous content
                options.append("<option value=\"\">Error: ").append(e.getMessage()).append("</option>");
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
                    options.setLength(0); // Clear previous content
                    options.append("<option value=\"\">Error: ").append(ex.getMessage()).append("</option>");
                }
            }

            out.println(options.toString());
        %>
    </body>
</html>
