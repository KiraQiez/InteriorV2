package com.interior.controller;

import com.interior.DAO.StudentDAO;
import com.interior.model.Student;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class EditStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentID = request.getParameter("studentID");
        String studentName = request.getParameter("studentName");
        String studentPhone = request.getParameter("studentPhone");
        String studentAddress = request.getParameter("studentAddress");
        String studentIncome = request.getParameter("studentIncome");
        String studentParentPhone = request.getParameter("studentParentPhone");

        StudentDAO studentDAO = new StudentDAO();
        boolean success = studentDAO.updateStudentProfile(studentID, studentName, studentPhone, studentAddress, studentIncome, studentParentPhone);

        if (success) {
            request.setAttribute("message", "Student successfully updated.");
        } else {
            request.setAttribute("message", "Error updating student.");
        }

        request.getRequestDispatcher("StaffStudent.jsp").forward(request, response);
    }
}
