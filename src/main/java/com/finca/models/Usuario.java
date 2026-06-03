package com.finca.models;

public class Usuario {
    private int id;
    private String fullName;
    private String documentId;
    private String email;
    private String password;
    private int roleId;
    private String barcode;
    private String profilePicture;

    public Usuario() {}

    // Getters
    public int getId() { return id; }
    public String getFullName() { return fullName; }
    public String getDocumentId() { return documentId; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public int getRoleId() { return roleId; }
    public String getBarcode() { return barcode; }
    public String getProfilePicture() { return profilePicture; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setDocumentId(String documentId) { this.documentId = documentId; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
}