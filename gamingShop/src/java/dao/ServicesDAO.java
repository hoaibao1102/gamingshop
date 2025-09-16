/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Services;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class ServicesDAO implements IDAO<Services, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Services";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Services WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Services WHERE service_type LIKE ?";
    private static final String CREATE = "INSERT INTO dbo.Services (service_type, description_html, price, status) VALUES (?, ?, ?, ?)";
    private static final String CHECK_SERVICE_TYPE_EXISTS = "SELECT COUNT(*) FROM dbo.Services WHERE service_type = ?";
    private static final String GET_ALL_ACTIVE = "SELECT * FROM dbo.Services WHERE status = 'active'";
    private static final String CHECK_SERVICES_TYPE_EXISTS_EXCEPT = "SELECT COUNT(*) FROM dbo.Services WHERE service_type = ? AND id != ?";
    private static final String UPDATE = "UPDATE dbo.Services SET service_type = ?, description_html = ?, status = ?, updated_at = GETDATE() WHERE id = ?";

    @Override
    public boolean create(Services e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, e.getService_type());
            st.setString(2, e.getDescription_html());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getStatus());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Services getById(Integer id) {
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
    public List<Services> getByName(String name) {
        List<Services> list = new ArrayList<>();
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
    public List<Services> getAll() {
        List<Services> list = new ArrayList<>();
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

    private Services map(ResultSet rs) throws SQLException {
        Services s = new Services();
        s.setId(rs.getInt("id"));
        s.setService_type(rs.getString("service_type"));
        s.setDescription_html(rs.getString("description_html"));
        s.setPrice(rs.getDouble("price"));

        // created_at
        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) {
            s.setCreated_at(new java.util.Date(createdTs.getTime()));
        }

        // updated_at
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) {
            s.setUpdated_at(new java.util.Date(updatedTs.getTime()));
        }

        s.setStatus(rs.getString("status"));

        return s;
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

    public List<Services> getAllActive() {
        List<Services> list = new ArrayList<>();
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

    public boolean update(Services existingService) {
        Connection c = null;
        PreparedStatement ps = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(UPDATE);
            ps.setString(1, existingService.getService_type());
            ps.setString(2, existingService.getDescription_html());
            ps.setString(3, existingService.getStatus());
            ps.setInt(4, existingService.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            close(c, ps, null);
        }
    }

    public boolean isServiceTypeExistsExcept(String trim, int serviceId) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(CHECK_SERVICES_TYPE_EXISTS_EXCEPT);
            ps.setString(1, trim);
            ps.setInt(2, serviceId);
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

    public boolean isServiceTypeExists(String trim) {
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(CHECK_SERVICE_TYPE_EXISTS);
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
}
