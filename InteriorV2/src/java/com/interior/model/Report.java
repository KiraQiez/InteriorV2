package com.interior.model;

public class Report {

    private String reportID;
    private String title;
    private String desc;
    private String status;
    private String handledByStaffID;
    private String checkedByStaffID;

    public Report() {
        this.reportID = "";
        this.title = "";
        this.desc = "";
        this.status = "";
        this.handledByStaffID = "";
        this.checkedByStaffID = "";
    }

    public Report(String reportID, String title, String desc, String status, String handledByStaffID, String checkedByStaffID) {
        this.reportID = reportID;
        this.title = title;
        this.desc = desc;
        this.status = status;
        this.handledByStaffID = handledByStaffID;
        this.checkedByStaffID = checkedByStaffID;
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

    public String getReportStatus() {
        return status;
    }

    public String getHandledByStaffID() {
        return handledByStaffID;
    }

    public String getCheckedByStaffID() {
        return checkedByStaffID;
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

    public void setReportStatus(String status) {
        this.status = status;
    }

    public void setHandledByStaffID(String handledByStaffID) {
        this.handledByStaffID = handledByStaffID;
    }

    public void setCheckedByStaffID(String checkedByStaffID) {
        this.checkedByStaffID = checkedByStaffID;
    }

    @Override
    public String toString() {
        return "Report{" +
                "reportID='" + reportID + '\'' +
                ", title='" + title + '\'' +
                ", desc='" + desc + '\'' +
                ", status='" + status + '\'' +
                ", handledByStaffID='" + handledByStaffID + '\'' +
                ", checkedByStaffID='" + checkedByStaffID + '\'' +
                '}';
    }
}
