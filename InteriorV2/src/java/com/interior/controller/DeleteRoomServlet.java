package com.interior.controller;

import com.interior.DAO.RoomDAO;

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
        roomDAO.deleteRoom(roomID);

        response.sendRedirect("StaffRoom.jsp");
    }
}
