package com.interior.DAO;

import com.interior.model.Room;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getRoomsByBlockAndType(String blockID, String roomType) {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT roomID FROM ROOM WHERE blockID = ? AND roomType = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, blockID);
            ps.setString(2, roomType);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Room room = new Room();
                room.setRoomID(rs.getString("roomID"));
                rooms.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public String generateRoomID(String blockID) {
        String roomID = null;
        String query = "SELECT COUNT(roomID) AS roomCount FROM ROOM WHERE blockID = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, blockID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt("roomCount") + 1;
                roomID = blockID + String.format("%03d", count);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return roomID;
    }

    public void addRoom(Room room) {
        String query = "INSERT INTO ROOM (roomID, blockID, roomType, maxCapacity, availability) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, room.getRoomID());
            ps.setString(2, room.getBlockID());
            ps.setString(3, room.getRoomType());
            ps.setInt(4, room.getMaxCapacity());
            ps.setInt(5, room.getMaxCapacity());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteRoom(String roomID) {
        String query = "DELETE FROM ROOM WHERE roomID = ?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, roomID);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateRoomAvailability(Room room) {
        String query = "UPDATE ROOM SET AVAILABILITY = AVAILABILITY - 1 WHERE ROOMID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, room.getRoomID());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void roomAvailabilityAfterCheckOut(Room room) {
        String query = "UPDATE ROOM SET AVAILABILITY = AVAILABILITY + 1 WHERE ROOMID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, room.getRoomID());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
