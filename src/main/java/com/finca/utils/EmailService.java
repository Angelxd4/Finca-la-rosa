package com.finca.utils;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.google.gson.JsonObject;

public class EmailService {

    // URL DE FORMSPREE DEL USUARIO
    private static final String FORMSPREE_URL = "https://formspree.io/f/mjgqeawd";

    public static void enviarCodigoOTP(String destinatario, String codigo) throws Exception {

        // Construir el JSON esperado por Formspree
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("email", destinatario); // El correo de quien "envía" el form
        requestBody.addProperty("subject", "Finca La Rosa - Código de Seguridad");
        requestBody.addProperty("message", "¡Hola! Hemos recibido una solicitud para acceder al portal de Gestión Ganadera.\\n\\nTu código de seguridad (OTP) es: " + codigo + "\\n\\nEste código expirará en 15 minutos.");

        // Enviar la petición HTTP POST a Formspree
        HttpClient client = HttpClient.newHttpClient();
                
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(FORMSPREE_URL))
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() >= 400) {
            throw new Exception("Error al enviar correo por Formspree. HTTP " + response.statusCode());
        }
    }
}
