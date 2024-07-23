/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.model;

/**
 *
 * @author AkiraVI
 */
public class Student {

    private String stdID;
    private String name;
    private String phone;
    private String address;
    private double income;
    private String parentPhoneNum;

    // default
    public Student() {
        this.stdID = "";
        this.name = "";
        this.phone = "";
        this.address = "";
        this.income = 0;
        this.parentPhoneNum = "";
    }

    // normal
    public Student(String stdID, String name, String phone, String address, double income, String parentPhoneNum) {
        this.stdID = stdID;
        this.name = name;
        this.phone = phone;
        this.address = address;
        this.income = income;
        this.parentPhoneNum = parentPhoneNum;
    }

    public String toString() {
        return "Student{" + "stdID=" + stdID + ", name=" + name + ", phone=" + phone + ", address=" + address
                + ", income=" + income + ", parentPhoneNum=" + parentPhoneNum + '}';
    }

    // getter
    public String getStdID() {
        return stdID;
    }

    public String getName() {
        return name;
    }

    public String getPhone() {
        return phone;
    }

    public String getAddress() {
        return address;
    }

    public double getIncome() {
        return income;
    }

    public String getParentPhoneNum() {
        return parentPhoneNum;
    }

    // setter
    public void setStdID(String stdID) {
        this.stdID = stdID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setIncome(double income) {
        this.income = income;
    }

    public void setParentPhoneNum(String parentPhoneNum) {
        this.parentPhoneNum = parentPhoneNum;
    }
}
