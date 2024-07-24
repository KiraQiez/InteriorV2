package com.interior.controller;

import com.interior.DAO.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class LoadRoomIDsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(LoadRoomIDsServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String blockID = request.getParameter("blockID");
        String roomType = request.getParameter("roomType");

        logger.info("Received blockID: " + blockID);
        logger.info("Received roomType: " + roomType);

        if (blockID == null || blockID.isEmpty() || roomType == null || roomType.isEmpty()) {
            logger.warning("Missing parameters");
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing blockID or roomType parameter\"}");
            return;
        }

        String query = "SELECT roomID FROM ROOM WHERE blockID = ? AND roomType = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, blockID);
            ps.setString(2, roomType);

            ResultSet rs = ps.executeQuery();
            List<String> roomIDs = new ArrayList<>();

            while (rs.next()) {
                roomIDs.add(rs.getString("roomID"));
            }

            response.setContentType("application/json");
            response.getWriter().write(toJson(roomIDs));
        } catch (SQLException e) {
            logger.severe("SQL error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error loading room IDs: " + e.getMessage() + "\"}");
        }
    }

    private String toJson(List<String> list) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            json.append("\"").append(list.get(i)).append("\"");
            if (i < list.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }
}
