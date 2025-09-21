/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Page;
import dto.ProductFilter;
import dto.Services;
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
public class ServicesDAO implements IDAO<Services, Integer> {

    private static final String GET_ALL = "SELECT * FROM dbo.Services";
    private static final String GET_BY_ID = "SELECT * FROM dbo.Services WHERE id = ?";
    private static final String GET_BY_NAME = "SELECT * FROM dbo.Services WHERE service_type LIKE ?";
    private static final String CREATE = "INSERT INTO dbo.Services (service_type, description_html, price, status) VALUES (?, ?, ?, ?)";
    private static final String CHECK_SERVICE_TYPE_EXISTS = "SELECT COUNT(*) FROM dbo.Services WHERE service_type = ?";
    private static final String GET_ALL_ACTIVE = "SELECT * FROM dbo.Services WHERE status = 'active'";
    private static final String CHECK_SERVICES_TYPE_EXISTS_EXCEPT = "SELECT COUNT(*) FROM dbo.Services WHERE service_type = ? AND id != ?";
    private static final String UPDATE = "UPDATE dbo.Services SET service_type = ?, description_html = ?, price = ?, status = ?, updated_at = GETDATE() WHERE id = ?";

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
            ps.setDouble(3, existingService.getPrice());
            ps.setString(4, existingService.getStatus());
            ps.setInt(5, existingService.getId());
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
    
        // ===== Main method với điều kiện tùy chỉnh =====
    public Page<Services> getListServicesWithCondition(ProductFilter filter, Map<String, String> equalsConditions) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        List<Services> services = new ArrayList<>();
        int totalCount = 0;

        // ===== Clamp phân trang =====
        int page = (filter != null && filter.getPage() > 0) ? filter.getPage() : 1;
        int pageSize = (filter != null && filter.getPageSize() > 0) ? filter.getPageSize() : 12;
        pageSize = Math.min(Math.max(pageSize, 1), 100);
        int offset = (page - 1) * pageSize;

        // ===== Whitelist & kiểu dữ liệu (khớp DB) =====
        final Set<String> ALLOWED_FILTER_FIELDS = new HashSet<>(Arrays.asList(
                "id", "service_type", "description_html", "price", "created_at", "updated_at", "status"));

        final Map<String, String> FIELD_TYPES = new HashMap<>();
        FIELD_TYPES.put("id", "int");
        FIELD_TYPES.put("service_type", "string");
        FIELD_TYPES.put("description_html", "string");
        FIELD_TYPES.put("price", "decimal");
        FIELD_TYPES.put("created_at", "datetime");
        FIELD_TYPES.put("updated_at", "datetime");
        FIELD_TYPES.put("status", "string");

        try {
            c = DBUtils.getConnection();

            StringBuilder queryBuilder = new StringBuilder("SELECT * FROM dbo.Services WHERE 1=1");
            StringBuilder countQueryBuilder = new StringBuilder("SELECT COUNT(*) FROM dbo.Services WHERE 1=1");
            List<Object> params = new ArrayList<>();

            // điều kiện có sẵn trong ProductFilter
            addFilterConditions(queryBuilder, countQueryBuilder, filter, params);

            // ===== N điều kiện equals từ Map =====
            if (equalsConditions != null && !equalsConditions.isEmpty()) {
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

            // ORDER BY mặc định
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
                services.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return new Page<>(services, page, pageSize, totalCount);
    }

    // ===== Ép kiểu param theo loại cột =====
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
                    return java.sql.Timestamp.valueOf(v);
                default:
                    return v; // string / nvarchar
            }
        } catch (Exception e) {
            return v;
        }
    }

    // ===== ORDER BY cho Services =====
    private void addOrderBy(StringBuilder queryBuilder, String sortBy) {
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "service_type_asc";
        }

        switch (sortBy) {
            case "service_type_asc":
                queryBuilder.append(" ORDER BY service_type ASC");
                break;
            case "service_type_desc":
                queryBuilder.append(" ORDER BY service_type DESC");
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
                queryBuilder.append(" ORDER BY service_type ASC");
        }
    }

    // ===== Filter conditions cho Services =====
    private void addFilterConditions(StringBuilder q, StringBuilder cq, ProductFilter filter, List<Object> params) {
        String conditions = "";

        // Filter theo service_type (tương tự name trong Accessories)
        if (filter.getName() != null && !filter.getName().trim().isEmpty()) {
            conditions += " AND service_type LIKE ?";
            params.add("%" + filter.getName().trim() + "%");
        }

        // Filter theo giá
        if (filter.getMinPrice() != null && filter.getMinPrice() >= 0) {
            conditions += " AND price >= ?";
            params.add(filter.getMinPrice());
        }

        if (filter.getMaxPrice() != null && filter.getMaxPrice() > 0) {
            conditions += " AND price <= ?";
            params.add(filter.getMaxPrice());
        }

        // Status active
        conditions += " AND status = 'active'";

        q.append(conditions);
        cq.append(conditions);
    }

    // ===== Set parameters =====
    private void setParameters(PreparedStatement st, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            st.setObject(i + 1, params.get(i));
        }
    }

    // ===== Lấy tất cả services active =====
    public Page<Services> getAllActiveServices(ProductFilter filter) {
        Map<String, String> where = new LinkedHashMap<>();
        where.put("status", "active");
        return getListServicesWithCondition(filter, where);
    }

    // ===== Lấy services theo type =====
    public Page<Services> getServicesByType(String serviceType, ProductFilter filter) {
        Map<String, String> where = new LinkedHashMap<>();
        where.put("service_type", serviceType);
        where.put("status", "Active");
        return getListServicesWithCondition(filter, where);
    }

    // ===== Lấy service theo ID =====
    public Services getServiceById(int id) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        Services service = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement("SELECT * FROM dbo.Services WHERE id = ? AND status = 'Active'");
            st.setInt(1, id);
            rs = st.executeQuery();
            
            if (rs.next()) {
                service = map(rs);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return service;
    }

    // ===== Lấy tất cả services không phân trang =====
    public List<Services> getAllServices() {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        List<Services> services = new ArrayList<>();

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL_ACTIVE + " ORDER BY service_type ASC");
            rs = st.executeQuery();
            
            while (rs.next()) {
                services.add(map(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return services;
    }

    // ===== Đếm số lượng services =====
    public int countServices() {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        int count = 0;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement("SELECT COUNT(*) FROM dbo.Services WHERE status = 'active'");
            rs = st.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            close(c, st, rs);
        }
        return count;
    }

    // ===== Tìm kiếm services =====
    public Page<Services> searchServices(String keyword, ProductFilter filter) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveServices(filter);
        }
        
        ProductFilter searchFilter = filter != null ? filter : new ProductFilter();
        searchFilter.setName(keyword); // Sử dụng field name để search service_type
        
        return getAllActiveServices(searchFilter);
    }
}
