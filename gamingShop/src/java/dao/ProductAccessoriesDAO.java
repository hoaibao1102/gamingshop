/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Product_accessories;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class ProductAccessoriesDAO implements IDAO<Product_accessories, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Product_accessories";
    private static final String GET_BY_PRODUCT_ID = "SELECT * FROM dbo.Product_accessories WHERE product_id = ?";
    private static final String GET_BY_ACCESSORY_ID = "SELECT * FROM dbo.Product_accessories WHERE accessory_id = ?";
    private static final String CREATE
            = "INSERT INTO dbo.Product_accessories (product_id, accessory_id, quantity) VALUES (?, ?, ?)";

    @Override
    public boolean create(Product_accessories e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setInt(1, e.getProduct_id());
            st.setInt(2, e.getAccessory_id());
            st.setInt(3, e.getQuantity());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    // getById không thực sự hợp lý với bảng này, vì id là composite (product_id + accessory_id).
    // Ở đây mình sẽ cho id đại diện là product_id để tránh lỗi interface.
    @Override
    public Product_accessories getById(Integer productId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_PRODUCT_ID);
            st.setInt(1, productId);
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

    // Không có "name" trong bảng này => để trống
    @Override
    public List<Product_accessories> getByName(String name) {
        return new ArrayList<>();
    }

    @Override
    public List<Product_accessories> getAll() {
        List<Product_accessories> list = new ArrayList<>();
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

    // Hàm phụ trợ: lấy theo accessory_id
    public List<Product_accessories> getByAccessoryId(Integer accessoryId) {
        List<Product_accessories> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ACCESSORY_ID);
            st.setInt(1, accessoryId);
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

    private Product_accessories map(ResultSet rs) throws SQLException {
        Product_accessories pa = new Product_accessories();
        pa.setProduct_id(rs.getInt("product_id"));
        pa.setAccessory_id(rs.getInt("accessory_id"));
        pa.setQuantity(rs.getInt("quantity"));
        return pa;
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
