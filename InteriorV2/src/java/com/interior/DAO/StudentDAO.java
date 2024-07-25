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

    
     public boolean updateStudentStatus(String studentID, String status) {
        String query = "UPDATE STUDENT SET stdStatus = ? WHERE stdID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, status);
            ps.setString(2, studentID);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
     
    public Student getStudentById(String userId) {
        String query = "SELECT * FROM STUDENT WHERE stdID = ?";
        Student student = null;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                student = new Student();
                student.setStdId(rs.getString("stdID"));
                student.setStdName(rs.getString("stdName"));
                student.setStdIC(rs.getString("stdIC"));
                student.setStdPhone(rs.getString("stdPhone"));
                student.setStdAddress(rs.getString("stdAddress"));
                student.setStdIncome(rs.getDouble("stdIncome"));
                student.setStdParentPhoneNum(rs.getString("stdParentPhoneNum"));
                student.setStdStatus(rs.getString("stdStatus"));
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    public boolean insertStudent(Student student) {
        String query = "INSERT INTO STUDENT (stdID, stdName, stdIC, stdStatus) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            ps.setString(1, student.getStdId());
            ps.setString(2, student.getStdName());
            ps.setString(3, student.getStdIC());
            ps.setString(4, "Active");
            
            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
