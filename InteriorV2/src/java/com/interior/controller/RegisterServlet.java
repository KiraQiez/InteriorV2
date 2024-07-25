package com.interior.controller;

import com.interior.DAO.StudentDAO;
import com.interior.DAO.UserDAO;
import com.interior.model.Student;
import com.interior.model.User;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        User user = new User();
        UserDAO userDAO = new UserDAO();
        StudentDAO studentDAO = new StudentDAO();
        
        String name = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullname");
        String ic = request.getParameter("ic");

        user.setUsername(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setUsertype("Student");

        Student student = new Student();
        student.setStdName(fullName);
        student.setStdIC(ic);
        student.setStdStatus("Inactive");

        try {
            boolean status = userDAO.insertUser(user);

            if (status) {
                student.setStdId(user.getUserid());
                boolean studentStatus = studentDAO.insertStudent(student);
                if (studentStatus) {
                    request.getSession().setAttribute("message", "User registered successfully.");
                } else {
                    request.getSession().setAttribute("message", "User registered but failed to insert student details.");
                }
                response.sendRedirect("MainRegister.jsp");
            } else {
                request.setAttribute("message", "User registration failed.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("MainRegister.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("MainRegister.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
