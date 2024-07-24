/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.DAO;

import com.interior.model.Bill;
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
            ps.setString(1, generateBillID(con));
            ps.setString(2, bill.getBillType());
            ps.setDouble(3, bill.getTotalAmount());
            ps.setString(4, bill.getStdID());
            ps.setString(5, bill.getPaymentID());
            
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String generateBillID(Connection con) throws SQLException {
        String query = "SELECT billID FROM BILL ORDER BY billID DESC FETCH FIRST ROW ONLY";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        String lastId = null;
        if (rs.next()) {
            lastId = rs.getString("billID");
        }
        rs.close();
        ps.close();

        if (lastId == null) {
            return "B001"; // Start with the first ID
        } else {
            int num = Integer.parseInt(lastId.substring(1));
            num++;
            return String.format("B%03d", num);
        }
    }
}
