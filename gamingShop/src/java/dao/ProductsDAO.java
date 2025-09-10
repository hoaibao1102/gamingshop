/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Page;
import dto.ProductFilter;
import dto.Products;
import utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author MSI PC
 */
public class ProductsDAO implements IDAO<Products, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Products";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Products WHERE id = ?";
    private static final String GET_BY_STATUS = "SELECT * FROM dbo.Products WHERE status = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Products WHERE name LIKE ?";
    private static final String CREATE
            = "INSERT INTO dbo.Products (name, sku, price, product_type, model_id, memory_id, guarantee_id, quantity, description_html, status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    @Override
    public boolean create(Products e) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, e.getName());
            st.setString(2, e.getSku());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getProduct_type());
            st.setInt(5, e.getModel_id());
            st.setInt(6, e.getMemory_id());
            st.setInt(7, e.getGuarantee_id());
            st.setInt(8, e.getQuantity());
            st.setString(9, e.getDescription_html());
            st.setString(10, e.getStatus());
            return st.executeUpdate() > 0; // Cách B: không lấy id tự sinh
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    @Override
    public Products getById(Integer id) {
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

    public List<Products> getByStatus(String status) {
        List<Products> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_STATUS);
            st.setString(1, status);
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
    public List<Products> getByName(String name) {
        List<Products> list = new ArrayList<>();
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
    public List<Products> getAll() {
        List<Products> list = new ArrayList<>();
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

    /**
     * Lấy danh sách sản phẩm có phân trang và lọc
     */
    public Page<Products> getProductsWithFilter(ProductFilter filter) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        List<Products> products = new ArrayList<>();
        int totalCount = 0;

        try {
            c = DBUtils.getConnection();

            // Tạo câu query động
            StringBuilder queryBuilder = new StringBuilder();
            StringBuilder countQueryBuilder = new StringBuilder();
            List<Object> params = new ArrayList<>();

            // Base query
            queryBuilder.append("SELECT * FROM dbo.Products WHERE 1=1");
            countQueryBuilder.append("SELECT COUNT(*) FROM dbo.Products WHERE 1=1");

            // Thêm điều kiện lọc
            addFilterConditions(queryBuilder, countQueryBuilder, filter, params);

            // Thêm ORDER BY
            addOrderBy(queryBuilder, filter.getSortBy());

            // Thêm OFFSET và FETCH cho phân trang
            int offset = (filter.getPage() - 1) * filter.getPageSize();
            queryBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            // 1. Đếm tổng số records
            st = c.prepareStatement(countQueryBuilder.toString());
            setParameters(st, params);
            rs = st.executeQuery();
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            rs.close();
            st.close();

            // 2. Lấy dữ liệu phân trang
            st = c.prepareStatement(queryBuilder.toString());
            setParameters(st, params);
            st.setInt(params.size() + 1, offset);
            st.setInt(params.size() + 2, filter.getPageSize());

            rs = st.executeQuery();
            while (rs.next()) {
                products.add(map(rs));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }

        return new Page<>(products, filter.getPage(), filter.getPageSize(), totalCount);
    }

    private void addFilterConditions(StringBuilder queryBuilder, StringBuilder countQueryBuilder,
            ProductFilter filter, List<Object> params) {
        String conditions = "";

        // Lọc theo tên
        if (filter.getName() != null && !filter.getName().trim().isEmpty()) {
            conditions += " AND name LIKE ?";
            params.add("%" + filter.getName().trim() + "%");
        }

        // Lọc theo loại sản phẩm
        if (filter.getProductType() != null && !"all".equals(filter.getProductType())) {
            conditions += " AND product_type = ?";
            params.add(filter.getProductType());
        }

        // Lọc theo giá tối thiểu
        if (filter.getMinPrice() != null && filter.getMinPrice() >= 0) {
            conditions += " AND price >= ?";
            params.add(filter.getMinPrice());
        }

        // Lọc theo giá tối đa
        if (filter.getMaxPrice() != null && filter.getMaxPrice() > 0) {
            conditions += " AND price <= ?";
            params.add(filter.getMaxPrice());
        }

        // Chỉ lấy sản phẩm active và prominent
        conditions += " AND (status = 'active' OR status = 'prominent')";

        queryBuilder.append(conditions);
        countQueryBuilder.append(conditions);
    }

    private void addOrderBy(StringBuilder queryBuilder, String sortBy) {
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "name_asc";
        }

        switch (sortBy) {
            case "name_asc":
                queryBuilder.append(" ORDER BY name ASC");
                break;
            case "name_desc":
                queryBuilder.append(" ORDER BY name DESC");
                break;
            case "price_asc":
                queryBuilder.append(" ORDER BY price ASC");
                break;
            case "price_desc":
                queryBuilder.append(" ORDER BY price DESC");
                break;
            case "date_asc":
                queryBuilder.append(" ORDER BY created_at ASC");
                break;
            case "date_desc":
                queryBuilder.append(" ORDER BY created_at DESC");
                break;
            default:
                queryBuilder.append(" ORDER BY name ASC");
        }
    }

    private void setParameters(PreparedStatement st, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            st.setObject(i + 1, params.get(i));
        }
    }

    private Products map(ResultSet rs) throws SQLException {
        Products p = new Products();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setSku(rs.getString("sku"));
        p.setPrice(rs.getDouble("price"));
        p.setProduct_type(rs.getString("product_type"));
        p.setModel_id(rs.getInt("model_id"));
        p.setMemory_id(rs.getInt("memory_id"));
        p.setGuarantee_id(rs.getInt("guarantee_id"));
        p.setQuantity(rs.getInt("quantity"));
        p.setDescription_html(rs.getString("description_html"));
        p.setStatus(rs.getString("status"));

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

    public int createNewProduct(Products e) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        int generatedId = -1;
        try {
            c = DBUtils.getConnection();
            // Thêm Statement.RETURN_GENERATED_KEYS để lấy id sinh ra
            st = c.prepareStatement(CREATE, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, e.getName());
            st.setString(2, e.getSku());
            st.setDouble(3, e.getPrice());
            st.setString(4, e.getProduct_type());
            st.setInt(5, e.getModel_id());
            st.setInt(6, e.getMemory_id());
            st.setInt(7, e.getGuarantee_id());
            st.setInt(8, e.getQuantity());
            st.setString(9, e.getDescription_html());
            st.setString(10, e.getStatus());

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

}
