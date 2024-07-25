package com.interior.controller;

import com.interior.DAO.RoomDAO;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomID = request.getParameter("roomID");

        RoomDAO roomDAO = new RoomDAO();
        boolean isDeleted = roomDAO.deleteRoom(roomID);

        if (isDeleted) {
            request.setAttribute("message", "Room deleted successfully!");
        } else {
            request.setAttribute("message", "Error deleting room. It may be associated with student data.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffRoom.jsp");
        dispatcher.forward(request, response);
    }
}
