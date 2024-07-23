package com.interior.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.interior.model.Student;

public class StudentDAO {

    // Method to update student profile
    public boolean updateStudentProfile(String userId, String name, String phone, String address, String income, String parentPhone) {
        String query = "UPDATE STUDENT SET stdName = ?, stdphone = ?, stdaddress = ?, stdincome = ?, stdparentphonenum = ? WHERE STDID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, income);
            ps.setString(5, parentPhone);
            ps.setString(6, userId);
            
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to get student info based on userId
    public Student getStudentById(int userId) {
        String query = "SELECT * FROM STUDENT WHERE STDID = ?";
        Student student = null;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                student = new Student();
                student.setStdId(rs.getString("stdid"));
                student.setStdName(rs.getString("stdName"));
                student.setStdIC(rs.getString("stdic"));
                student.setStdPhone(rs.getString("stdphone"));
                student.setStdAddress(rs.getString("stdaddress"));
                student.setStdIncome(rs.getDouble("stdincome"));
                student.setStdParentPhoneNum(rs.getString("stdparentphonenum"));
                student.setStdStatus(rs.getString("stdstatus"));
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
}
