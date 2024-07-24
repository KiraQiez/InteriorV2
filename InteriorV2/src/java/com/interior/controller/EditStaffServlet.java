package com.interior.controller;

import com.interior.DAO.UserDAO;
import com.interior.DAO.StaffDAO;
import com.interior.model.User;
import com.interior.model.Staff;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EditStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String staffID = request.getParameter("staffID");
        String staffName = request.getParameter("staffName");
        String staffUsername = request.getParameter("staffUsername");
        String staffEmail = request.getParameter("staffEmail");
        String staffPassword = request.getParameter("staffPassword");
        String staffType = request.getParameter("staffType");

        // Create a new User object for updating the database
        User updateUser = new User();
        updateUser.setUserid(staffID);
        updateUser.setUsername(staffUsername);
        updateUser.setEmail(staffEmail);
        updateUser.setPassword(staffPassword);
        updateUser.setUsertype("Staff");

        UserDAO userDAO = new UserDAO();
        boolean userUpdated = userDAO.updateUser(updateUser);

        if (userUpdated) {
            System.out.println("User updated successfully with ID: " + updateUser.getUserid());

            // Update the staff table
            Staff staff = new Staff();
            staff.setStaffID(staffID);
            staff.setStaffName(staffName);
            staff.setStaffType(staffType);

            StaffDAO staffDAO = new StaffDAO();
            boolean staffUpdated = staffDAO.updateStaff(staff);

            if (staffUpdated) {
                request.setAttribute("message", "Staff updated successfully!");
            } else {
                request.setAttribute("message", "Failed to update staff details.");
            }
        } else {
            System.out.println("Failed to update user.");
            request.setAttribute("message", "Failed to update staff. Username or Email may already exist.");
        }

        request.getRequestDispatcher("StaffStaff.jsp").forward(request, response);
    }
}
