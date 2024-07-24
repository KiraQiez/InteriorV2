package com.interior.DAO;

import com.interior.model.Block;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BlockDAO {

    public boolean insertBlock(Block block) {
        boolean status = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO BLOCK (blockID, blockName, blockDesc) VALUES (?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, block.getBlockID());
                ps.setString(2, block.getBlockName());
                ps.setString(3, block.getBlockDesc());
                int i = ps.executeUpdate();
                if (i > 0) {
                    status = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public List<Block> getAllBlocks() {
        List<Block> blocks = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM BLOCK";
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Block block = new Block();
                    block.setBlockID(rs.getString("blockID"));
                    block.setBlockName(rs.getString("blockName"));
                    block.setBlockDesc(rs.getString("blockDesc"));
                    blocks.add(block);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return blocks;
    }

    public boolean deleteBlock(String blockID) {
        boolean status = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM BLOCK WHERE blockID = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, blockID);
                int i = ps.executeUpdate();
                if (i > 0) {
                    status = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
