package com.finca.services;

import com.finca.dao.AsistenciaDAO;

public class AsistenciaService {

    private final AsistenciaDAO asistenciaDAO = new AsistenciaDAO();

    public String registrarAsistencia(String doc, String tipo) throws Exception {
        return asistenciaDAO.registrarAsistencia(doc, tipo);
    }

    public java.util.List<com.finca.models.Asistencia> obtenerHistorial() {
        return asistenciaDAO.obtenerHistorial();
    }

    public com.finca.models.Asistencia obtenerPorId(int id) {
        return asistenciaDAO.obtenerPorId(id);
    }

    public void generarPdfAsistencia(com.finca.models.Asistencia asistencia, java.io.OutputStream out, String uploadPath) throws Exception {
        com.lowagie.text.Document document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4, 40, 40, 50, 50);
        com.lowagie.text.pdf.PdfWriter writer = com.lowagie.text.pdf.PdfWriter.getInstance(document, out);
        
        document.open();
        
        java.awt.Color brandPrimary = new java.awt.Color(35, 35, 35); // Dark Gray/Black for premium look
        java.awt.Color brandAccent = new java.awt.Color(70, 71, 4); // Finca La Rosa Green
        java.awt.Color lightGray = new java.awt.Color(245, 245, 247);
        java.awt.Color borderColor = new java.awt.Color(220, 220, 225);

        // Header Table with 2 columns (Text left, Image right)
        com.lowagie.text.pdf.PdfPTable headerTable = new com.lowagie.text.pdf.PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[] { 3f, 1f });
        
        // Header Text
        com.lowagie.text.pdf.PdfPCell textCell = new com.lowagie.text.pdf.PdfPCell();
        textCell.setBorder(com.lowagie.text.Rectangle.NO_BORDER);
        
        com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 26, com.lowagie.text.Font.BOLD, brandPrimary);
        com.lowagie.text.Paragraph title = new com.lowagie.text.Paragraph("FINCA LA ROSA", fontTitle);
        textCell.addElement(title);
        
        com.lowagie.text.Font fontSubTitle = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 14, com.lowagie.text.Font.ITALIC, brandAccent);
        com.lowagie.text.Paragraph subtitle = new com.lowagie.text.Paragraph("Comprobante Oficial de Asistencia", fontSubTitle);
        subtitle.setSpacingBefore(5f);
        textCell.addElement(subtitle);
        
        com.lowagie.text.Font fontRef = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 10, com.lowagie.text.Font.NORMAL, java.awt.Color.GRAY);
        com.lowagie.text.Paragraph ref = new com.lowagie.text.Paragraph("REF: AST-" + String.format("%06d", asistencia.getIdAsistencia()), fontRef);
        ref.setSpacingBefore(15f);
        textCell.addElement(ref);
        
        headerTable.addCell(textCell);

        // Profile Picture Cell
        com.lowagie.text.pdf.PdfPCell imgCell = new com.lowagie.text.pdf.PdfPCell();
        imgCell.setBorder(com.lowagie.text.Rectangle.NO_BORDER);
        imgCell.setHorizontalAlignment(com.lowagie.text.Element.ALIGN_RIGHT);
        
        try {
            if (asistencia.getProfilePicture() != null && !asistencia.getProfilePicture().trim().isEmpty()) {
                String imgPath = uploadPath + java.io.File.separator + asistencia.getProfilePicture();
                java.io.File imgFile = new java.io.File(imgPath);
                if (imgFile.exists()) {
                    com.lowagie.text.Image img = com.lowagie.text.Image.getInstance(imgPath);
                    img.scaleAbsolute(90f, 90f);
                    img.setAlignment(com.lowagie.text.Element.ALIGN_RIGHT);
                    imgCell.addElement(img);
                }
            }
        } catch (Exception e) {
            // Silently fail and show no image if it crashes
        }
        headerTable.addCell(imgCell);
        
        document.add(headerTable);
        
        // Divider line
        com.lowagie.text.pdf.PdfPTable divider = new com.lowagie.text.pdf.PdfPTable(1);
        divider.setWidthPercentage(100);
        divider.setSpacingBefore(20f);
        divider.setSpacingAfter(20f);
        com.lowagie.text.pdf.PdfPCell divCell = new com.lowagie.text.pdf.PdfPCell();
        divCell.setBorder(com.lowagie.text.Rectangle.BOTTOM);
        divCell.setBorderColorBottom(brandAccent);
        divCell.setBorderWidthBottom(2f);
        divider.addCell(divCell);
        document.add(divider);

        // Main Data Table
        com.lowagie.text.pdf.PdfPTable table = new com.lowagie.text.pdf.PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[] { 1f, 2f });
        
        com.lowagie.text.Font fontCellHeader = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 11, com.lowagie.text.Font.BOLD, brandPrimary);
        com.lowagie.text.Font fontCellData = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 11, com.lowagie.text.Font.NORMAL, java.awt.Color.DARK_GRAY);
        
        java.util.function.BiConsumer<String, String> addRow = (header, data) -> {
            com.lowagie.text.pdf.PdfPCell cellH = new com.lowagie.text.pdf.PdfPCell(new com.lowagie.text.Phrase(header, fontCellHeader));
            cellH.setBackgroundColor(lightGray);
            cellH.setPadding(10f);
            cellH.setBorderColor(borderColor);
            table.addCell(cellH);
            
            com.lowagie.text.pdf.PdfPCell cellD = new com.lowagie.text.pdf.PdfPCell(new com.lowagie.text.Phrase(data != null ? data : "N/A", fontCellData));
            cellD.setPadding(10f);
            cellD.setBorderColor(borderColor);
            table.addCell(cellD);
        };
        
        String rolStr = asistencia.getRolUsuario();
        if ("1".equals(rolStr) || "Administrador".equalsIgnoreCase(rolStr)) rolStr = "Administrador";
        else if ("2".equals(rolStr) || "Veterinario".equalsIgnoreCase(rolStr)) rolStr = "Veterinario";
        else if ("3".equals(rolStr) || "Operario".equalsIgnoreCase(rolStr)) rolStr = "Operario";

        java.text.SimpleDateFormat sdfTime = new java.text.SimpleDateFormat("hh:mm a");
        String entradaStr = asistencia.getHoraEntrada() != null ? sdfTime.format(asistencia.getHoraEntrada()) : "Sin Registrar";
        String salidaStr = asistencia.getHoraSalida() != null ? sdfTime.format(asistencia.getHoraSalida()) : "Sin Registrar";

        addRow.accept("Empleado", asistencia.getNombreUsuario());
        addRow.accept("Documento (CC)", asistencia.getDocumentoUsuario());
        addRow.accept("Cargo / Rol", asistencia.getCargo() != null && !asistencia.getCargo().trim().isEmpty() ? asistencia.getCargo() : rolStr);
        addRow.accept("Departamento", asistencia.getDepartamento());
        addRow.accept("Teléfono", asistencia.getTelefono());
        addRow.accept("Tipo de Sangre", asistencia.getTipoSangre());
        addRow.accept("Fecha", asistencia.getFecha() != null ? asistencia.getFecha().toString() : "");
        addRow.accept("Hora de Entrada", entradaStr);
        addRow.accept("Hora de Salida", salidaStr);
        addRow.accept("Estado", asistencia.getEstadoAsistencia());
        
        document.add(table);

        // Footer & Signature
        com.lowagie.text.Paragraph espaciador = new com.lowagie.text.Paragraph("\n\n\n\n\n");
        document.add(espaciador);

        com.lowagie.text.Font fontFirma = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 10, com.lowagie.text.Font.BOLD, brandPrimary);
        com.lowagie.text.Paragraph firma = new com.lowagie.text.Paragraph("_____________________________\nDEPARTAMENTO DE RECURSOS HUMANOS", fontFirma);
        firma.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        document.add(firma);
        
        com.lowagie.text.Font fontFooter = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 8, com.lowagie.text.Font.ITALIC, java.awt.Color.GRAY);
        com.lowagie.text.Paragraph footer = new com.lowagie.text.Paragraph("Documento generado automáticamente por el Sistema Finca La Rosa el " + new java.util.Date().toString(), fontFooter);
        footer.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        footer.setSpacingBefore(30f);
        document.add(footer);
        
        document.close();
    }
}
