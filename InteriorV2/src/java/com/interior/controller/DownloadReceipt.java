package com.interior.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

public class DownloadReceipt extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"receipt.pdf\"");

        Document document = new Document();
        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Add logo
            String logoPath = getServletContext().getRealPath("web/rsc/images/logo.svg");
            try {
                Image logo = Image.getInstance(logoPath);
                logo.scaleToFit(100, 100);
                logo.setAlignment(Element.ALIGN_CENTER);
                document.add(logo);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Add header
            Paragraph header = new Paragraph("Interior Company", new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD));
            header.setAlignment(Element.ALIGN_CENTER);
            header.setSpacingAfter(20);
            document.add(header);

            // Add title
            Paragraph title = new Paragraph("Receipt", new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD));
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Add Bill ID
            Paragraph billId = new Paragraph("Bill ID: " + request.getParameter("billID"), new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL));
            billId.setSpacingAfter(20);
            document.add(billId);

            // Add User Details
            Paragraph userDetails = new Paragraph("User Details", new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
            userDetails.setSpacingAfter(10);
            document.add(userDetails);

            addUserInfo(document, "Full Name", request.getParameter("fullName"));
            addUserInfo(document, "Address", request.getParameter("address"));
            addUserInfo(document, "Phone No", request.getParameter("phoneNo"));

            // Add separator line
            Paragraph separator = new Paragraph("--------------------------------------------------------------------------------");
            separator.setAlignment(Element.ALIGN_CENTER);
            separator.setSpacingAfter(20);
            document.add(separator);

            // Add Bill Type Table
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            // Set column widths
            float[] columnWidths = {3f, 1f};
            table.setWidths(columnWidths);

            // Add table headers
            addTableHeader(table, "Bill Type");
            addTableHeader(table, "Quantity");

            // Add table data (example static content for now, replace with actual bill details)
            addTableData(table, request.getParameter("billType"), "1");

            document.add(table);

            // Add another separator line
            Paragraph separator2 = new Paragraph("--------------------------------------------------------------------------------");
            separator2.setAlignment(Element.ALIGN_CENTER);
            separator2.setSpacingAfter(20);
            document.add(separator2);

            // Add Total Amount
            Paragraph total = new Paragraph("Total: " + request.getParameter("amount"), new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD));
            total.setAlignment(Element.ALIGN_RIGHT);
            total.setSpacingAfter(20);
            document.add(total);

            // Add Payment Details
            addPaymentInfo(document, "Payment Date", request.getParameter("paymentDate"));
            addPaymentInfo(document, "Payment ID", request.getParameter("paymentID"));

            // Add footer
            Paragraph footer = new Paragraph("Interior Company - Your satisfaction is our priority.", new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC));
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(50);
            document.add(footer);

        } catch (DocumentException e) {
            throw new IOException(e);
        } finally {
            document.close();
        }
    }

    private void addUserInfo(Document document, String label, String value) throws DocumentException {
        Paragraph paragraph = new Paragraph(label + ": " + value, new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL));
        paragraph.setSpacingAfter(10);
        document.add(paragraph);
    }

    private void addTableHeader(PdfPTable table, String headerTitle) {
        Font font = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        PdfPCell cell = new PdfPCell(new Phrase(headerTitle, font));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(10);
        table.addCell(cell);
    }

    private void addTableData(PdfPTable table, String description, String quantity) {
        Font font = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
        PdfPCell descriptionCell = new PdfPCell(new Phrase(description, font));
        descriptionCell.setPadding(10);
        table.addCell(descriptionCell);

        PdfPCell quantityCell = new PdfPCell(new Phrase(quantity, font));
        quantityCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        quantityCell.setPadding(10);
        table.addCell(quantityCell);
    }

    private void addPaymentInfo(Document document, String label, String value) throws DocumentException {
        Paragraph paragraph = new Paragraph(label + ": " + value, new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL));
        paragraph.setSpacingAfter(10);
        document.add(paragraph);
    }
}
