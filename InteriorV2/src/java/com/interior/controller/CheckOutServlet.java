package com.interior.controller;

import com.interior.DAO.BookingDAO;
import com.interior.DAO.RoomDAO;
import com.interior.model.Room;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CheckOutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingID = request.getParameter("bookingID");
        String roomID = request.getParameter("roomID");

        if (bookingID == null || bookingID.isEmpty()) {
            request.setAttribute("message", "Error: Booking ID is required.");
            request.getRequestDispatcher("StudentBooking.jsp").forward(request, response);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();

        try {
            boolean success = bookingDAO.checkOut(bookingID);

            if (success) {
                Room room = new Room();
                RoomDAO roomDAO = new RoomDAO();
                room.setRoomID(roomID);
                roomDAO.roomAvailabilityAfterCheckOut(room);
                request.setAttribute("message", "Booking checked out successfully.");
            } else {
                request.setAttribute("message", "Error checking out booking.");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error processing check out.");
        }

        request.getRequestDispatcher("StudentRoom.jsp").forward(request, response);
    }
}
