/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Memories;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class MemoriesDAO implements IDAO<Memories, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Memories";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Memories WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Memories WHERE memory_type LIKE ?";
    private static final String CREATE
            = "INSERT INTO dbo.Memories (memory_type, description_html, quantity, price, image_url) VALUES (?, ?, ?, ?, ?)";

    @Override
    public boolean create(Memories e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getMemory_type());
            st.setString(2, e.getDescription_html());
            st.setDouble(3, e.getQuantity());
            st.setDouble(4, e.getPrice());
            st.setString(5, e.getImage_url());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Memories getById(Integer id) {
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
    public List<Memories> getByName(String name) {
        List<Memories> list = new ArrayList<>();
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
    public List<Memories> getAll() {
        List<Memories> list = new ArrayList<>();
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

    private Memories map(ResultSet rs) throws SQLException {
        Memories m = new Memories();
        m.setId(rs.getInt("id"));
        m.setMemory_type(rs.getString("memory_type"));
        m.setDescription_html(rs.getString("description_html"));
        m.setQuantity(rs.getDouble("quantity"));
        m.setPrice(rs.getDouble("price"));
        m.setImage_url(rs.getString("image_url"));

        // created_at
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            m.setCreated_at(new java.util.Date(createdTs.getTime()));
        }

        // updated_at
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            m.setUpdated_at(new java.util.Date(updatedTs.getTime()));
        }

        return m;
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
