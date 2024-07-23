package com.interior.model;

public class Student {
    private String stdId;
    private String stdName;
    private String stdIC;
    private String stdPhone;
    private String stdAddress;
    private double stdIncome;
    private String stdParentPhoneNum;
    private String stdStatus;

    public Student() {
        this.stdId = "";
        this.stdName = "";
        this.stdIC = "";
        this.stdPhone = "";
        this.stdAddress = "";
        this.stdIncome = 0.0;
        this.stdParentPhoneNum = "";
        this.stdStatus = "";
    }

    public Student(String stdId, String stdName, String stdIC, String stdPhone, String stdAddress, double stdIncome, String stdParentPhoneNum, String stdStatus) {
        this.stdId = stdId;
        this.stdName = stdName;
        this.stdIC = stdIC;
        this.stdPhone = stdPhone;
        this.stdAddress = stdAddress;
        this.stdIncome = stdIncome;
        this.stdParentPhoneNum = stdParentPhoneNum;
        this.stdStatus = stdStatus;
    }

    // Getters and Setters
    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getStdName() {
        return stdName;
    }

    public void setStdName(String stdName) {
        this.stdName = stdName;
    }

    public String getStdIC() {
        return stdIC;
    }

    public void setStdIC(String stdIC) {
        this.stdIC = stdIC;
    }

    public String getStdPhone() {
        return stdPhone;
    }

    public void setStdPhone(String stdPhone) {
        this.stdPhone = stdPhone;
    }

    public String getStdAddress() {
        return stdAddress;
    }

    public void setStdAddress(String stdAddress) {
        this.stdAddress = stdAddress;
    }

    public double getStdIncome() {
        return stdIncome;
    }

    public void setStdIncome(double stdIncome) {
        this.stdIncome = stdIncome;
    }

    public String getStdParentPhoneNum() {
        return stdParentPhoneNum;
    }

    public void setStdParentPhoneNum(String stdParentPhoneNum) {
        this.stdParentPhoneNum = stdParentPhoneNum;
    }

    public String getStdStatus() {
        return stdStatus;
    }

    public void setStdStatus(String stdStatus) {
        this.stdStatus = stdStatus;
    }

    @Override
    public String toString() {
        return "Student{" +
                "stdId='" + stdId + '\'' +
                ", stdName='" + stdName + '\'' +
                ", stdIC='" + stdIC + '\'' +
                ", stdPhone='" + stdPhone + '\'' +
                ", stdAddress='" + stdAddress + '\'' +
                ", stdIncome=" + stdIncome +
                ", stdParentPhoneNum='" + stdParentPhoneNum + '\'' +
                ", stdStatus='" + stdStatus + '\'' +
                '}';
    }
}
