/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Products;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class ProductsDAO implements IDAO<Products, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Products";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Products WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Products WHERE name LIKE ?";
    private static final String CREATE
            = "INSERT INTO dbo.Products (name, sku, price, product_type, model_id, memory_id, guarantee_id, quantity, description_html, status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    @Override
    public boolean create(Products e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getName());
            st.setString(2, e.getSku());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getProduct_type());
            st.setInt(5, e.getModel_id());
            st.setInt(6, e.getMemory_id());
            st.setInt(7, e.getGuarantee_id());
            st.setInt(8, e.getQuantity());
            st.setString(9, e.getDescription_html());
            st.setString(10, e.getStatus());
            return st.executeUpdate() > 0; // Cách B: không lấy id tự sinh
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Products getById(Integer id) {
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

    @Override
    public List<Products> getByName(String name) {
        List<Products> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_NAME);
            st.setString(1, "%" + name + "%");
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
    public List<Products> getAll() {
        List<Products> list = new ArrayList<>();
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

    private Products map(ResultSet rs) throws SQLException {
        Products p = new Products();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setSku(rs.getString("sku"));
        p.setPrice(rs.getDouble("price"));
        p.setProduct_type(rs.getString("product_type"));
        p.setModel_id(rs.getInt("model_id"));
        p.setMemory_id(rs.getInt("memory_id"));
        p.setGuarantee_id(rs.getInt("guarantee_id"));
        p.setQuantity(rs.getInt("quantity"));
        p.setDescription_html(rs.getString("description_html"));
        p.setStatus(rs.getString("status"));

        Timestamp createdTs = rs.getTimestamp("created_ad");
        if (createdTs != null) {
            p.setCreated_ad(new java.util.Date(createdTs.getTime()));
        }

        Timestamp updatedTs = rs.getTimestamp("update_ad");
        if (updatedTs != null) {
            p.setUpdate_ad(new java.util.Date(updatedTs.getTime()));
        }

        return p;
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
