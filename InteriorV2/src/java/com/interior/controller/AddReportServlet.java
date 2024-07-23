package com.interior.controller;

import com.interior.DAO.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

public class AddReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportTitle = request.getParameter("reportTitle");
        String reportDesc = request.getParameter("reportDesc");
        String studentID = request.getSession().getAttribute("user").toString(); // Assuming user ID is stored in session

        String reportID = UUID.randomUUID().toString().substring(0, 8).toUpperCase(); // Generating a random 8-char report ID
        String reportStatus = "Pending"; // Default status

        String query = "INSERT INTO REPORT (reportID, reportTitle, reportDesc, reportStatus, studentID) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setString(1, reportID);
            ps.setString(2, reportTitle);
            ps.setString(3, reportDesc);
            ps.setString(4, reportStatus);
            ps.setString(5, studentID);

            int result = ps.executeUpdate();

            if (result > 0) {
                request.setAttribute("message", "Report added successfully!");
            } else {
                request.setAttribute("message", "Failed to add report.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        }

        request.getRequestDispatcher("StudentReport.jsp").forward(request, response); // Redirecting back to report management page
    }
}
