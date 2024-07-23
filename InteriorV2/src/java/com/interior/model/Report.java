package com.interior.model;

public class Report {

    private String reportNo;
    private String title;
    private String desc;
    private String status;

    public Report() {
        this.reportNo = "";
        this.title = "";
        this.desc = "";
        this.status = "";
    }

    public Report(String reportNo, String title, String desc, String status) {
        this.reportNo = reportNo;
        this.title = title;
        this.desc = desc;
        this.status = status;
    }

    public String getReportNo() {
        return reportNo;
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

    public void setReportNo(String reportNo) {
        this.reportNo = reportNo;
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
        return "Report{" + "reportNo=" + reportNo + ", title=" + title + ", desc=" + desc + ", status=" + status + '}';
    }
}
