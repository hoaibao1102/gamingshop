package dao;

import dto.Accessories;
import dto.Product_accessories;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductAccessoriesDAO implements IDAO<Product_accessories, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Product_accessories";
    private static final String GET_BY_PRODUCT_ID = "SELECT * FROM dbo.Product_accessories WHERE product_id = ?";
    private static final String GET_BY_ACCESSORY_ID = "SELECT * FROM dbo.Product_accessories WHERE accessory_id = ?";
    private static final String CREATE
            = "INSERT INTO dbo.Product_accessories (product_id, accessory_id, quantity, status) VALUES (?, ?, ?, ?)";

    @Override
    public boolean create(Product_accessories e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setInt(1, e.getProduct_id());
            st.setInt(2, e.getAccessory_id());
            st.setInt(3, e.getQuantity());
            st.setString(4, e.getStatus());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    // getById: dùng product_id (nhưng thực tế khóa chính là composite product_id + accessory_id)
    @Override
    public Product_accessories getById(Integer productId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_PRODUCT_ID);
            st.setInt(1, productId);
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
    public List<Product_accessories> getByName(String name) {
        return new ArrayList<>(); // bảng này không có name
    }

    @Override
    public List<Product_accessories> getAll() {
        List<Product_accessories> list = new ArrayList<>();
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

    public List<Product_accessories> getByAccessoryId(Integer accessoryId) {
        List<Product_accessories> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ACCESSORY_ID);
            st.setInt(1, accessoryId);
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

    private Product_accessories map(ResultSet rs) throws SQLException {
        Product_accessories pa = new Product_accessories();
        pa.setProduct_id(rs.getInt("product_id"));
        pa.setAccessory_id(rs.getInt("accessory_id"));
        pa.setQuantity(rs.getInt("quantity"));
        pa.setStatus(rs.getString("status"));
        return pa;
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

    // tiện ích thêm (tương tự create nhưng có throws SQLException)
    public boolean insert(Product_accessories pa) throws SQLException, ClassNotFoundException {
        try ( Connection c = DBUtils.getConnection();  PreparedStatement ps = c.prepareStatement(CREATE)) {
            ps.setInt(1, pa.getProduct_id());
            ps.setInt(2, pa.getAccessory_id());
            ps.setInt(3, pa.getQuantity());
            ps.setString(4, pa.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Accessories> getAccessoriesByProductId(int productId) {
        List<Accessories> list = new ArrayList<>();
        String sql = "SELECT a.* , pa.quantity as qty "
                + "FROM Product_accessories pa "
                + "JOIN Accessories a ON pa.accessory_id = a.id "
                + "WHERE pa.product_id = ? AND pa.status = 'active'";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Accessories acc = new Accessories();
                acc.setId(rs.getInt("id"));
                acc.setName(rs.getString("name"));
                acc.setStatus(rs.getString("status"));
                acc.setGift(rs.getString("gift"));
                acc.setPrice(rs.getDouble("price"));
                acc.setQuantity(rs.getInt("qty")); // số lượng mapping
                list.add(acc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteByProductId(int product_id) {
        String sql = "DELETE FROM Product_accessories WHERE product_id = ?";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, product_id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
