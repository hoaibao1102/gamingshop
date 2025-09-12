/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Banners;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class BannersDAO implements IDAO<Banners, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Banners";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Banners WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Banners WHERE title LIKE ?";

    // Bạn có thể để DB tự set created_at/updated_at theo DEFAULT, nên chỉ insert 3 field chính
    private static final String CREATE
            = "INSERT INTO dbo.Banners (image_url, title, status) VALUES (?, ?, ?)";

    // Thêm tiện ích update/delete (không bắt buộc nếu IDAO không cần)
    private static final String UPDATE
            = "UPDATE dbo.Banners SET image_url = ?, title = ?, status = ?, updated_at = SYSDATETIME() WHERE id = ?";

    private static final String DELETE
            = "DELETE FROM dbo.Banners WHERE id = ?";

    @Override
    public boolean create(Banners e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getImage_url());
            st.setString(2, e.getTitle());
            st.setString(3, e.getStatus());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Banners getById(Integer id) {
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
    public List<Banners> getByName(String name) {
        List<Banners> list = new ArrayList<>();
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
    public List<Banners> getAll() {
        List<Banners> list = new ArrayList<>();
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

    // ---- Optional tiện ích ngoài IDAO ----
    public boolean update(Banners e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, e.getImage_url());
            st.setString(2, e.getTitle());
            st.setString(3, e.getStatus());
            st.setInt(4, e.getId());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    public boolean delete(Integer id) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(DELETE);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }
    // --------------------------------------

    private Banners map(ResultSet rs) throws SQLException {
        Banners b = new Banners();
        b.setId(rs.getInt("id"));
        b.setImage_url(rs.getString("image_url"));
        b.setTitle(rs.getString("title"));
        b.setStatus(rs.getString("status"));

        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            b.setCreated_at(new java.util.Date(createdTs.getTime()));
        }
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            b.setUpdated_at(new java.util.Date(updatedTs.getTime()));
        }
        return b;
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
