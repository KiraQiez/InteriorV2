/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.controller;

import com.interior.DAO.SessionDAO;
import com.interior.model.Session;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Iqmal
 */
public class SessionChangeStatusServlet extends HttpServlet {

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

        // Create an instance
        Session ssn = new Session();
        SessionDAO ssnDAO = new SessionDAO();

        // Get the parameters from the request
        int sessionID = Integer.parseInt(request.getParameter("sessionID"));
        String sessionName = request.getParameter("sessionName");
        String sessionStatus = request.getParameter("sessionStatus");

        // Set the parameters to the object
        ssn.setSessionID(sessionID);
        ssn.setSessionName(sessionName);
        ssn.setSessionStatus(sessionStatus);

        try {
            boolean status = ssnDAO.updateSessionStatus(ssn);

            if (status) {
                request.setAttribute("message", "Session updated successfully.");
            } else {
                request.setAttribute("message", "Session update failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffSession.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
