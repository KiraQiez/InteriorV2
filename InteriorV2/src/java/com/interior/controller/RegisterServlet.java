package com.interior.controller;

import com.interior.DAO.UserDAO;
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
        
        String name = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        user.setUsername(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setUsertype("Student");

        try {
            boolean status = userDAO.insertUser(user);

            if (status) {
                request.setAttribute("message", "User registered successfully.");
                request.setAttribute("user", user);
            } else {
                request.setAttribute("message", "User registration failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("result.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

