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
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import utils.SlugUtil;

/**
 *
 * @author MSI PC
 */
public class ProductsDAO implements IDAO<Products, Integer> {

    // SELECT
    private static final String GET_ALL = "SELECT * FROM dbo.Products";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Products WHERE id = ?";
    private static final String GET_BY_STATUS = "SELECT * FROM dbo.Products WHERE status = ?";
    private static final String GET_BY_TYPE = "SELECT * FROM dbo.Products WHERE product_type = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Products WHERE name LIKE ?";
    private static final String GET_BY_SLUG = "SELECT * FROM dbo.Products WHERE slug = ?";

// CREATE (thêm slug)
    private static final String CREATE
            = "INSERT INTO dbo.Products "
            + "(name, sku, price, product_type, model_id, memory_id, guarantee_id, quantity, description_html, status, slug) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

// UPDATE (cập nhật slug luôn nếu đổi tên sp)
    private static final String UPDATE
            = "UPDATE dbo.Products SET "
            + "name = ?, "
            + "sku = ?, "
            + "price = ?, "
            + "product_type = ?, "
            + "model_id = ?, "
            + "memory_id = ?, "
            + "guarantee_id = ?, "
            + "quantity = ?, "
            + "description_html = ?, "
            + "status = ?, "
            + "slug = ?, " // <-- thêm slug
            + "updated_at = GETDATE() "
            + "WHERE id = ?";

    @Override
    public boolean create(Products e) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            // Thêm RETURN_GENERATED_KEYS để lấy id tự sinh
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
                // Lấy ID vừa insert
                rs = st.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);

                    // Sinh slug từ name + id
                    String slug = SlugUtil.toSlug(e.getName(), generatedId);

                    // Update slug
                    String sqlUpdateSlug = "UPDATE products SET slug = ? WHERE id = ?";
                    try ( PreparedStatement st2 = c.prepareStatement(sqlUpdateSlug)) {
                        st2.setString(1, slug);
                        st2.setInt(2, generatedId);
                        st2.executeUpdate();
                    }
                }
                return true;
            }
            return false;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, rs);
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

    public Page<Products> getProminentProducts(ProductFilter filter) {
        Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
        where.put("status", "prominent");
        return getProductsByConditions(filter, where);
    }

    public Page<Products> getProductsByConditions(ProductFilter filter,
            Map<String, String> equalsConditions) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        List<Products> products = new ArrayList<>();
        int totalCount = 0;

        // ===== Clamp phân trang =====
        int page = (filter != null && filter.getPage() > 0) ? filter.getPage() : 1;
        int pageSize = (filter != null && filter.getPageSize() > 0) ? filter.getPageSize() : 12;
        pageSize = Math.min(Math.max(pageSize, 1), 100);
        int offset = (page - 1) * pageSize;

        // ===== Whitelist & kiểu dữ liệu =====
        final Set<String> ALLOWED_FILTER_FIELDS = new HashSet<>(Arrays.asList(
                "status", "product_type", "model_id", "memory_id",
                "guarantee_id", "name", "sku", "price", "quantity", "slug"
        ));
        final Map<String, String> FIELD_TYPES = new HashMap<>();
        {
            FIELD_TYPES.put("status", "string");
            FIELD_TYPES.put("product_type", "string");
            FIELD_TYPES.put("model_id", "int");
            FIELD_TYPES.put("memory_id", "int");
            FIELD_TYPES.put("guarantee_id", "int");
            FIELD_TYPES.put("name", "string");
            FIELD_TYPES.put("sku", "string");
            FIELD_TYPES.put("price", "decimal");
            FIELD_TYPES.put("quantity", "int");
            FIELD_TYPES.put("slug", "String");
        }

        try {
            c = DBUtils.getConnection();

            StringBuilder queryBuilder = new StringBuilder("SELECT * FROM dbo.Products WHERE 1=1");
            StringBuilder countQueryBuilder = new StringBuilder("SELECT COUNT(*) FROM dbo.Products WHERE 1=1");
            List<Object> params = new ArrayList<>();

            // điều kiện có sẵn trong ProductFilter
            addFilterConditions(queryBuilder, countQueryBuilder, filter, params);

            // ===== N điều kiện equals từ Map =====
            if (equalsConditions != null && !equalsConditions.isEmpty()) {
                // DÙNG LinkedHashMap khi gọi hàm để giữ thứ tự tham số ổn định
                for (Map.Entry<String, String> e : equalsConditions.entrySet()) {
                    String field = e.getKey();
                    String value = e.getValue();
                    if (field == null || value == null || field.trim().isEmpty() || value.trim().isEmpty()) {
                        continue;
                    }
                    if (!ALLOWED_FILTER_FIELDS.contains(field)) {
                        throw new IllegalArgumentException("Invalid filter field: " + field);
                    }
                    queryBuilder.append(" AND ").append(field).append(" = ?");
                    countQueryBuilder.append(" AND ").append(field).append(" = ?");
                    String type = FIELD_TYPES.getOrDefault(field, "string");
                    params.add(castParam(value, type));
                }
            }

            // ORDER BY mặc định (hàm cũ của bạn)
            addOrderBy(queryBuilder, (filter != null) ? filter.getSortBy() : null);

            // phân trang
            queryBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            // Đếm tổng
            st = c.prepareStatement(countQueryBuilder.toString());
            setParameters(st, params);
            rs = st.executeQuery();
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
            rs.close();
            st.close();

            // Lấy data
            st = c.prepareStatement(queryBuilder.toString());
            setParameters(st, params);
            st.setInt(params.size() + 1, offset);
            st.setInt(params.size() + 2, pageSize);

            rs = st.executeQuery();
            while (rs.next()) {
                products.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return new Page<>(products, page, pageSize, totalCount);
    }

    // ===== [NEW] Ép kiểu param theo loại cột để tránh convert ngầm & tận dụng index =====
    private Object castParam(String raw, String kind) {
        if (raw == null) {
            return null;
        }
        String v = raw.trim();
        try {
            switch (kind) {
                case "int":
                    return Integer.valueOf(v);
                case "long":
                    return Long.valueOf(v);
                case "decimal":
                    return new java.math.BigDecimal(v);
                case "bool":
                    return Boolean.valueOf(v);
                case "datetime":
                    return java.sql.Timestamp.valueOf(v); // điều chỉnh theo format bạn dùng
                default:
                    return v; // string / nvarchar
            }
        } catch (Exception e) {
            // Nếu parse thất bại, trả về chuỗi thô để không vỡ query (hoặc bạn có thể ném lỗi tùy ý)
            return v;
        }
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

        p.setSlug(rs.getString("slug"));

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
            st.setString(11, e.getSlug());
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

    public boolean update(Products newProduct) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, newProduct.getName());
            st.setString(2, newProduct.getSku());
            st.setDouble(3, newProduct.getPrice());
            st.setString(4, newProduct.getProduct_type());
            st.setInt(5, newProduct.getModel_id());
            st.setInt(6, newProduct.getMemory_id());
            st.setInt(7, newProduct.getGuarantee_id());
            st.setInt(8, newProduct.getQuantity());
            st.setString(9, newProduct.getDescription_html());
            st.setString(10, newProduct.getStatus());
            st.setString(11, newProduct.getSlug());
            st.setInt(12, newProduct.getId());

            return st.executeUpdate() > 0; // true nếu cập nhật thành công
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    public boolean deleteProductById(int productId) {
        Connection c = null;
        PreparedStatement st = null;
        String sql = "UPDATE Products SET status = 'inactive', updated_at = GETDATE() WHERE id = ?";
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setInt(1, productId);
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            close(c, st, null);
        }
    }

    public Page<Products> getMayChoiGame(ProductFilter filter, String condition) {
        ModelsDAO mdao = new ModelsDAO();
        int model_id = mdao.getIdByType("Máy chơi game");
        if (condition.equals("all")) {
            Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
            where.put("model_id", String.valueOf(model_id));
            return getProductsByConditions(filter, where);
        } else if (condition.equals("nintendo")) {
            Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
            where.put("model_id", String.valueOf(model_id));
            where.put("product_type", "nintendo");
            return getProductsByConditions(filter, where);
        } else if (condition.equals("sony")) {
            Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
            where.put("model_id", String.valueOf(model_id));
            where.put("product_type", "sony");
            return getProductsByConditions(filter, where);
        } else if (condition.equals("others")) {
            Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
            where.put("model_id", String.valueOf(model_id));
            where.put("product_type", "others");
            return getProductsByConditions(filter, where);
        }
        return null;
    }

    public Page<Products> getListTheGame(ProductFilter filter) {
        ModelsDAO mdao = new ModelsDAO();
        int model_id = mdao.getIdByType("Thẻ game");
        Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
        where.put("model_id", String.valueOf(model_id));
        return getProductsByConditions(filter, where);
    }

    public Page<Products> getListSanPhamKhac(ProductFilter filter) {
        ModelsDAO mdao = new ModelsDAO();
        int model_id = mdao.getIdByType("Sản phẩm khác");
        Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
        where.put("model_id", String.valueOf(model_id));
        return getProductsByConditions(filter, where);
    }

    public List<Products> getByType(int productId) {
        Products pro = getById(productId);
//        lay type cua product de lay ra ca san pham có cung type lien quan
        String pro_type = pro.getProduct_type();

        List<Products> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_TYPE);
            st.setString(1, pro_type);
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

    public Products findBySlug(String slug) {
        try ( Connection c = DBUtils.getConnection();  PreparedStatement st = c.prepareStatement(GET_BY_SLUG)) {
            st.setString(1, slug);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateSlug(int id, String slug) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE dbo.Products SET slug = ? WHERE id = ?";
        try ( Connection c = DBUtils.getConnection();  PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, slug);
            st.setInt(2, id);
            st.executeUpdate();
        }
    }

}
