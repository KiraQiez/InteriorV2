package com.interior.controller;

import com.interior.DAO.StudentDAO;
import com.interior.model.Student;
import com.interior.model.User;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            String userId = user.getUserid();

            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String income = request.getParameter("income");
            String parentPhone = request.getParameter("parentPhone");

            StudentDAO studentDAO = new StudentDAO();
            boolean success = studentDAO.updateStudentProfile(userId, name, phone, address, income, parentPhone);

            if (success) {
                request.setAttribute("message", "Profile updated successfully.");
            } else {
                request.setAttribute("message", "Failed to update profile. Please try again.");
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("StudentProfile.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("MainLogin.jsp");
        }
    }
}
