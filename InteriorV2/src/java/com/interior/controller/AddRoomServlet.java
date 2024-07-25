package com.interior.controller;

import com.interior.DAO.RoomDAO;
import com.interior.model.Room;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AddRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String blockID = request.getParameter("blockID");
        String roomType = request.getParameter("roomType");
        int maxCapacity = Integer.parseInt(request.getParameter("maxCapacity"));

        RoomDAO roomDAO = new RoomDAO();
        Room room = new Room();
        room.setBlockID(blockID);
        room.setRoomType(roomType);
        room.setMaxCapacity(maxCapacity);
        room.setRoomID(roomDAO.generateRoomID(blockID));

        roomDAO.addRoom(room);

        response.sendRedirect("StaffRoom.jsp");
    }
}
