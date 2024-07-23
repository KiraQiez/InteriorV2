/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.controller;

import com.interior.DAO.ReportDAO;
import com.interior.model.Report;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Iqmal
 */
public class ReportChangeStatusServlet extends HttpServlet {

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

        // Create an instance of Report and ReportDAO
        Report report = new Report();
        ReportDAO reportDAO = new ReportDAO();

        // Get the parameters from the request
        String reportID = request.getParameter("reportID");
        String reportStatus = request.getParameter("reportStatus");

        // Set the parameters to the Report object
        report.setReportID(reportID);
        report.setStatus(reportStatus);

        try {
            // Update the report status using ReportDAO
            boolean status = reportDAO.updateReportStatus(report);

            // Set an attribute to the request based on the operation status
            if (status) {
                request.setAttribute("message", "Report status updated successfully.");
            } else {
                request.setAttribute("message", "Report status update failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffReport.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
