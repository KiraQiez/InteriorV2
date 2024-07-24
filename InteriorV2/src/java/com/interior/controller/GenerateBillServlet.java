package com.interior.controller;

import com.interior.DAO.BillDAO;
import com.interior.model.Bill;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class GenerateBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billType = request.getParameter("billType");
        String totalAmountStr = request.getParameter("totalAmount");
        String stdID = request.getParameter("stdID");

        double totalAmount = Double.parseDouble(totalAmountStr);

        Bill bill = new Bill();
        bill.setBillType(billType);
        bill.setTotalAmount(totalAmount);
        bill.setStdID(stdID);

        BillDAO billDAO = new BillDAO();
        boolean success = billDAO.addBill(bill);

        if (success) {
            request.setAttribute("message", "Bill successfully generated.");
        } else {
            request.setAttribute("message", "Error generating bill.");
        }

        request.getRequestDispatcher("StaffBill.jsp").forward(request, response);
    }
}
