package com.interior.model;

public class Payment {

    private String paymentNo;
    private String date;
    private String remark;
    private double totalPrice;
    private String status;

    public Payment() {
        this.paymentNo = "";
        this.date = "";
        this.remark = "";
        this.totalPrice = 0;
        this.status = "";
    }

    public Payment(String paymentNo, String date, String remark, double totalPrice, String status) {
        this.paymentNo = paymentNo;
        this.date = date;
        this.remark = remark;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    public String getPaymentNo() {
        return paymentNo;
    }

    public String getDate() {
        return date;
    }

    public String getRemark() {
        return remark;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setPaymentNo(String paymentNo) {
        this.paymentNo = paymentNo;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String toString() {
        return "Payment{" + "paymentNo=" + paymentNo + ", date=" + date + ", remark=" + remark + ", totalPrice="
                + totalPrice + ", status=" + status + '}';
    }
}
