package com.finca.utils;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.google.gson.JsonObject;

public class EmailService {

    // URL DE TU API PERSONAL EN GOOGLE APPS SCRIPT
    private static final String GOOGLE_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbyQz4uY0bFzBF-1j0p4rKd4KviUKP47hg4lbNpfic2mtEqqcVZXihky0EpkMRsjyP7ONw/exec";

    public static void enviarCodigoOTP(String destinatario, String codigo) throws Exception {

        String htmlContent = """
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <style>
                    body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background-color: #F3F5E7; margin: 0; padding: 40px 20px; -webkit-font-smoothing: antialiased; }
                    .wrapper { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 24px; overflow: hidden; border: 1px solid #E2E4D5; box-shadow: 0 15px 35px rgba(70, 71, 4, 0.08); }
                    .header { background: linear-gradient(135deg, #464704 0%%, #9CA889 100%%); padding: 40px 20px; text-align: center; }
                    .logo-container { background-color: rgba(243, 245, 231, 0.15); border: 1px solid rgba(243, 245, 231, 0.3); border-radius: 18px; width: 64px; height: 64px; margin: 0 auto 15px auto; display: inline-block; padding: 12px; box-sizing: border-box; }
                    .header h1 { margin: 0; color: #ffffff; font-size: 28px; letter-spacing: -0.5px; font-weight: 700; }
                    .content { padding: 45px 40px; color: #423926; line-height: 1.7; text-align: center; }
                    .content h2 { color: #464704; font-size: 24px; margin-top: 0; margin-bottom: 20px; font-weight: 800; }
                    .content p { font-size: 16px; margin-bottom: 20px; color: #555555; }
                    .otp-container { background-color: #F8F9F3; border: 2px dashed #9CA889; border-radius: 20px; padding: 30px 20px; margin: 35px auto; max-width: 400px; }
                    .otp-container p.code { font-size: 42px; font-weight: 800; color: #464704; letter-spacing: 12px; margin: 0; padding-left: 12px; }
                    .warning-text { font-size: 14px !important; color: #7F8C8D !important; background-color: #fcfcfc; padding: 15px; border-radius: 12px; margin-top: 30px; border: 1px solid #E2E4D5; }
                    .footer { background-color: #423926; padding: 30px 40px; text-align: center; color: #B7A78C; font-size: 13px; }
                    .footer p { margin: 5px 0; }
                </style>
            </head>
            <body>
                <div class="wrapper">
                    <div class="header">
                        <div class="logo-container">
                            <img src="https://img.icons8.com/ios/50/F3F5E7/rose.png" alt="Rosa Logo" width="38" height="38" style="display:block; margin:auto; border:0; outline:none;">
                        </div>
                        <h1>Finca La Rosa</h1>
                    </div>
                    <div class="content">
                        <h2>Verificación de Seguridad</h2>
                        <p>Hemos recibido una solicitud para acceder al portal de gestión ganadera desde tu cuenta. Para continuar, ingresa el siguiente código:</p>
                        <div class="otp-container">
                            <p class="code">%s</p>
                        </div>
                        <p>Este código es confidencial y <strong>expirará en 15 minutos</strong>.</p>
                        <div class="warning-text">Si no fuiste tú quien solicitó este acceso, por favor ignora este correo. Tu cuenta sigue estando protegida.</div>
                    </div>
                    <div class="footer">
                        <p><strong>Módulo de Gestión Ganadera e Inventario Bovino</strong></p>
                        <p>&copy; 2026 Finca La Rosa. Todos los derechos reservados.</p>
                        <p style="margin-top: 15px; opacity: 0.6; font-size: 11px;">Este es un mensaje automático del sistema, por favor no respondas a este correo.</p>
                    </div>
                </div>
            </body>
            </html>
            """.formatted(codigo);

        // Construir el JSON esperado por Google Apps Script
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("to", destinatario);
        requestBody.addProperty("subject", "Código de Seguridad - Finca La Rosa");
        requestBody.addProperty("htmlContent", htmlContent);

        // Enviar la petición HTTP POST al script de Google
        HttpClient client = HttpClient.newBuilder()
                .followRedirects(HttpClient.Redirect.NORMAL) // Google usa redirecciones (302)
                .build();
                
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GOOGLE_SCRIPT_URL))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() >= 400) {
            throw new Exception("Error al enviar correo por Google Apps Script. HTTP " + response.statusCode());
        }
    }
}
