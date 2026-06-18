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
            // Asegurarse de que el número comience con el código de país
            if (!telefono.startsWith("+")) {
                telefono = "+" + telefono;
            }

            // Enviamos un mensaje libre directo (Sin plantillas HX...)
            // Nota: Para que esto funcione, el celular de prueba debe haberle enviado
            // el código de "join [palabra]" al bot de Twilio en las últimas 24 horas.
            Message twilioMsg = Message.creator(
                new PhoneNumber("whatsapp:" + telefono),
                new PhoneNumber(TWILIO_NUMBER),
                "🐄 *Finca La Rosa*\n\nTienes un nuevo aviso:\n" + mensaje
            ).create();

            System.out.println("✅ WhatsApp (Libre) enviado a: " + telefono + " | SID: " + twilioMsg.getSid());
        } catch (Exception e) {
            System.err.println("❌ Fallo interno enviando WhatsApp libre: " + e.getMessage());
        }
    }
}
