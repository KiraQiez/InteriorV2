package com.interior.DAO;

import com.interior.model.Staff;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StaffDAO {

    // Insert Staff
    public boolean insertStaff(Staff staff) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO STAFF (staffID, staffName, staffType) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, staff.getStaffID());
            ps.setString(2, staff.getStaffName());
            ps.setString(3, staff.getStaffType());

            int i = ps.executeUpdate();
            if (i > 0) {
                status = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    // Get Staff Info
    public Staff getStaffInfo(String userId) throws SQLException {
        Staff staff = null;
        String query = "SELECT * FROM STAFF WHERE staffID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staff = new Staff();
                    staff.setStaffID(rs.getString("staffID"));
                    staff.setStaffName(rs.getString("staffName"));
                    staff.setStaffType(rs.getString("staffType"));
                    // Set other staff-specific attributes
                }
            }
        }
        return staff;
    }

    // Update Staff
    public boolean updateStaff(Staff staff) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE STAFF SET staffName = ?, staffType = ? WHERE staffID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, staff.getStaffName());
            ps.setString(2, staff.getStaffType());
            ps.setString(3, staff.getStaffID());

            int i = ps.executeUpdate();
            if (i > 0) {
                status = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return status;
    }

    // Delete Staff
    public boolean deleteStaff(String staffID) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM STAFF WHERE staffID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, staffID);

            int i = ps.executeUpdate();
            if (i > 0) {
                status = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return status;
    }
}
