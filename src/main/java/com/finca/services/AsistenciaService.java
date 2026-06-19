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

    public void generarPdfAsistencia(com.finca.models.Asistencia asistencia, java.io.OutputStream out) throws Exception {
        com.lowagie.text.Document document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4, 50, 50, 50, 50);
        com.lowagie.text.pdf.PdfWriter writer = com.lowagie.text.pdf.PdfWriter.getInstance(document, out);
        
        document.open();
        
        // Colores de la paleta
        java.awt.Color brandPrimary = new java.awt.Color(70, 71, 4); // #464704
        java.awt.Color brandInfo = new java.awt.Color(156, 168, 137); // #9CA889
        java.awt.Color lightGray = new java.awt.Color(245, 245, 247);
        
        // Título Principal
        com.lowagie.text.Font fontTitle = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 24, com.lowagie.text.Font.BOLD, brandPrimary);
        com.lowagie.text.Paragraph title = new com.lowagie.text.Paragraph("FINCA LA ROSA", fontTitle);
        title.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        document.add(title);
        
        com.lowagie.text.Font fontSubTitle = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 14, com.lowagie.text.Font.NORMAL, brandInfo);
        com.lowagie.text.Paragraph subtitle = new com.lowagie.text.Paragraph("Comprobante Oficial de Asistencia", fontSubTitle);
        subtitle.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        subtitle.setSpacingAfter(30f);
        document.add(subtitle);
        
        // Tabla de datos
        com.lowagie.text.pdf.PdfPTable table = new com.lowagie.text.pdf.PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(20f);
        table.setWidths(new float[] { 1.2f, 2f });
        
        com.lowagie.text.Font fontCellHeader = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 11, com.lowagie.text.Font.BOLD, java.awt.Color.WHITE);
        com.lowagie.text.Font fontCellData = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 11, com.lowagie.text.Font.NORMAL, java.awt.Color.DARK_GRAY);
        
        // Función auxiliar para agregar filas
        java.util.function.BiConsumer<String, String> addRow = (header, data) -> {
            com.lowagie.text.pdf.PdfPCell cellHeader = new com.lowagie.text.pdf.PdfPCell(new com.lowagie.text.Phrase(header, fontCellHeader));
            cellHeader.setBackgroundColor(brandPrimary);
            cellHeader.setPadding(12f);
            cellHeader.setBorderColor(java.awt.Color.WHITE);
            cellHeader.setBorderWidthBottom(1f);
            table.addCell(cellHeader);
            
            com.lowagie.text.pdf.PdfPCell cellData = new com.lowagie.text.pdf.PdfPCell(new com.lowagie.text.Phrase(data != null ? data : "N/A", fontCellData));
            cellData.setBackgroundColor(lightGray);
            cellData.setPadding(12f);
            cellData.setBorderColor(java.awt.Color.WHITE);
            cellData.setBorderWidthBottom(1f);
            table.addCell(cellData);
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
        addRow.accept("Teléfono", asistencia.getTelefono());
        
        String cargoMostrar = asistencia.getCargo() != null && !asistencia.getCargo().trim().isEmpty() ? asistencia.getCargo() : rolStr;
        addRow.accept("Cargo / Rol", cargoMostrar);
        addRow.accept("Departamento", asistencia.getDepartamento());
        addRow.accept("EPS", asistencia.getEps());
        addRow.accept("ARL", asistencia.getArl());
        addRow.accept("Tipo de Sangre", asistencia.getTipoSangre());
        
        addRow.accept("Fecha", asistencia.getFecha() != null ? asistencia.getFecha().toString() : "");
        addRow.accept("Hora de Entrada", entradaStr);
        addRow.accept("Hora de Salida", salidaStr);
        addRow.accept("Estado de Ingreso", asistencia.getEstadoAsistencia());
        
        document.add(table);
        
        // Espaciador antes de la firma
        com.lowagie.text.Paragraph espaciador = new com.lowagie.text.Paragraph("\n\n\n\n");
        document.add(espaciador);

        // Sello
        com.lowagie.text.Font fontFirma = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 10, com.lowagie.text.Font.NORMAL, java.awt.Color.DARK_GRAY);
        com.lowagie.text.Paragraph firma = new com.lowagie.text.Paragraph("_____________________________\nFirma Autorizada", fontFirma);
        firma.setAlignment(com.lowagie.text.Element.ALIGN_RIGHT);
        firma.setSpacingBefore(40f);
        firma.setSpacingAfter(20f);
        document.add(firma);
        
        com.lowagie.text.Font fontFooter = new com.lowagie.text.Font(com.lowagie.text.Font.HELVETICA, 9, com.lowagie.text.Font.ITALIC, java.awt.Color.GRAY);
        com.lowagie.text.Paragraph footer = new com.lowagie.text.Paragraph("Documento generado automáticamente por el Sistema de Gestión Ganadera Finca La Rosa.\n" + new java.util.Date().toString(), fontFooter);
        footer.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        document.add(footer);
        
        document.close();
    }
}
