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
public class Accessories {
    private int id;
    private String name;
    private double quantity;
    private double price;
    private String description;
    private String image_url;
    private Date created_ad;
    private Date update_ad;

    public Accessories() {
    }

    public Accessories(int id, String name, double quantity, double price, String description, String image_url, Date created_ad, Date update_ad) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.description = description;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
