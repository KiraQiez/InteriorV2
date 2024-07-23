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
import java.util.ArrayList;
import java.util.List;


public class GetRoomIDsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String blockID = request.getParameter("blockID");
        String roomType = request.getParameter("roomType");

        List<String> roomIDs = new ArrayList<>();
        String query = "SELECT roomID FROM ROOM WHERE blockID = ? AND roomType = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setString(1, blockID);
            ps.setString(2, roomType);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                roomIDs.add(rs.getString("roomID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(convertToJson(roomIDs));
    }

    private String convertToJson(List<String> roomIDs) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < roomIDs.size(); i++) {
            json.append("\"").append(roomIDs.get(i)).append("\"");
            if (i < roomIDs.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }
}
