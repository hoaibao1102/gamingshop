/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Models;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement; // Cho RETURN_GENERATED_KEYS
/**
 *
 * @author MSI PC
 */
public class ModelsDAO implements IDAO<Models, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Models";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Models WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Models WHERE model_type LIKE ?";
    private static final String CREATE = "INSERT INTO dbo.Models (model_type, description_html, image_url, status) VALUES (?, ?, ?, ?)";
    private static final String CHECK_MODEL_TYPE_EXISTS = "SELECT COUNT(*) FROM dbo.Models WHERE model_type = ?";
    private static final String GET_ALL_ACTIVE = "SELECT * FROM dbo.Models WHERE status = 'active'";
    private static final String CHECK_MODEL_TYPE_EXISTS_EXCEPT = "SELECT COUNT(*) FROM dbo.Models WHERE model_type = ? AND id != ?";
    private static final String UPDATE = "UPDATE dbo.Models SET model_type = ?, description_html = ?, image_url = ?, status = ?, updated_at = GETDATE() WHERE id = ?";

    @Override
    public boolean create(Models e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, e.getModel_type());
            st.setString(2, e.getDescription_html());
            st.setString(3, e.getImage_url());
            st.setString(4, e.getStatus());
            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                try ( ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        e.setId(generatedId);
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
    public Models getById(Integer id) {
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
    public List<Models> getByName(String name) {
        List<Models> list = new ArrayList<>();
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
    public List<Models> getAll() {
        List<Models> list = new ArrayList<>();
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

    private Models map(ResultSet rs) throws SQLException {
        Models m = new Models();
        m.setId(rs.getInt("id"));
        m.setModel_type(rs.getString("model_type"));
        m.setDescription_html(rs.getString("description_html"));
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

        m.setStatus(rs.getString("status"));
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

    /**
     * Kiểm tra xem model_type đã tồn tại trong database hay chưa
     *
     * @param modelType tên model type cần kiểm tra
     * @return true nếu đã tồn tại, false nếu chưa tồn tại
     */
    public boolean isModelTypeExists(String trim) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(CHECK_MODEL_TYPE_EXISTS);
            ps.setString(1, trim);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(c, ps, rs);
        }
        return false;
    }

    /**
     * Lấy danh sách tất cả các models có status = 'active'
     *
     * @return danh sách các Models đang hoạt động
     */
    public List<Models> getAllActive() {
        List<Models> list = new ArrayList<>();
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

    /**
     * Kiểm tra xem model_type đã tồn tại hay chưa, ngoại trừ model có id được
     * chỉ định Thường dùng khi update để tránh trùng lặp với chính model đang
     * được update
     *
     * @param modelType tên model type cần kiểm tra
     * @param modelId id của model cần loại trừ khỏi việc kiểm tra
     * @return true nếu model_type đã tồn tại ở model khác, false nếu không
     */
    public boolean isModelTypeExistsExcept(String trim, int modelId) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(CHECK_MODEL_TYPE_EXISTS_EXCEPT);
            ps.setString(1, trim);
            ps.setInt(2, modelId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(c, ps, rs);
        }
        return false;
    }

    /**
     * Cập nhật thông tin của một model
     *
     * @param existingModel model chứa thông tin mới cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean update(Models existingModel) {
        Connection c = null;
        PreparedStatement ps = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(UPDATE);
            ps.setString(1, existingModel.getModel_type());
            ps.setString(2, existingModel.getDescription_html());
            ps.setString(3, existingModel.getImage_url());
            ps.setString(4, existingModel.getStatus());
            ps.setInt(5, existingModel.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            close(c, ps, null);
        }
    }
}
