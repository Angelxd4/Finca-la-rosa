package com.finca.controllers;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.awt.Color;

import com.finca.dao.BovinoDAO;
import com.finca.models.Bovino;
import com.finca.services.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@WebServlet("/reporte-pdf")
public class ReportePdfServlet extends HttpServlet {

    private final BovinoDAO bovinoDAO = new BovinoDAO();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        if (!authService.estaAutenticado(request)) {
            response.sendRedirect("login");
            return;
        }
        if (authService.esCliente(request)) {
            response.sendRedirect("catalogo");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"Reporte_Ejecutivo_Finca.pdf\"");

        try (OutputStream out = response.getOutputStream()) {
            
            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            PdfWriter.getInstance(document, out);
            document.open();

            // 1. TÍTULO Y ENCABEZADO
            Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, new Color(70, 71, 4)); // Color Moss Green
            Paragraph titulo = new Paragraph("FINCA LA ROSA", fontTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            document.add(titulo);

            Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA, 14, new Color(66, 57, 38)); // Drab
            Paragraph subtitulo = new Paragraph("Reporte Ejecutivo de Inventario y Estado General", fontSubtitulo);
            subtitulo.setAlignment(Element.ALIGN_CENTER);
            subtitulo.setSpacingAfter(20);
            document.add(subtitulo);

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Paragraph fecha = new Paragraph("Generado el: " + sdf.format(new Date()), FontFactory.getFont(FontFactory.HELVETICA, 10));
            fecha.setAlignment(Element.ALIGN_RIGHT);
            fecha.setSpacingAfter(30);
            document.add(fecha);

            // 2. EXTRACCIÓN DE DATOS
            List<Bovino> todos = bovinoDAO.obtenerTodos();
            int total = todos.size();
            int enProduccion = 0;
            int enVenta = 0;
            int crias = 0;
            int toros = 0;

            for (Bovino b : todos) {
                if ("Producción".equalsIgnoreCase(b.getClasificacion())) enProduccion++;
                else if ("Venta".equalsIgnoreCase(b.getClasificacion())) enVenta++;
                else if ("Cría".equalsIgnoreCase(b.getClasificacion())) crias++;
                else if ("Toro".equalsIgnoreCase(b.getClasificacion())) toros++;
            }

            // 3. TABLA DE RESUMEN DE HATO
            PdfPTable tablaResumen = new PdfPTable(2);
            tablaResumen.setWidthPercentage(80);
            tablaResumen.setSpacingBefore(10f);
            tablaResumen.setSpacingAfter(30f);

            Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Color.WHITE);
            Color headerBg = new Color(138, 159, 109); // Sage Green

            PdfPCell cellCol1 = new PdfPCell(new Phrase("Clasificación", fontHeader));
            cellCol1.setBackgroundColor(headerBg);
            cellCol1.setPadding(8);
            tablaResumen.addCell(cellCol1);

            PdfPCell cellCol2 = new PdfPCell(new Phrase("Cantidad Total", fontHeader));
            cellCol2.setBackgroundColor(headerBg);
            cellCol2.setPadding(8);
            tablaResumen.addCell(cellCol2);

            Font fontData = FontFactory.getFont(FontFactory.HELVETICA, 12);
            Color rowBg = new Color(243, 245, 231); // Ivory light

            agregarFila(tablaResumen, "Vacas en Producción", String.valueOf(enProduccion), fontData, rowBg);
            agregarFila(tablaResumen, "Vacas Secas / Venta", String.valueOf(enVenta), fontData, Color.WHITE);
            agregarFila(tablaResumen, "Terneros / Crías", String.valueOf(crias), fontData, rowBg);
            agregarFila(tablaResumen, "Toros Sementales", String.valueOf(toros), fontData, Color.WHITE);
            
            Font fontBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            agregarFila(tablaResumen, "TOTAL DEL HATO", String.valueOf(total), fontBold, new Color(212, 196, 168)); // Khaki light

            document.add(new Paragraph("Resumen del Hato Ganadero", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, new Color(70, 71, 4))));
            document.add(tablaResumen);

            // 4. TABLA DE LOS 10 BOVINOS MÁS RECIENTES
            document.add(new Paragraph("Últimos Registros del Inventario", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, new Color(70, 71, 4))));
            
            PdfPTable tablaBovinos = new PdfPTable(4);
            tablaBovinos.setWidthPercentage(100);
            tablaBovinos.setSpacingBefore(10f);
            tablaBovinos.setWidths(new float[]{2f, 3f, 2f, 3f});

            String[] cabeceras = {"Arete", "Raza", "Peso (Kg)", "Clasificación"};
            for (String cabecera : cabeceras) {
                PdfPCell c = new PdfPCell(new Phrase(cabecera, fontHeader));
                c.setBackgroundColor(headerBg);
                c.setPadding(6);
                tablaBovinos.addCell(c);
            }

            int limite = Math.min(10, todos.size());
            for (int i = 0; i < limite; i++) {
                Bovino b = todos.get(i);
                Color cBg = (i % 2 == 0) ? rowBg : Color.WHITE;
                
                PdfPCell c1 = new PdfPCell(new Phrase(b.getNumeroArete(), fontData)); c1.setBackgroundColor(cBg); c1.setPadding(5);
                PdfPCell c2 = new PdfPCell(new Phrase(b.getRaza(), fontData)); c2.setBackgroundColor(cBg); c2.setPadding(5);
                PdfPCell c3 = new PdfPCell(new Phrase(String.valueOf(b.getPesoKg()), fontData)); c3.setBackgroundColor(cBg); c3.setPadding(5);
                PdfPCell c4 = new PdfPCell(new Phrase(b.getClasificacion(), fontData)); c4.setBackgroundColor(cBg); c4.setPadding(5);
                
                tablaBovinos.addCell(c1);
                tablaBovinos.addCell(c2);
                tablaBovinos.addCell(c3);
                tablaBovinos.addCell(c4);
            }

            document.add(tablaBovinos);

            // Pie de página
            Paragraph footer = new Paragraph("\nEste reporte es generado automáticamente por el sistema de Gestión Ganadera Finca La Rosa.", FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 9, Color.GRAY));
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar el PDF");
        }
    }

    private void agregarFila(PdfPTable tabla, String col1, String col2, Font font, Color bgColor) {
        PdfPCell c1 = new PdfPCell(new Phrase(col1, font));
        c1.setBackgroundColor(bgColor);
        c1.setPadding(8);
        tabla.addCell(c1);

        PdfPCell c2 = new PdfPCell(new Phrase(col2, font));
        c2.setBackgroundColor(bgColor);
        c2.setPadding(8);
        tabla.addCell(c2);
    }
}
