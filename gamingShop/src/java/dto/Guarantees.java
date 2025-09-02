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
    private Date created_at;
    private Date updated_at;

    public Guarantees() {
    }

    public Guarantees(int id, String guarantee_type, String description_html, Date created_at, Date updated_at) {
        this.id = id;
        this.guarantee_type = guarantee_type;
        this.description_html = description_html;
        this.created_at = created_at;
        this.updated_at = updated_at;
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

}
