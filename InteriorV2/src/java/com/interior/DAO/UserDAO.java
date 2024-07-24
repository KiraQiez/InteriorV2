package com.interior.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.interior.model.User;

public class UserDAO {

    public boolean checkLogin(User user) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT username, password FROM users WHERE username = ? AND password = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            rs = ps.executeQuery();

            status = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (con != null)
                    con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return status;
    }

    public User userInfo(User user) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User userInfo = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT userid, email, username, usertype FROM users WHERE username = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            rs = ps.executeQuery();

            if (rs.next()) {
                userInfo = new User();
                userInfo.setUserid(rs.getString("userid"));
                userInfo.setEmail(rs.getString("email"));
                userInfo.setUsername(rs.getString("username"));
                userInfo.setUsertype(rs.getString("usertype"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (con != null)
                    con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return userInfo;
    }

    public boolean insertUser(User user) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            // Check if username or email already exists
            if (checkIfUserExists(con, user.getUsername(), user.getEmail())) {
                throw new Exception("Username or Email already exists");
            }

            String sql = "INSERT INTO USERS (userid, email, username, password, usertype) VALUES(?,?,?,?,?)";

            String email = user.getEmail();
            String username = user.getUsername();
            String password = user.getPassword();
            String usertype = user.getUsertype();
            String userId = generateUserId(con);

            ps = con.prepareStatement(sql);
            ps.setString(1, userId);
            ps.setString(2, email);
            ps.setString(3, username);
            ps.setString(4, password);
            ps.setString(5, usertype);
         

            int i = ps.executeUpdate();
            if (i > 0) {
                user.setUserid(userId); // Set the generated user ID to the user object
                status = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null)
                    ps.close();
                if (con != null)
                    con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return status;
    }

    private String generateUserId(Connection con) throws Exception {
    String sql = "SELECT userid FROM USERS ORDER BY userid DESC FETCH FIRST ROW ONLY";
    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    String lastId = null;
    if (rs.next()) {
        lastId = rs.getString("userid");
    }
    rs.close();
    ps.close();

    if (lastId == null) {
        return "U0000001"; // Start with the first ID
    } else {
        int num = Integer.parseInt(lastId.substring(1));
        num++;
        return String.format("U%07d", num);
    }
}


    private boolean checkIfUserExists(Connection con, String username, String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM USERS WHERE username = ? OR email = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, email);
        ResultSet rs = ps.executeQuery();

        boolean exists = false;
        if (rs.next()) {
            exists = rs.getInt(1) > 0;
        }
        rs.close();
        ps.close();

        return exists;
    }
    
    
     public boolean updateUser(User user) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE USERS SET username = ?, email = ?, password = ?, userType = ? WHERE userID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getUsertype());
            ps.setString(5, user.getUserid());

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

public boolean deleteUser(String userID) {
    boolean status = false;
    Connection con = null;
    PreparedStatement ps = null;

    try {
        con = DBConnection.getConnection();
        String sql = "DELETE FROM USERS WHERE userid = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, userID);

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
