/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Posts;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class PostsDAO implements IDAO<Posts, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Posts";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Posts WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Posts WHERE title LIKE ?";
    private static final String CREATE
            = "INSERT INTO dbo.Posts (author, title, content_html, image_url, publish_date, status) VALUES (?, ?, ?, ?, ?, ?)";

    @Override
    public boolean create(Posts e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getAuthor());
            st.setString(2, e.getTitle());
            st.setString(3, e.getContent_html());
            st.setString(4, e.getImage_url());
            if (e.getPublish_date() != null) {
                st.setTimestamp(5, new Timestamp(e.getPublish_date().getTime()));
            } else {
                st.setNull(5, Types.TIMESTAMP);
            }
            st.setInt(6, e.getStatus());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Posts getById(Integer id) {
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
    public List<Posts> getByName(String name) {
        List<Posts> list = new ArrayList<>();
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
    public List<Posts> getAll() {
        List<Posts> list = new ArrayList<>();
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

    private Posts map(ResultSet rs) throws SQLException {
        Posts p = new Posts();
        p.setId(rs.getInt("id"));
        p.setAuthor(rs.getString("author"));
        p.setTitle(rs.getString("title"));
        p.setContent_html(rs.getString("content_html"));
        p.setImage_url(rs.getString("image_url"));

        // publish_date
        Timestamp publishTs = rs.getTimestamp("publish_date");
        if (publishTs != null) {
            p.setPublish_date(new java.util.Date(publishTs.getTime()));
        }

        p.setStatus(rs.getInt("status"));

        // created_at
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            p.setCreated_at(new java.util.Date(createdTs.getTime()));
        }

        // updated_at
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            p.setUpdated_at(new java.util.Date(updatedTs.getTime()));
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

    public int createNewPost(Posts e) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        int generatedId = -1;
        try {
            c = DBUtils.getConnection();
            // Thêm Statement.RETURN_GENERATED_KEYS để lấy id sinh ra
            st = c.prepareStatement(CREATE, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, e.getAuthor());
            st.setString(2, e.getTitle());
            st.setString(3, e.getContent_html());
            st.setString(4, e.getImage_url());
            if (e.getPublish_date() != null) {
                st.setTimestamp(5, new Timestamp(e.getPublish_date().getTime()));
            } else {
                st.setNull(5, Types.TIMESTAMP);
            }
            st.setInt(6, e.getStatus());

            int rows = st.executeUpdate();
            if (rows > 0) {
                rs = st.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    e.setId(generatedId); // gán lại vào object
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return generatedId; // nếu lỗi trả về -1
    }

    public boolean deleteProductById(int id) {
        Connection c = null;
        PreparedStatement st = null;
        String sql = "UPDATE Posts SET status = '0', updated_at = GETDATE() WHERE id = ?";
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
}
