/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.controller;

import com.interior.DAO.BookingDAO;
import com.interior.model.Booking;
import com.interior.DAO.BillDAO;
import com.interior.model.Bill;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EditBookingServlet extends HttpServlet {

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
        Booking book = new Booking();
        BookingDAO bookDAO = new BookingDAO();

        // Get the parameters from the request
        String bookingID = request.getParameter("bookingID");
        String bookStatus = request.getParameter("bookStatus");

        // Set the parameters to the object
        book.setBookingID(bookingID);
        book.setBookstatus(bookStatus);

        try {
            boolean status = bookDAO.changeStatusBooking(book);

            if (status) {
                request.setAttribute("message", "Booking status successfully updated.");
                // Check bookStatus and generate bill if approved
                if (bookStatus.equals("APPROVED")) {
                    String billMessage = addBill(request, book);
                    request.setAttribute("billMessage", billMessage);
                }
            } else {
                request.setAttribute("message", "Fail to change booking status.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffBooking.jsp");
        dispatcher.forward(request, response);
    }

    public String addBill(HttpServletRequest request, Booking book) {
        try {
            Bill bill = new Bill();
            BillDAO billDAO = new BillDAO();

            // Get the parameters from the request
            String stdID = request.getParameter("stdID");

            // Set the parameters to the object
            // Set paymentID to null since the student didn't pay yet
            bill.setStdID(stdID);
            bill.setPaymentID(null);
            bill.setBillType("Hostel");
            bill.setTotalAmount(2000);

            boolean billStatus = billDAO.addBill(bill);

            if (billStatus) {
                return "Bill successfully generated.";
            } else {
                return "Failed to generate bill.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "An error occurred: " + e.getMessage();
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
