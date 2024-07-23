package com.interior.model;

public class Report {

    private String reportID;
    private String title;
    private String desc;
    private String status;

    public Report() {
        this.reportID = "";
        this.title = "";
        this.desc = "";
        this.status = "";
    }

    public Report(String reportID, String title, String desc, String status) {
        this.reportID = reportID;
        this.title = title;
        this.desc = desc;
        this.status = status;
    }

    public String getReportID() {
        return reportID;
    }

    public String getTitle() {
        return title;
    }

    public String getDesc() {
        return desc;
    }

    public String getStatus() {
        return status;
    }

    public void setReportID(String reportID) {
        this.reportID = reportID;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String toString() {
        return "Report{" + "reportID=" + reportID + ", title=" + title + ", desc=" + desc + ", status=" + status + '}';
    }
}
