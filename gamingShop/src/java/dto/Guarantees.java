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
public class Guarantees {
    private int id;
    private String guarantee_type;
    private String description_html;
    private Date created_ad;
    private Date update_ad;

    public Guarantees() {
    }

    public Guarantees(int id, String guarantee_type, String description_html, Date created_ad, Date update_ad) {
        this.id = id;
        this.guarantee_type = guarantee_type;
        this.description_html = description_html;
        this.created_ad = created_ad;
        this.update_ad = update_ad;
    }
    
    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getGuarantee_type() {
        return guarantee_type;
    }

    public void setGuarantee_type(String guarantee_type) {
        this.guarantee_type = guarantee_type;
    }

    public String getDescription_html() {
        return description_html;
    }

    public void setDescription_html(String description_html) {
        this.description_html = description_html;
    }

    public Date getCreated_ad() {
        return created_ad;
    }

    public void setCreated_ad(Date created_ad) {
        this.created_ad = created_ad;
    }

    public Date getUpdate_ad() {
        return update_ad;
    }

    public void setUpdate_ad(Date update_ad) {
        this.update_ad = update_ad;
    }
    
    
}
