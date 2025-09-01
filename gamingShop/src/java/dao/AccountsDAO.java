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
        Accounts a = new Accounts(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("password_hash"),
                rs.getString("email"),
                rs.getString("full_name"),
                rs.getString("phone"),
                rs.getTimestamp("created_ad") != null ? new java.util.Date(rs.getTimestamp("created_ad").getTime()) : null,
                rs.getTimestamp("update_ad") != null ? new java.util.Date(rs.getTimestamp("update_ad").getTime()) : null
        );
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
}
