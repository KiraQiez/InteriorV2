/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.model;
import java.util.Base64;

/**
 *
 * @author AkiraVI
 */
public class User {
    private String userid;
    private String username;
    private String password;
    private String email;
    private String usertype;
    private byte[] image;

    public User() {
        userid = "";
        username = "";
        password = "";
        email = "";
        usertype = "Student";

    }

    public User(User user) {
        this.userid = user.userid;
        this.username = user.username;
        this.password = user.password;
        this.email = user.email;
        this.usertype = user.usertype;
        this.image = user.image;
    }

    public User(String userid, String username, String password, String email, String usertype, byte[] image) {
        this.userid = userid;
        this.username = username;
        this.password = password;
        this.email = email;
        this.usertype = usertype;
        this.image = image;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsertype() {
        return usertype;
    }

    public void setUsertype(String usertype) {
        this.usertype = usertype;
    }

    public String getUserImage() {
        return null;
    }

    public void setUserImage(byte[] image) {
        this.image = image;
    }


    @Override
    public String toString() {
        return "User{" + "userid=" + userid + ", username=" + username + ", password=" + password + ", email=" + email
                + ", usertype=" + usertype + '}';
    }

}
