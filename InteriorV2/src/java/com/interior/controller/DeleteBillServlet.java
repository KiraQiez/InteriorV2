package com.interior.controller;

import com.interior.DAO.BillDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billID = request.getParameter("billID");

        BillDAO billDAO = new BillDAO();
        boolean success = billDAO.deleteBill(billID);

        if (success) {
            request.setAttribute("message", "Bill successfully deleted.");
        } else {
            request.setAttribute("message", "Error deleting bill.");
        }

        request.getRequestDispatcher("StaffBill.jsp").forward(request, response);
    }
}
