package com.finca.utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailService {

    private static final String SENDER_EMAIL = "tu-correo@gmail.com"; // Reemplaza con tu correo
    private static final String PASSWORD = "tu-clave-de-aplicacion"; // Clave de 16 dígitos generada en Google

    public static void enviarCodigoOTP(String destinatario, String codigo) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        // Propiedad agregada para evitar errores de certificado SSL con Gmail
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
        message.setSubject("Código de Recuperación - Finca La Rosa");
        
        String htmlContent = "<h2>Hola!</h2>" +
                             "<p>Has solicitado recuperar tu contraseña en <b>Finca La Rosa</b>.</p>" +
                             "<h3>Tu código es: <b>" + codigo + "</b></h3>" +
                             "<p>Este código expira en 15 minutos.</p>";
                             
        message.setContent(htmlContent, "text/html; charset=utf-8");
        Transport.send(message);
    }
}