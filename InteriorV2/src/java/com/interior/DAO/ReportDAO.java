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
import com.interior.model.Report;

/**
 *
 * @author Iqmal
 */
public class ReportDAO {

    public boolean updateReportStatus(Report report) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE REPORT SET reportStatus = ?, handledByStaffID = ?, checkedByStaffID = ? WHERE reportID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, report.getReportStatus());
            ps.setString(2, report.getHandledByStaffID());
            ps.setString(3, report.getCheckedByStaffID());
            ps.setString(4, report.getReportID());

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



    // Method to get report info based on reportId
    public Report getReportById(String reportID) {
        String query = "SELECT * FROM REPORT WHERE REPORTID = ?";
        Report report = null;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, reportID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                report = new Report();
                report.setReportID(rs.getString("reportID"));
                report.setReportID(rs.getString("reportTitle"));
                report.setReportID(rs.getString("reportDesc"));
                report.setReportID(rs.getString("studentID"));
                report.setReportID(rs.getString("handledByStaffID"));
                report.setReportID(rs.getString("checkedByStaffID"));
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return report;
    }
}
