/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.DAO;

import com.interior.model.Bill;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BillDAO {

    public boolean addBill(Bill bill) {
        String query = "INSERT INTO BILL (BILLID, BILLTYPE, TOTALAMOUNT, STDID, PAYMENTID) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            // setString
            String newBillID = generateBillID(con);
            bill.setBillID(newBillID);
            
            ps.setString(1, bill.getBillID());
            ps.setString(2, bill.getBillType());
            ps.setInt(3, bill.getTotalAmount());
            ps.setString(4, bill.getStdID());
            ps.setString(5, bill.getPaymentID());

            System.out.println(query);
            System.out.println( bill.getBillID());
            System.out.println(bill.getBillType());
            System.out.println(bill.getTotalAmount());
            System.out.println(bill.getStdID());
            System.out.println(bill.getPaymentID());
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBillWithPayment(String billID, InputStream paymentProof) {
        String insertPaymentQuery = "INSERT INTO PAYMENT (paymentID, paymentStatus, paymentDate, paymentProof) VALUES (?, ?, CURRENT_DATE, ?)";
        String updateBillQuery = "UPDATE BILL SET paymentID = ? WHERE billID = ?";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            String paymentID = generatePaymentID(con);

            try (PreparedStatement insertPaymentPS = con.prepareStatement(insertPaymentQuery)) {
                insertPaymentPS.setString(1, paymentID);
                insertPaymentPS.setString(2, "Paid");
                insertPaymentPS.setBlob(3, paymentProof);

                int paymentRowsInserted = insertPaymentPS.executeUpdate();

                if (paymentRowsInserted > 0) {
                    try (PreparedStatement updateBillPS = con.prepareStatement(updateBillQuery)) {
                        updateBillPS.setString(1, paymentID);
                        updateBillPS.setString(2, billID);

                        int billRowsUpdated = updateBillPS.executeUpdate();

                        if (billRowsUpdated > 0) {
                            con.commit();
                            return true;
                        } else {
                            con.rollback();
                        }
                    }
                } else {
                    con.rollback();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String generatePaymentID(Connection con) throws SQLException {
        String query = "SELECT paymentID FROM PAYMENT ORDER BY paymentID DESC FETCH FIRST ROW ONLY";
        try (PreparedStatement ps = con.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {

            String lastId = null;
            if (rs.next()) {
                lastId = rs.getString("paymentID");
            }

            if (lastId == null) {
                return "P0000001"; // Start with the first ID
            } else {
                int num = Integer.parseInt(lastId.substring(1));
                num++;
                return String.format("P%07d", num);
            }
        }
    }

    private String generateBillID(Connection con) throws SQLException {
        String query = "SELECT BILLID FROM BILL ORDER BY BILLID DESC FETCH FIRST ROW ONLY";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        String lastId = null;
        if (rs.next()) {
            lastId = rs.getString("billID");
        }
        rs.close();
        ps.close();

        if (lastId == null) {
            return "B0000001"; // Start with the first ID
        } else {
            int num = Integer.parseInt(lastId.substring(1));
            num++;
            return String.format("B%07d", num);
        }
    }

    public boolean deleteBill(String billID) {
        String query = "DELETE FROM BILL WHERE BILLID = ?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, billID);

            int rowsDeleted = ps.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
