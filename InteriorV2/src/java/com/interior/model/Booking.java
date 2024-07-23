package com.interior.model;

public class Booking {

    private String ID;
    private String date;
    private String checkIn;
    private String checkOut;

    public Booking() {
        this.ID = "";
        this.date = "";
        this.checkIn = "";
        this.checkOut = "";
    }

    public Booking(String ID, String date, String checkIn, String checkOut) {
        this.ID = ID;
        this.date = date;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
    }

    public String getID() {
        return ID;
    }

    public String getDate() {
        return date;
    }

    public String getCheckIn() {
        return checkIn;
    }

    public String getCheckOut() {
        return checkOut;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setCheckIn(String checkIn) {
        this.checkIn = checkIn;
    }

    public void setCheckOut(String checkOut) {
        this.checkOut = checkOut;
    }

    public String toString() {
        return "Booking{" + "ID=" + ID + ", date=" + date + ", checkIn=" + checkIn + ", checkOut=" + checkOut + '}';
    }

}
