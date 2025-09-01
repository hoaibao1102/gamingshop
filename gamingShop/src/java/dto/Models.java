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
public class Models {

    private int id;
    private String model_type;
    private String description_html;
    private String image_url;
    private Date created_ad;
    private Date update_ad;

    public Models() {
    }

    public Models(int id, String model_type, String description_html, String image_url, Date created_ad, Date update_ad) {
        this.id = id;
        this.model_type = model_type;
        this.description_html = description_html;
        this.image_url = image_url;
        this.created_ad = created_ad;
        this.update_ad = update_ad;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getModel_type() {
        return model_type;
    }

    public void setModel_type(String model_type) {
        this.model_type = model_type;
    }

    public String getDescription_html() {
        return description_html;
    }

    public void setDescription_html(String description_html) {
        this.description_html = description_html;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
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
