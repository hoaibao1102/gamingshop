/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Accessories;
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

/**
 *
 * @author MSI PC
 */
public class AccessoriesDAO implements IDAO<Accessories, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Accessories";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Accessories WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Accessories WHERE name LIKE ? ";
    private static final String CREATE = "INSERT INTO dbo.Accessories (name, quantity, price, description_html, image_url, status, gift, slug) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE dbo.Accessories SET name = ?, quantity = ?, price = ?, description_html = ?, image_url = ?, status = ?, gift = ?, updated_at = GETDATE(), slug = ? WHERE id = ?";
    private static final String CHECK_EXIST_NAME = "SELECT COUNT(1) FROM dbo.Accessories WHERE name = ? AND status = 'active'";
    private static final String GET_ALL_ACTIVE = "SELECT * FROM dbo.Accessories WHERE status = 'active'";
    private static final String GET_BY_SLUG = "SELECT * FROM dbo.Accessories WHERE slug = ?";
    
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
            st.setString(5, e.getCoverImg());
            st.setString(6, e.getStatus());
            st.setString(7, e.getGift());
            st.setString(8, e.getSlug());
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
        a.setCoverImg(rs.getString("image_url"));

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
        a.setSlug(rs.getString("slug"));
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
            st.setString(5, e.getCoverImg());
            st.setString(6, e.getStatus());
            st.setString(7, e.getGift());
            st.setString(8, e.getSlug());
            st.setInt(9, e.getId()); // WHERE condition

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

        try ( Connection c = DBUtils.getConnection();  PreparedStatement st = c.prepareStatement(CHECK_EXIST_NAME)) {

            st.setString(1, name);

            try ( ResultSet rs = st.executeQuery()) {
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

    public Page<Accessories> getListAccessotiesWithCondition(ProductFilter filter, Map<String, String> equalsConditions) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        List<Accessories> accessories = new ArrayList<>();
        int totalCount = 0;

        // ===== Clamp phân trang =====
        int page = (filter != null && filter.getPage() > 0) ? filter.getPage() : 1;
        int pageSize = (filter != null && filter.getPageSize() > 0) ? filter.getPageSize() : 12;
        pageSize = Math.min(Math.max(pageSize, 1), 100);
        int offset = (page - 1) * pageSize;

        // ===== Whitelist & kiểu dữ liệu (khớp DB) =====
        final Set<String> ALLOWED_FILTER_FIELDS = new HashSet<>(Arrays.asList("id", "name", "quantity",
                "price", "description_html", "image_url", "created_at", "updated_at", "status", "gift"));

        final Map<String, String> FIELD_TYPES = new HashMap<>();
        FIELD_TYPES.put("id", "int");
        FIELD_TYPES.put("name", "string");
        FIELD_TYPES.put("quantity", "int");
        FIELD_TYPES.put("price", "decimal");   // decimal(10,2)
        FIELD_TYPES.put("description_html", "string");    // nvarchar(MAX)
        FIELD_TYPES.put("image_url", "string");    // nvarchar(1024)
        FIELD_TYPES.put("created_at", "datetime");  // datetime2(3)
        FIELD_TYPES.put("updated_at", "datetime");  // datetime2(3)
        FIELD_TYPES.put("status", "string");    // nvarchar(50)
        FIELD_TYPES.put("gift", "string");    // nvarchar(50)
        FIELD_TYPES.put("slug", "string");    // nvarchar(50)

        try {
            c = DBUtils.getConnection();

            StringBuilder queryBuilder = new StringBuilder("SELECT * FROM dbo.Accessories WHERE 1=1");
            StringBuilder countQueryBuilder = new StringBuilder("SELECT COUNT(*) FROM dbo.Accessories WHERE 1=1");
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
                accessories.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return new Page<>(accessories, page, pageSize, totalCount);
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

    private void addFilterConditions(StringBuilder q, StringBuilder cq, ProductFilter filter, List<Object> params) {
        String conditions = "";

        // CHỈ GIỮ những cột có thật trong Accessories
        if (filter.getName() != null && !filter.getName().trim().isEmpty()) {
            conditions += " AND name LIKE ?";
            params.add("%" + filter.getName().trim() + "%");
        }

        if (filter.getMinPrice() != null && filter.getMinPrice() >= 0) {
            conditions += " AND price >= ?";
            params.add(filter.getMinPrice());
        }

        if (filter.getMaxPrice() != null && filter.getMaxPrice() > 0) {
            conditions += " AND price <= ?";
            params.add(filter.getMaxPrice());
        }

        // Status đúng với constraint
        conditions += " AND status = 'Active'";

        q.append(conditions);
        cq.append(conditions);
    }

    private void setParameters(PreparedStatement st, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            st.setObject(i + 1, params.get(i));
        }
    }

    public Page<Accessories> getListAccessotiesBuy(ProductFilter filter) {

        Map<String, String> where = new LinkedHashMap<>(); // giữ thứ tự tham số
        where.put("gift", "Phụ kiện bán");
        return getListAccessotiesWithCondition(filter, where);
    }

    public List<Accessories> getActiveGiftAccessories() {
        List<Accessories> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM dbo.Accessories WHERE status = 'active' AND gift = N'Phụ kiện tặng kèm'";
        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(sql);
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

    public Accessories findBySlug(String slug) {
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
        String sql = "UPDATE dbo.Accessories SET slug = ? WHERE id = ?";
        try ( Connection c = DBUtils.getConnection();  PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, slug);
            st.setInt(2, id);
            st.executeUpdate();
        }
    }

}
