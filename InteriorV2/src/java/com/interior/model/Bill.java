/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.model;

public class Bill {
    private String billID;
    private String billType;
    private double totalAmount;
    private String stdID;
    private String paymentID;

    public Bill(String billID, String billType, double totalAmount, String stdID, String paymentID) {
        this.billID = billID;
        this.billType = billType;
        this.totalAmount = totalAmount;
        this.stdID = stdID;
        this.paymentID = paymentID;
    }
    
    public Bill() {
        this.billID = null;
        this.billType = null;
        this.totalAmount = 0;
        this.stdID = null;
        this.paymentID = null;
    }

    public String getBillID() {
        return billID;
    }

    public void setBillID(String billID) {
        this.billID = billID;
    }

    public String getBillType() {
        return billType;
    }

    public void setBillType(String billType) {
        this.billType = billType;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStdID() {
        return stdID;
    }

    public void setStdID(String stdID) {
        this.stdID = stdID;
    }

    public String getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(String paymentID) {
        this.paymentID = paymentID;
    }
    
    
}
