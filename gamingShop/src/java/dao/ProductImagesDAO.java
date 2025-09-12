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
    private static final String GET_BY_PRODUCT = "SELECT * FROM Product_images WHERE product_id = ? AND status = '1' ORDER BY created_at ASC";
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

    public List<Product_images> getByAllProductId(int productId) {
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

        // created_at
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            pi.setCreated_at(new java.util.Date(createdTs.getTime()));
        }

        // updated_at
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            pi.setUpdated_at(new java.util.Date(updatedTs.getTime()));
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

    public Product_images getCoverImgByProductId(int productId) {
        Product_images img = null;
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        String sql = "SELECT TOP 1 * FROM Product_images WHERE product_id = ? AND status = '1' ORDER BY created_at ASC";

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setInt(1, productId);
            rs = st.executeQuery();

            if (rs.next()) {
                img = map(rs);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }

        return img;
    }

    public List<Product_images> getByProductId(int productId) {
        List<Product_images> img = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        // Sắp xếp theo sort_order để map đúng 4 slot
        String sql = "SELECT * FROM Product_images "
                + "WHERE product_id = ? AND status = 1 "
                + "ORDER BY sort_order ASC, id ASC";
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setInt(1, productId);
            rs = st.executeQuery();
            while (rs.next()) {
                img.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return img;
    }

    public boolean deleteImageById(int id) {
        Connection c = null;
        PreparedStatement st = null;
        String sql = "UPDATE Product_images SET status = 0, updated_at = GETDATE() WHERE id = ?";
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    public boolean softDeleteByProductAndSlot(int productId, int sortOrder) {
        Connection c = null;
        PreparedStatement st = null;
        String sql = "UPDATE Product_images "
                + "SET status = 0, updated_at = GETDATE() "
                + "WHERE product_id = ? AND sort_order = ? AND status = 1";
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setInt(1, productId);
            st.setInt(2, sortOrder);
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }
}
