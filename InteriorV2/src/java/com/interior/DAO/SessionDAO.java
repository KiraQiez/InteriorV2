/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.interior.model.Session;
/**
 *
 * @author Iqmal
 */
public class SessionDAO {
    public boolean updateSessionStatus(Session ssn) {
        String query = "UPDATE session SET sessionStatus = ?, sessionName = ? WHERE sessionID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, ssn.getSessionStatus());
            ps.setString(2, ssn.getSessionName());
            ps.setInt(3, ssn.getSessionID());
            boolean rowUpdated = ps.executeUpdate() > 0;
            return rowUpdated;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean insertNewSession(Session ssn) {
        String query = "INSERT INTO SESSION(SESSIONID, SESSIONNAME, SESSIONSTATUS) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, ssn.getSessionID());
            ps.setString(2, ssn.getSessionName());
            ps.setString(3, ssn.getSessionStatus());
            boolean rowUpdated = ps.executeUpdate() > 0;
            return rowUpdated;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
