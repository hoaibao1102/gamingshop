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
public class Services {
    private int id;
    private String service_type;
    private String description_html;
    private double price;
    private Date created_ad;
    private Date update_ad;

    public Services() {
    }

    
    public Services(int id, String service_type, String description_html, double price, Date created_ad, Date update_ad) {
        this.id = id;
        this.service_type = service_type;
        this.description_html = description_html;
        this.price = price;
        this.created_ad = created_ad;
        this.update_ad = update_ad;
    }

    
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getService_type() {
        return service_type;
    }

    public void setService_type(String service_type) {
        this.service_type = service_type;
    }

    public String getDescription_html() {
        return description_html;
    }

    public void setDescription_html(String description_html) {
        this.description_html = description_html;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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
