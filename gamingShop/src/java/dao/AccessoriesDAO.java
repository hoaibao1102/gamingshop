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

    private static final String GET_ALL = "SELECT * FROM dbo.Accessories";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Accessories WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Accessories WHERE name LIKE ? ";
    private static final String CREATE = "INSERT INTO dbo.Accessories (name, quantity, price, description_html, image_url, status, gift) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE dbo.Accessories SET name = ?, quantity = ?, price = ?, description_html = ?, image_url = ?, status = ?, gift = ?, updated_at = GETDATE() WHERE id = ?";
    private static final String CHECK_EXIST_NAME = "SELECT COUNT(1) FROM dbo.Accessories WHERE name = ? AND status = 'active'";
    private static final String GET_ALL_ACTIVE = "SELECT * FROM dbo.Accessories WHERE status = 'active'";
    @Override
    public boolean create(Accessories e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, e.getName());
            st.setInt(2, e.getQuantity());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getDescription());
            st.setString(5, e.getImage_url());
            st.setString(6, e.getStatus());
            st.setString(7, e.getGift());
            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                try ( ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        e.setId(rs.getInt(1)); // Gán ID cho object
                    }
                }
                return true;
            }
            return false;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Accessories getById(Integer id) {
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
    public List<Accessories> getByName(String name) {
        List<Accessories> list = new ArrayList<>();
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
    public List<Accessories> getAll() {
        List<Accessories> list = new ArrayList<>();
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

    private Accessories map(ResultSet rs) throws SQLException {
        Accessories a = new Accessories();
        a.setId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setQuantity(rs.getInt("quantity"));
        a.setPrice(rs.getDouble("price"));
        a.setDescription(rs.getString("description_html"));
        a.setImage_url(rs.getString("image_url"));

        // created_at
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            a.setCreated_at(new java.util.Date(createdTs.getTime()));
        }

        // updated_at
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            a.setUpdated_at(new java.util.Date(updatedTs.getTime()));
        }

        a.setStatus(rs.getString("status"));
        a.setGift(rs.getString("gift"));
        return a;
    }

// NEW UPDATE METHOD
    public boolean update(Accessories e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, e.getName());
            st.setInt(2, (int) e.getQuantity());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getDescription()); // Maps to description_html
            st.setString(5, e.getImage_url());
            st.setString(6, e.getStatus());
            st.setString(7, e.getGift());
            st.setInt(8, e.getId()); // WHERE condition

            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    /**
     * Kiểm tra tên accessory đã tồn tại chưa
     */
    public boolean isNameExists(String name) throws SQLException, ClassNotFoundException {
    
    try (Connection c = DBUtils.getConnection();
         PreparedStatement st = c.prepareStatement(CHECK_EXIST_NAME)) {
        
        st.setString(1, name);
        
        try (ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
    } catch (SQLException ex) {
        ex.printStackTrace();
        throw new SQLException("Error checking name existence: " + ex.getMessage(), ex);
    }
    
    return false;
}
    
    /**
     * Lấy danh sách tất cả các models có status = 'active'
     *
     * @return danh sách các Models đang hoạt động
     */
    public List<Accessories> getAllActive() {
        List<Accessories> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(GET_ALL_ACTIVE);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(c, ps, rs);
        }
        return list;
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
