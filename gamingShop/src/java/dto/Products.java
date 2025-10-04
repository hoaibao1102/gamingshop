/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.util.Date;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class Products {

    private int id;
    private String name;
    private String sku;
    private double price;
    private String product_type;
    private int model_id;
    private int memory_id;
    private int guarantee_id;
    private int quantity;
    private String description_html;
    private String status;
    private Date created_at;
    private Date updated_at;
    private List<Product_images> image;
    private String slug;
    
    private transient String coverImg;

    public List<Product_images> getImage() {
        return image;
    }

    public void setImage(List<Product_images> image) {
        this.image = image;
    }

    public Products() {
    }

    public Products(int id, String name, String sku, double price, String product_type, int model_id, int memory_id, int guarantee_id, int quantity, String description_html, String status, Date created_at, Date updated_at, List<Product_images> image, String slug, String coverImg) {
        this.id = id;
        this.name = name;
        this.sku = sku;
        this.price = price;
        this.product_type = product_type;
        this.model_id = model_id;
        this.memory_id = memory_id;
        this.guarantee_id = guarantee_id;
        this.quantity = quantity;
        this.description_html = description_html;
        this.status = status;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.image = image;
        this.slug = slug;
        this.coverImg = coverImg;
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

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getProduct_type() {
        return product_type;
    }

    public void setProduct_type(String product_type) {
        this.product_type = product_type;
    }

    public int getModel_id() {
        return model_id;
    }

    public void setModel_id(int model_id) {
        this.model_id = model_id;
    }

    public int getMemory_id() {
        return memory_id;
    }

    public void setMemory_id(int memory_id) {
        this.memory_id = memory_id;
    }

    public int getGuarantee_id() {
        return guarantee_id;
    }

    public void setGuarantee_id(int guarantee_id) {
        this.guarantee_id = guarantee_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescription_html() {
        return description_html;
    }

    public void setDescription_html(String description_html) {
        this.description_html = description_html;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getCoverImg() {
        return coverImg;
    }

    public void setCoverImg(String coverImg) {
        this.coverImg = coverImg;
    }

    

    
}
