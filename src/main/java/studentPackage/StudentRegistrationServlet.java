package studentPackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Base64; // Import Base64 for the attachment

// PDF Generation Imports (iText 7)
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

// ===============================================
// ==         NEW SENDGRID IMPORTS              ==
// ===============================================
import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Attachments;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;


@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 20)
public class StudentRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // --- CONFIGURE YOUR EMAIL SETTINGS HERE ---
    // We get the API key from the environment variables, NOT hard-coded
    private static final String ADMIN_EMAIL = "gorleupendra42@gmail.com";


    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/plain");
        PrintWriter out = res.getWriter();
        System.out.println("Servlet called");
        Connection con = null;
        PreparedStatement psStudentDetails = null;

        try {
            // --- 1. Get All Form Parameters ---
            String name = req.getParameter("fullname");
            String regdno = req.getParameter("regdno");
            String fathername = req.getParameter("fathername");
            String mothername = req.getParameter("mothername");
            String admno = req.getParameter("admno");
            String rank = req.getParameter("rank");
            String adtype = req.getParameter("admtype");
            String joincate = req.getParameter("joincate");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String gender = req.getParameter("gender");
            String village = req.getParameter("village");
            String mandal = req.getParameter("mandal");
            String dist = req.getParameter("dist");
            String dept = req.getParameter("dept");
            String clas = req.getParameter("class");
            String pincode = req.getParameter("pincode");
            String password = req.getParameter("password");

            Part photoPart = req.getPart("photo");
            Part signPart = req.getPart("sign");

            byte[] photoBytes = null;
            if (photoPart != null && photoPart.getSize() > 0) {
                try (InputStream is = photoPart.getInputStream()) {
                    photoBytes = is.readAllBytes();
                }
            }
            byte[] signBytes = null;
            if (signPart != null && signPart.getSize() > 0) {
                try (InputStream is = signPart.getInputStream()) {
                    signBytes = is.readAllBytes();
                }
            }

            // --- 2. Start Transaction ---
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            // --- 3. Insert into 'STUDENTS' details table ---
            String sqlStudentDetails = "INSERT INTO STUDENTS (REGD_NO, NAME, FATHERNAME, MOTHERNAME, ADMNO, RANK, ADTYPE, JOINCATE, EMAIL, PHONE, DOB, GENDER, VILLAGE, MANDAL, DIST, PINCODE, PHOTO, SIGN, PASSWORD, DEPT, CLASS) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psStudentDetails = con.prepareStatement(sqlStudentDetails);
            
            psStudentDetails.setString(1, regdno);
            psStudentDetails.setString(2, name);
            psStudentDetails.setString(3, fathername);
            psStudentDetails.setString(4, mothername);
            psStudentDetails.setString(5, admno);
            psStudentDetails.setInt(6, Integer.parseInt(rank));
            psStudentDetails.setString(7, adtype);
            psStudentDetails.setString(8, joincate);
            psStudentDetails.setString(9, email);
            psStudentDetails.setString(10, phone);

            int day = Integer.parseInt(req.getParameter("date"));
            int month = Integer.parseInt(req.getParameter("month"));
            int year = Integer.parseInt(req.getParameter("year"));
            LocalDate dob = LocalDate.of(year, month, day);
            psStudentDetails.setDate(11, java.sql.Date.valueOf(dob));

            psStudentDetails.setString(12, gender);
            psStudentDetails.setString(13, village);
            psStudentDetails.setString(14, mandal);
            psStudentDetails.setString(15, dist);
            psStudentDetails.setInt(16, Integer.parseInt(pincode));

            if (photoBytes != null) psStudentDetails.setBytes(17, photoBytes); else psStudentDetails.setNull(17, java.sql.Types.BINARY);
            if (signBytes != null) psStudentDetails.setBytes(18, signBytes); else psStudentDetails.setNull(18, java.sql.Types.BINARY);

            String passwordHash = HashPassword.hashPassword(password);
            psStudentDetails.setString(19, passwordHash);
            psStudentDetails.setString(20, dept);
            psStudentDetails.setString(21, clas);

            int studentDetailRows = psStudentDetails.executeUpdate();

            // --- 5. Commit Transaction & Trigger Post-Registration Actions ---
            if (studentDetailRows > 0) {
                con.commit();
                
                try {
                    // 1. Create the PDF in memory
                    byte[] pdfBytes = createPdf(req, photoBytes);
                    
                    // 2. Send the email with PDF attachment (using SendGrid)
                    sendRegistrationEmail(email, name, pdfBytes);
                    out.write("Registration successful! A confirmation has been sent to your email.");

                } catch (Exception postProcessingException) {
                    postProcessingException.printStackTrace();
                    out.write("Registration successful! However, we couldn't send the confirmation email. Please contact support.");
                }

            } else {
                con.rollback();
                out.write("Registration failed. No records were saved.");
            }

        } catch (Exception e) {
            if (con != null) { try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("Error: " + e.getMessage());

        } finally {
            // Closed psParentStudent since it was removed
            try { if (psStudentDetails != null) psStudentDetails.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (out != null) out.close();
        }
    }
    
    // createPdf and addTableRow methods are unchanged...
    
    private byte[] createPdf(HttpServletRequest req, byte[] photoBytes) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf, PageSize.A4);

        document.add(new Paragraph("Student Registration Application Form")
            .setTextAlignment(TextAlignment.CENTER)
            .setBold().setFontSize(18));
        document.add(new Paragraph("Andhra University College of Engineering (A)")
            .setTextAlignment(TextAlignment.CENTER)
            .setFontSize(14));

        if (photoBytes != null) {
            Image photo = new Image(ImageDataFactory.create(photoBytes))
                .setWidth(100f).setHeight(120f)
                .setFixedPosition(pdf.getDefaultPageSize().getWidth() - document.getRightMargin() - 100f, 
                                  pdf.getDefaultPageSize().getHeight() - document.getTopMargin() - 140f);
            document.add(photo);
        }

        document.add(new Paragraph("\n"));

        Table table = new Table(UnitValue.createPercentArray(new float[]{3, 7})).useAllAvailableWidth();
        
        addTableRow(table, "Student Name:", req.getParameter("fullname"));
        addTableRow(table, "Registration No.:", req.getParameter("regdno"));
        addTableRow(table, "Admission No.:", req.getParameter("admno"));
        addTableRow(table, "Father's Name:", req.getParameter("fathername"));
        addTableRow(table, "Mother's Name:", req.getParameter("mothername"));
        addTableRow(table, "Email:", req.getParameter("email"));
        addTableRow(table, "Phone:", req.getParameter("phone"));
        
        LocalDate dob = LocalDate.of(
            Integer.parseInt(req.getParameter("year")),
            Integer.parseInt(req.getParameter("month")),
            Integer.parseInt(req.getParameter("date"))
        );
        addTableRow(table, "Date of Birth:", dob.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")));
        
        addTableRow(table, "Gender:", req.getParameter("gender"));
        addTableRow(table, "Course / Class:", req.getParameter("class"));
        addTableRow(table, "Department:", req.getParameter("dept"));
        addTableRow(table, "Admission Type:", req.getParameter("admtype"));
        addTableRow(table, "Join Category:", req.getParameter("joincate"));
        addTableRow(table, "Rank:", req.getParameter("rank"));
        
        String address = String.join(", ", 
            req.getParameter("village"), 
            req.getParameter("mandal"), 
            req.getParameter("dist") + " - " + req.getParameter("pincode"));
        addTableRow(table, "Address:", address);

        document.add(table);
        document.close();
        
        return baos.toByteArray();
    }
    
    private void addTableRow(Table table, String label, String value) {
        table.addCell(new Cell().add(new Paragraph(label).setBold()).setPadding(5));
        table.addCell(new Cell().add(new Paragraph(value)).setPadding(5));
    }
    
    // ========================================================================
    // ==   THIS IS THE NEW, WORKING sendRegistrationEmail METHOD            ==
    // ========================================================================
    private void sendRegistrationEmail(String studentEmail, String studentName, byte[] pdfBytes) throws Exception {
        
        // 1. Get the API Key from the environment variable (Set this in Render!)
        String sendGridApiKey = System.getenv("SENDGRID_API_KEY");
        
        if (sendGridApiKey == null || sendGridApiKey.isEmpty()) {
            System.err.println("SENDGRID_API_KEY not set. Email will not be sent.");
            // We throw an exception so the user is notified
            throw new Exception("Email service is not configured.");
        }

        // 2. Set up the "From" and "To" email objects
        Email from = new Email(ADMIN_EMAIL); // Your "From" email
        Email to = new Email(studentEmail);  // The student's email
        
        // 3. Set the email subject and content
        String subject = "Registration Confirmation - Andhra University";
        Content content = new Content("text/plain", 
            "Dear " + studentName + ",\n\n" +
            "Thank you for registering. Your application form is attached to this email for your records.\n\n" +
            "Best regards,\nAndhra University Admissions"
        );
        
        // 4. Create the Mail object
        Mail mail = new Mail(from, subject, to, content);
        
        // 5. Add the PDF attachment1
        String pdfBase64 = Base64.getEncoder().encodeToString(pdfBytes);
        Attachments attachment = new Attachments();
        attachment.setContent(pdfBase64);
        attachment.setType("application/pdf");
        attachment.setFilename("ApplicationForm_" + studentName.replaceAll("\\s+", "_") + ".pdf");
        attachment.setDisposition("attachment");
        mail.addAttachments(attachment);

        // 6. Send the email using the SendGrid API
        SendGrid sg = new SendGrid(sendGridApiKey);
        Request request = new Request();
        
        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            
            Response response = sg.api(request);
            
            // Log the response from SendGrid
            System.out.println("SendGrid Response Status Code: " + response.getStatusCode());
            System.out.println("SendGrid Response Body: " + response.getBody());
            
            if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
                // Handle non-successful responses
                throw new IOException("SendGrid request failed: " + response.getBody());
            }

        } catch (IOException ex) {
            System.err.println("Error sending email via SendGrid: " + ex.getMessage());
            throw ex;
        }
    }
}

