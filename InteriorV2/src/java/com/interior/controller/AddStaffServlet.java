package com.interior.controller;

import com.interior.DAO.StaffDAO;
import com.interior.DAO.UserDAO;
import com.interior.model.Staff;
import com.interior.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AddStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = new User();
        UserDAO userDAO = new UserDAO();
        StaffDAO staffDAO = new StaffDAO();

        String username = request.getParameter("staffUsername");
        String fullname = request.getParameter("staffName");
        String email = request.getParameter("staffEmail");
        String password = request.getParameter("staffPassword");
        String staffType = request.getParameter("staffType");

        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setUsertype("Staff");

        try {
            boolean userStatus = userDAO.insertUser(user);

            if (userStatus) {
                System.out.println("User inserted successfully with ID: " + user.getUserid());

                Staff staff = new Staff();
                staff.setStaffID(user.getUserid());
                staff.setStaffName(fullname);
                staff.setStaffType(staffType);

                boolean staffStatus = staffDAO.insertStaff(staff);

                if (staffStatus) {
                    System.out.println("Staff inserted successfully with ID: " + staff.getStaffID());
                    request.setAttribute("message", "Staff registered successfully.");
                } else {
                    System.out.println("Failed to insert staff details.");
                    request.setAttribute("message", "Failed to add staff details.");
                }

            } else {
                System.out.println("Failed to insert user.");
                request.setAttribute("message", "Failed to add staff. Username or Email may already exist.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", e.getMessage());
        }

        request.getRequestDispatcher("StaffStaff.jsp").forward(request, response);
    }
}
