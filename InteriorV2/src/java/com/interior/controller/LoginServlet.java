package com.interior.controller;

import com.interior.DAO.UserDAO;
import com.interior.model.User;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

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
        String password = request.getParameter("password");

        user.setUsername(name);
        user.setPassword(password);

        try {
            boolean status = userDAO.checkLogin(user);

            if (status) {
                user = userDAO.userInfo(user);

                // Set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getUserid());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("usertype", user.getUsertype());
                session.setAttribute("userImage", user.getUserImage()); 

                request.setAttribute("message", "Login successful.");
                request.setAttribute("user", user);

                // Forward to the appropriate homepage
                String userType = user.getUsertype();
                String targetPage = "";

                if ("Staff".equals(userType)) {
                    targetPage = "StaffHomepage.jsp";
                } else {
                    targetPage = "StudentHomepage.jsp";
                }

                RequestDispatcher dispatcher = request.getRequestDispatcher(targetPage);
                dispatcher.forward(request, response);

            } else {
                request.setAttribute("message", "Invalid username or password.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("MainLogin.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("MainLogin.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet";
    }
}
