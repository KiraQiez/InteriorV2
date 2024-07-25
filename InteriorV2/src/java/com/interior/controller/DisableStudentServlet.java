package com.interior.controller;

import com.interior.DAO.StudentDAO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DisableStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentID = request.getParameter("studentID");

        StudentDAO studentDAO = new StudentDAO();
        boolean success = studentDAO.updateStudentStatus(studentID, "Inactive");

        if (success) {
            request.setAttribute("message", "Student successfully disabled.");
        } else {
            request.setAttribute("message", "Error disabling student.");
        }

        request.getRequestDispatcher("StaffStudent.jsp").forward(request, response);
    }
}
