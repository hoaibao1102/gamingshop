/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Admin
 */
public class BannerText {
    private int id;
    private String bannerText;

    public BannerText() {
    }

    public BannerText(int id, String bannerText) {
        this.id = id;
        this.bannerText = bannerText;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBannerText() {
        return bannerText;
    }

    public void setBannerText(String bannerText) {
        this.bannerText = bannerText;
    }

    @Override
    public String toString() {
        return "BannerText{" + "id=" + id + ", bannerText=" + bannerText + '}';
    }
    
    
    
}
