package com.interior.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import com.interior.model.Booking;

public class BookingDAO {

    public boolean addBooking(Booking booking) {
        String query = "INSERT INTO BOOKING (bookingID, bookingDate, bookstatus, stdID, roomID, SESSIONID) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setString(1, generateBookingID(con));
            ps.setDate(2, booking.getBookingDate());
            ps.setString(3, booking.getBookstatus());
            ps.setString(4, booking.getStdID());
            ps.setString(5, booking.getRoomID());
            ps.setInt(6, booking.getSessionID());
            
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String generateBookingID(Connection con) throws SQLException {
        String query = "SELECT bookingID FROM BOOKING ORDER BY bookingID DESC FETCH FIRST ROW ONLY";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        String lastId = null;
        if (rs.next()) {
            lastId = rs.getString("bookingID");
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
}
