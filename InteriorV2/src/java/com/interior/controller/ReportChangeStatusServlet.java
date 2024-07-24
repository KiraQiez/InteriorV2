package com.interior.controller;

import com.interior.DAO.ReportDAO;
import com.interior.model.Report;
import com.interior.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ReportChangeStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        String reportID = request.getParameter("reportID");
        String reportStatus = request.getParameter("reportStatus");
        String checkedByStaffID = request.getParameter("checkedByStaff");

        Report report = new Report();
        report.setReportID(reportID);
        report.setReportStatus(reportStatus);
        report.setHandledByStaffID(currentUser.getUserid());
        report.setCheckedByStaffID(checkedByStaffID);

        ReportDAO reportDAO = new ReportDAO();
        boolean status = reportDAO.updateReportStatus(report);

        if (status) {
            request.setAttribute("message", "Report status updated successfully!");
        } else {
            request.setAttribute("message", "Failed to update report status.");
        }

        request.getRequestDispatcher("StaffReport.jsp").forward(request, response);
    }
}
