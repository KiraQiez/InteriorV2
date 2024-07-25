package com.interior.controller;

import com.interior.DAO.BookingDAO;
import com.interior.model.Booking;
import com.interior.DAO.RoomDAO;
import com.interior.model.Room;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.logging.Logger;


public class AddBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AddBookingServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String blockID = request.getParameter("blockID");
        String roomType = request.getParameter("roomType");
        String roomID = request.getParameter("roomID");
        String sessionIDStr = request.getParameter("sessionID");
        String stdID = request.getParameter("stdID"); // Assume this is passed in the form
        String bookstatus = "Pending"; // Initial status

        logger.info("Received booking request with parameters - Block ID: " + blockID + ", Room Type: " + roomType + ", Room ID: " + roomID + ", Session ID: " + sessionIDStr + ", Student ID: " + stdID);

        if (blockID == null || roomType == null || roomID == null || sessionIDStr == null || stdID == null) {
            logger.warning("Missing required fields");
            request.setAttribute("message", "Error: All fields are required.");
            request.getRequestDispatcher("StudentBooking.jsp").forward(request, response);
            return;
        }

        int sessionID;
        try {
            sessionID = Integer.parseInt(sessionIDStr);
        } catch (NumberFormatException e) {
            logger.severe("Invalid session ID format: " + e.getMessage());
            request.setAttribute("message", "Error: Invalid session ID.");
            request.getRequestDispatcher("StudentBooking.jsp").forward(request, response);
            return;
        }

        Booking booking = new Booking();
        booking.setBlockID(blockID);
        booking.setRoomType(roomType);
        booking.setRoomID(roomID);
        booking.setSessionID(sessionID);
        booking.setStdID(stdID);
        booking.setBookstatus(bookstatus);
        booking.setBookingDate(new Date(System.currentTimeMillis()));

        BookingDAO bookingDAO = new BookingDAO();
        boolean success = bookingDAO.addBooking(booking);

        if (success) {
            logger.info("Booking successfully added");
            request.setAttribute("message", "Booking successfully added.");
            Room room = new Room();
            RoomDAO roomDAO = new RoomDAO();
            
            room.setRoomID(booking.getRoomID());
            roomDAO.updateRoomAvailability(room);
        } else {
            logger.severe("Error adding booking");
            request.setAttribute("message", "Error adding booking.");
        }

        request.getRequestDispatcher("StudentBooking.jsp").forward(request, response);
    }
}
