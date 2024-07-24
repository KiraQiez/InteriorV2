package com.interior.DAO;

import com.interior.model.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class StaffDAO {

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
