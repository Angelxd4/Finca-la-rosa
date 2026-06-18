package com.finca.utils;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

public class WhatsAppService {

    public static final String ACCOUNT_SID = "ACe422a16dcdf72ca2b32c2806d4e45120";
    public static final String AUTH_TOKEN = "1e3acd729c0b32ece8ed1b2bce0cb04e";
    public static final String TWILIO_NUMBER = "whatsapp:+14155238886";

    // Static block to initialize Twilio once
    static {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
    }

    public static void enviarWhatsAppAutomatico(String telefono, String mensaje) {
        try {
            if (!telefono.startsWith("+")) {
                telefono = "+" + telefono;
            }

            // Twilio rechaza \n o tabulaciones en variables de plantillas de WhatsApp
            String cleanMensaje = mensaje.replaceAll("[\\n\\r\\t]+", " ").replaceAll("\\s{2,}", " ").trim();

            java.util.Map<String, String> variables = new java.util.HashMap<>();
            variables.put("1", "Finca La Rosa");
            variables.put("2", cleanMensaje);
            
            String jsonVariables = new com.google.gson.Gson().toJson(variables);

            // IMPORTANTE: Cuando se usa Content API, el body debe ser omitido o nulo.
            Message twilioMsg = Message.creator(
                new PhoneNumber("whatsapp:" + telefono),
                new PhoneNumber(TWILIO_NUMBER),
                (String) null
            )
            .setContentSid("HXb5b62575e6e4ff6129ad7c8efe1f983e")
            .setContentVariables(jsonVariables)
            .create();

            System.out.println("✅ WhatsApp enviado por Twilio a: " + telefono + " | SID: " + twilioMsg.getSid());
        } catch (Exception e) {
            System.err.println("❌ Fallo interno enviando WhatsApp por Twilio: " + e.getMessage());
        }
    }
}
