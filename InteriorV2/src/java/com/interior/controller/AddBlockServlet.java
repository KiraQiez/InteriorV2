package com.interior.controller;

import com.interior.DAO.BlockDAO;
import com.interior.model.Block;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AddBlockServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String blockID = request.getParameter("blockID");
        String blockName = request.getParameter("blockName");
        String blockDesc = request.getParameter("blockDesc");

        Block block = new Block();
        block.setBlockID(blockID);
        block.setBlockName(blockName);
        block.setBlockDesc(blockDesc);

        BlockDAO blockDAO = new BlockDAO();
        boolean status = blockDAO.insertBlock(block);

        if (status) {
            request.setAttribute("message", "Block added successfully.");
        } else {
            request.setAttribute("message", "Failed to add block.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffBlock.jsp");
        dispatcher.forward(request, response);
    }
}
