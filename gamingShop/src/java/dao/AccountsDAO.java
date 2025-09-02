/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Accounts;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.PasswordUtils;

/**
 *
 * @author MSI PC
 */
public class AccountsDAO implements IDAO<Accounts, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Accounts";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Accounts WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Accounts WHERE username LIKE ?";
    private static final String CREATE
            = "INSERT INTO dbo.Accounts (username, password_hash, email, full_name, phone) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_PASSWORD_BY_USERNAME
            = "UPDATE dbo.Accounts SET password_hash = ? WHERE username = ?";

    @Override
    public boolean create(Accounts e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getUsername());
            st.setString(2, e.getPassword_hash());
            st.setString(3, e.getEmail());
            st.setString(4, e.getFull_name());
            st.setString(5, e.getPhone());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Accounts getById(Integer id) {
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
    public List<Accounts> getByName(String name) {
        List<Accounts> list = new ArrayList<>();
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
    public List<Accounts> getAll() {
        List<Accounts> list = new ArrayList<>();
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

    private Accounts map(ResultSet rs) throws SQLException {
        Accounts a = new Accounts();
        a.setId(rs.getInt("id"));
        a.setUsername(rs.getString("username"));
        a.setPassword_hash(rs.getString("password_hash"));
        a.setEmail(rs.getString("email"));
        a.setFull_name(rs.getString("full_name"));
        a.setPhone(rs.getString("phone"));

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

        return a;
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

    public boolean updatePassword(String userName, String newPassword) {
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD_BY_USERNAME);
            ps.setString(1, newPassword);
            ps.setString(2, userName);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Accounts getByUsername(String userName) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            String sql = "SELECT * FROM dbo.Accounts WHERE username = ?";
            st = c.prepareStatement(sql);
            st.setString(1, userName);
            rs = st.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return null;
    }

    public boolean login(String userName, String password) {
        Accounts accounts = getByUsername(userName);
        if (accounts == null) {
            return false;
        }

        String inputHash = PasswordUtils.encryptSHA256(password);

        return inputHash.equals(accounts.getPassword_hash());
    }
}
