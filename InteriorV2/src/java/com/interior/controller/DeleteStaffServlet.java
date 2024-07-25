package com.interior.controller;

import com.interior.DAO.UserDAO;
import com.interior.DAO.StaffDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String staffID = request.getParameter("staffID");

        UserDAO userDAO = new UserDAO();
        StaffDAO staffDAO = new StaffDAO();

        try {
            boolean staffDeleted = staffDAO.deleteStaff(staffID);

            if (staffDeleted) {
                boolean userDeleted = userDAO.deleteUser(staffID);

                if (userDeleted) {
                    request.setAttribute("message", "Staff deleted successfully.");
                } else {
                    request.setAttribute("message", "Failed to delete user details.");
                }
            } else {
                request.setAttribute("message", "Failed to delete staff.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", e.getMessage());
        }

        request.getRequestDispatcher("StaffStaff.jsp").forward(request, response);
    }
}
