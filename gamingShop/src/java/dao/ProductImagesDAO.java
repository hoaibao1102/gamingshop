/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Product_images;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class ProductImagesDAO implements IDAO<Product_images, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Product_images";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Product_images WHERE id = ?";
    private static final String GET_BY_PRODUCT = "SELECT * FROM dbo.Product_images WHERE product_id = ?";
    private static final String CREATE
            = "INSERT INTO dbo.Product_images (product_id, image_url, caption, sort_order, status) VALUES (?, ?, ?, ?, ?)";

    @Override
    public boolean create(Product_images e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setInt(1, e.getProduct_id());
            st.setString(2, e.getImage_url());
            st.setString(3, e.getCaption());
            st.setInt(4, e.getSort_order());
            st.setInt(5, e.getStatus());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Product_images getById(Integer id) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ID);
            st.setInt(1, id);
            rs = st.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return null;
    }

    // Không có trường "name", mình sẽ dùng GET_BY_PRODUCT thay thế
    @Override
    public List<Product_images> getByName(String name) {
        return new ArrayList<>();
    }

    public List<Product_images> getByProductId(int productId) {
        List<Product_images> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_PRODUCT);
            st.setInt(1, productId);
            rs = st.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return list;
    }

    @Override
    public List<Product_images> getAll() {
        List<Product_images> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return list;
    }

    private Product_images map(ResultSet rs) throws SQLException {
        Product_images pi = new Product_images();
        pi.setId(rs.getInt("id"));
        pi.setProduct_id(rs.getInt("product_id"));
        pi.setImage_url(rs.getString("image_url"));
        pi.setCaption(rs.getString("caption"));
        pi.setSort_order(rs.getInt("sort_order"));
        pi.setStatus(rs.getInt("status"));

        Timestamp createdTs = rs.getTimestamp("created_ad");
        if (createdTs != null) {
            pi.setCreated_ad(new java.util.Date(createdTs.getTime()));
        }

        Timestamp updatedTs = rs.getTimestamp("update_ad");
        if (updatedTs != null) {
            pi.setUpdate_ad(new java.util.Date(updatedTs.getTime()));
        }

        return pi;
    }

    private void close(Connection c, PreparedStatement st, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception ignore) {
        }
        try {
            if (st != null) {
                st.close();
            }
        } catch (Exception ignore) {
        }
        try {
            if (c != null) {
                c.close();
            }
        } catch (Exception ignore) {
        }
    }
}
