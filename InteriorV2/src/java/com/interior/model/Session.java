/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.interior.model;

/**
 *
 * @author Iqmal
 */
public class Session {

    private int sessionID;
    private String sessionName;
    private String sessionStatus;

    public Session(int sessionID, String sessionName, String sessionStatus) {
        this.sessionID = sessionID;
        this.sessionName = sessionName;
        this.sessionStatus = sessionStatus;
    }

    public Session() {
        this.sessionID = 0;
        this.sessionName = "N/A";
        this.sessionStatus = "N/A";
    }

    public int getSessionID() {
        return sessionID;
    }

    public void setSessionID(int sessionID) {
        this.sessionID = sessionID;
    }

    public String getSessionName() {
        return sessionName;
    }

    public void setSessionName(String sessionName) {
        this.sessionName = sessionName;
    }

    public String getSessionStatus() {
        return sessionStatus;
    }

    public void setSessionStatus(String sessionStatus) {
        this.sessionStatus = sessionStatus;
    }

}
