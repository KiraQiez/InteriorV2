package com.interior.model;

public class Staff {

    private String staffID;
    private String name;
    private String staffType;

    // default
    public Staff() {
        this.staffID = "";
        this.name = "";
        this.staffType = "";
    }

    // normal
    public Staff(String staffID, String name, String staffType) {
        this.staffID = staffID;
        this.name = name;
        this.staffType = staffType;
    }

    // getter
    public String getStaffID() {
        return staffID;
    }

    public String getName() {
        return name;
    }

    public String getStaffType() {
        return staffType;
    }

    // setter
    public void setStaffID(String staffID) {
        this.staffID = staffID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setStaffType(String staffType) {
        this.staffType = staffType;
    }

    public String toString() {
        return "Staff{" + "staffID=" + staffID + ", name=" + name + ", staffType=" + staffType + '}';
    }
}
