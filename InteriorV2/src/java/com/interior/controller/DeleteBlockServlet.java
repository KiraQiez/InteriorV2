package com.interior.controller;

import com.interior.DAO.BlockDAO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteBlockServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String blockID = request.getParameter("blockID");

        BlockDAO blockDAO = new BlockDAO();
        boolean status = blockDAO.deleteBlock(blockID);

        if (status) {
            request.setAttribute("message", "Block deleted successfully.");
        } else {
            request.setAttribute("message", "Failed to delete block.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffBlock.jsp");
        dispatcher.forward(request, response);
    }
}
