package com.interior.controller;

import com.interior.DAO.BillDAO;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 16177215) // upload file's size up to 16MB
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String billID = request.getParameter("billID");
        Part filePart = request.getPart("paymentProof");

        BillDAO billDAO = new BillDAO();

        if (filePart != null) {
            try (InputStream inputStream = filePart.getInputStream()) {
                // Save payment proof and update bill status
                boolean isUpdated = billDAO.updateBillWithPayment(billID, inputStream);

                if (isUpdated) {
                    request.setAttribute("message", "Payment successfully recorded.");
                } else {
                    request.setAttribute("message", "Payment recording failed.");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("message", "An error occurred: " + ex.getMessage());
            }
        }

        request.getRequestDispatcher("StudentBill.jsp").forward(request, response);
    }
}
