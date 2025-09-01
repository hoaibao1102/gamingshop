/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Accessories;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author MSI PC
 */
public class AccessoriesDAO implements IDAO<Accessories, Integer> {

    private static final String GET_ALL     = "SELECT * FROM dbo.Accessories";
    private static final String GET_BY_ID   = "SELECT * FROM dbo.Accessories WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Accessories WHERE name LIKE ?";
    private static final String CREATE      = 
        "INSERT INTO dbo.Accessories (name, quantity, price, description, image_url) VALUES (?, ?, ?, ?, ?)";

    @Override
    public boolean create(Accessories e) {
        Connection c = null; PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getName());
            st.setDouble(2, e.getQuantity());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getDescription());
            st.setString(5, e.getImage_url());
            return st.executeUpdate() > 0; // Cách B: không lấy id sinh tự động
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Accessories getById(Integer id) {
        Connection c = null; PreparedStatement st = null; ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ID);
            st.setInt(1, id);
            rs = st.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return null;
    }

    @Override
    public List<Accessories> getByName(String name) {
        List<Accessories> list = new ArrayList<>();
        Connection c = null; PreparedStatement st = null; ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_NAME);
            st.setString(1, "%" + name + "%");
            rs = st.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return list;
    }

    @Override
    public List<Accessories> getAll() {
        List<Accessories> list = new ArrayList<>();
        Connection c = null; PreparedStatement st = null; ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return list;
    }

    private Accessories map(ResultSet rs) throws SQLException {
        Accessories a = new Accessories();
        a.setId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setQuantity(rs.getDouble("quantity"));
        a.setPrice(rs.getDouble("price"));
        a.setDescription(rs.getString("description"));
        a.setImage_url(rs.getString("image_url"));

        // created_ad & update_ad là DATETIME/DATE trong SQL Server
        Timestamp createdTs = rs.getTimestamp("created_ad");
        if (createdTs != null) a.setCreated_ad(new java.util.Date(createdTs.getTime()));

        Timestamp updatedTs = rs.getTimestamp("update_ad");
        if (updatedTs != null) a.setUpdate_ad(new java.util.Date(updatedTs.getTime()));

        return a;
    }

    private void close(Connection c, PreparedStatement st, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception ignore) {}
        try { if (st != null) st.close(); } catch (Exception ignore) {}
        try { if (c != null) c.close(); } catch (Exception ignore) {}
    }
}