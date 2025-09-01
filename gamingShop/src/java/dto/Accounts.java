/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.util.Date;

/**
 *
 * @author MSI PC
 */
public class Accounts {
    private int id;
    private String username;
    private String password_hash;
    private String email;
    private String full_name;
    private String phone;
    private Date created_ad;
    private Date update_ad;

    public Accounts() {
    }

    public Accounts(int id, String username, String password_hash, String email, String full_name, String phone, Date created_ad, Date update_ad) {
        this.id = id;
        this.username = username;
        this.password_hash = password_hash;
        this.email = email;
        this.full_name = full_name;
        this.phone = phone;
        this.created_ad = created_ad;
        this.update_ad = update_ad;
    }

    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public String getEmail() {
        return email;
    }

    public String getFull_name() {
        return full_name;
    }

    public String getPhone() {
        return phone;
    }

    public Date getCreated_ad() {
        return created_ad;
    }

    public Date getUpdate_ad() {
        return update_ad;
    }
    
    
}
