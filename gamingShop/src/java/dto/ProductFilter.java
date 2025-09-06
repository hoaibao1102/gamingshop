/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author MSI PC
 */
public class ProductFilter {
    private String name;
    private String productType; // 'new', 'used', 'all'
    private Double minPrice;
    private Double maxPrice;
    private String sortBy; // 'name_asc', 'name_desc', 'price_asc', 'price_desc', 'date_asc', 'date_desc'
    private int page;
    private int pageSize;
    
    public ProductFilter() {
        this.page = 1;
        this.pageSize = 16;
        this.productType = "all";
        this.sortBy = "name_asc";
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    public Double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(Double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public String getSortBy() {
        return sortBy;
    }

    public void setSortBy(String sortBy) {
        this.sortBy = sortBy;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    @Override
    public String toString() {
        return "ProductFilter{" +
                "name='" + name + '\'' +
                ", productType='" + productType + '\'' +
                ", minPrice=" + minPrice +
                ", maxPrice=" + maxPrice +
                ", sortBy='" + sortBy + '\'' +
                ", page=" + page +
                ", pageSize=" + pageSize +
                '}';
    }
}