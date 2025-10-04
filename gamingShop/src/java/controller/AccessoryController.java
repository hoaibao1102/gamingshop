/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccessoriesDAO;
import dao.BannersDAO;
import dto.Accessories;
import dto.Banners;
import dto.Page;
import dto.ProductFilter;
import dto.Product_images;
import dto.Products;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import utils.SlugUtil;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AccessoryController", urlPatterns = {"/AccessoryController"})
public class AccessoryController extends HttpServlet {

    private final String INDEX_PAGE = "index.jsp";
    private final AccessoriesDAO accessoriesDAO = new AccessoriesDAO();
    private final BannersDAO bannersDAO = new BannersDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = INDEX_PAGE;

        String action = request.getParameter("action");
        String pathInfo = request.getPathInfo(); // lấy slug nếu có

        try {
            // ===== Xử lý slug =====
            if (pathInfo != null && pathInfo.length() > 1) {
                String slug = pathInfo.substring(1);
                request.setAttribute("slugFromPath", slug);
                url = handleGetAccessory(request, response);
            } // ===== Xử lý các action bình thường =====
            else if ("listPhuKien".equals(action)) {
                url = handleListPhuKien(request, response);
            } else if ("viewAllAccessories".equals(action)) {
                url = handleViewAllAccessories(request, response);
            } else if ("searchAccessory".equals(action)) {
                url = handleAccessorySearching(request, response);
            } else if ("showAddAccessoryForm".equals(action)) {
                url = handleShowAddAccessoryForm(request, response);
            } else if ("addAccessory".equals(action)) {
                url = handleAccessoryAdding(request, response);
            } else if ("showEditAccessoryForm".equals(action)) {
                url = handleShowEditAccessoryForm(request, response);
            } else if ("editAccessory".equals(action)) {
                url = handleAccessoryEditing(request, response);
            } else if ("deleteAccessory".equals(action)) {
                url = handleAccessoryDelete(request, response);
            } else if ("getAccessory".equals(action)) {
                url = handleGetAccessory(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String handleListPhuKien(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            // Tạo filter mặc định
            ProductFilter filter = new ProductFilter();

            // Lấy tham số page nếu có
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    int page = Integer.parseInt(pageParam);
                    if (page > 0) {
                        filter.setPage(page);
                    }
                } catch (NumberFormatException e) {
                    // Ignore, dùng page mặc định
                }
            }

            // Lấy dữ liệu với phân trang (Accessories đã có coverImg từ DB)
            Page<Accessories> pageResult = accessoriesDAO.getListAccessotiesBuy(filter);

            // Lấy banner
            List<Banners> listBanner = bannersDAO.getTop5Active();

            // Gán dữ liệu cho request
            request.setAttribute("topBanners", listBanner);
            request.setAttribute("nameProductsByCategory", "Phụ kiện");
            request.setAttribute("accessories", pageResult.getContent());
            request.setAttribute("accessoriesPage", pageResult);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading accessories: " + e.getMessage());
        }

        // Lấy action để hiển thị breadcrumb hoặc xử lý điều hướng
        String action = request.getParameter("action");
        request.setAttribute("action", action);

        return INDEX_PAGE;
    }

    /**
     * Hiển thị danh sách tất cả accessories với phân trang
     */
    private String handleViewAllAccessories(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy tất cả accessories từ database
            List<Accessories> accessories = accessoriesDAO.getAll();

            // Set vào request để JSP hiển thị
            request.setAttribute("accessories", accessories);

            // Thông báo nếu không có dữ liệu
            if (accessories == null || accessories.isEmpty()) {
                request.setAttribute("checkError", "No accessories found. Start by adding your first accessory.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading accessories: " + e.getMessage());
            // Set empty list để tránh null pointer trong JSP
            request.setAttribute("accessories", new ArrayList<Accessories>());
        }

        return "accessoryList.jsp";
    }

    /**
     * Tìm kiếm accessories theo từ khóa
     */
    private String handleAccessorySearching(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy từ khóa tìm kiếm
            String keyword = request.getParameter("keyword");
            List<Accessories> accessories = new ArrayList<>();

            if (keyword != null && !keyword.trim().isEmpty()) {
                String trimmedKeyword = keyword.trim();

                // Tìm kiếm theo tên
                accessories = accessoriesDAO.getByName(trimmedKeyword);

                // Set keyword để hiển thị lại trong form
                request.setAttribute("keyword", trimmedKeyword);

                if (accessories == null || accessories.isEmpty()) {
                    request.setAttribute("checkError", "No accessories found with name containing: \"" + trimmedKeyword + "\"");
                    accessories = new ArrayList<>(); // Ensure not null
                } else {
                    // Thông báo số kết quả tìm được
                    request.setAttribute("searchResultCount", accessories.size());
                }
            } else {
                // Nếu không có từ khóa, hiển thị tất cả accessories
                accessories = accessoriesDAO.getAll();

                if (accessories == null) {
                    accessories = new ArrayList<>();
                }

                if (accessories.isEmpty()) {
                    request.setAttribute("checkError", "No accessories available.");
                }

                // Clear keyword
                request.setAttribute("keyword", "");
            }

            // Set accessories list
            request.setAttribute("accessories", accessories);

            // Set thông tin cho pagination (disable pagination trong search mode)
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalAccessories", accessories.size());
            request.setAttribute("isSearchMode", true); // Flag để JSP biết đang ở search mode

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error searching accessories: " + e.getMessage());

            // Set empty results
            request.setAttribute("accessories", new ArrayList<Accessories>());
            request.setAttribute("keyword", request.getParameter("keyword"));
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalAccessories", 0);
        }

        return "accessoryList.jsp";
    }

    /**
     * Hiển thị form thêm accessory mới
     */
    private String handleShowAddAccessoryForm(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("accessory", null);
        return "accessoryUpdate.jsp";
    }

    /**
     * DEBUG VERSION - Xử lý thêm accessory mới
     */
    private String handleAccessoryAdding(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // ===== Lấy dữ liệu từ form =====
            String name = request.getParameter("name");
            String quantityStr = request.getParameter("quantity");
            String priceStr = request.getParameter("price");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String gift = request.getParameter("gift");

            // ===== VALIDATION SECTION - ENHANCED =====
            // 1. Validate name - required and not empty
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("checkErrorAddAccessory", "Accessory name is required.");
                return "accessoryUpdate.jsp";
            }

            // 2. Validate name length (reasonable limit)
            if (name.trim().length() > 255) {
                request.setAttribute("checkErrorAddAccessory", "Accessory name must be 255 characters or less.");
                return "accessoryUpdate.jsp";
            }

//            // 3. NEW: Check for duplicate name (UNIQUE constraint validation)
//            try {
//                
//                if (accessoriesDAO.isNameExists(name)) {
//                    request.setAttribute("checkErrorAddAccessory", "Accessory name '" + name.trim() + "' already exists. Please choose a different name.");
//                    return "accessoryUpdate.jsp";
//                }
//            } catch (Exception e) {
//                // If we can't check, continue but log the error
//                e.printStackTrace();
//            }
            // 4. Validate quantity - required, numeric, and non-negative
            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                request.setAttribute("checkErrorAddAccessory", "Quantity is required.");
                return "accessoryUpdate.jsp";
            }

            // 5. Validate price - required, numeric, and non-negative
            if (priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("checkErrorAddAccessory", "Price is required.");
                return "accessoryUpdate.jsp";
            }

            int quantity = 0;
            double price = 0.0;
            try {
                quantity = Integer.parseInt(quantityStr.trim());

                // 6. Validate quantity range
                if (quantity < 0) {
                    request.setAttribute("checkErrorAddAccessory", "Quantity cannot be negative.");
                    return "accessoryUpdate.jsp";
                }

                // Optional: reasonable upper limit for quantity
                if (quantity > 999999) {
                    request.setAttribute("checkErrorAddAccessory", "Quantity cannot exceed 999,999.");
                    return "accessoryUpdate.jsp";
                }

            } catch (NumberFormatException e) {
                request.setAttribute("checkErrorAddAccessory", "Invalid quantity format. Please enter a valid number.");
                return "accessoryUpdate.jsp";
            }

            try {
                price = Double.parseDouble(priceStr.trim());

                // 7. Validate price range
                if (price < 0) {
                    request.setAttribute("checkErrorAddAccessory", "Price cannot be negative.");
                    return "accessoryUpdate.jsp";
                }

                // Optional: reasonable upper limit for price
                if (price > 999999999.99) {
                    request.setAttribute("checkErrorAddAccessory", "Price cannot exceed 999,999,999.99.");
                    return "accessoryUpdate.jsp";
                }

            } catch (NumberFormatException e) {
                e.getMessage();
                request.setAttribute("checkErrorAddAccessory", "Invalid price format. Please enter a valid decimal number.");
                return "accessoryUpdate.jsp";
            }

            // 8. NEW: Validate status value
            if (status != null && !status.trim().isEmpty()) {
                String normalizedStatus = status.trim().toLowerCase();
                if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                    request.setAttribute("checkErrorAddAccessory", "Status must be either 'active' or 'inactive'.");
                    return "accessoryUpdate.jsp";
                }
            }

            // 9. NEW: Validate gift value
            if (gift != null && !gift.trim().isEmpty()) {
                String normalizedGift = gift.trim();
                if (!normalizedGift.equals("Phụ kiện tặng kèm") && !normalizedGift.equals("Phụ kiện bán")) {
                    request.setAttribute("checkErrorAddAccessory", "Gift option must be either 'Phụ kiện bán' or 'Phụ kiện tặng kèm'.");
                    return "accessoryUpdate.jsp";
                }
            }

            // 10. NEW: Validate description length (optional but if provided, should be reasonable)
            if (description != null && description.trim().length() > 5000) {
                request.setAttribute("checkErrorAddAccessory", "Description must be 5000 characters or less.");
                return "accessoryUpdate.jsp";
            }

            // ===== Tạo đối tượng Accessories và set dữ liệu =====
            Accessories newAccessory = new Accessories();
            newAccessory.setName(name.trim());
            newAccessory.setQuantity(quantity);
            newAccessory.setPrice(price);
            newAccessory.setDescription(description != null ? description.trim() : "");
            newAccessory.setStatus(status != null ? status.trim() : "active");
            newAccessory.setGift(gift != null ? gift.trim() : "Phụ kiện tặng kèm");
            newAccessory.setCreated_at(new java.util.Date());
            newAccessory.setUpdated_at(new java.util.Date());

            // ===== Upload ảnh (nếu có) =====
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
//                System.out.println("DEBUG: Image part retrieved - "
//                        + (imagePart != null ? "Size: " + imagePart.getSize() + ", FileName: " + imagePart.getSubmittedFileName() : "NULL"));
            } catch (Exception e) {
                e.getMessage();
            }

            // 11. NEW: Validate image file if provided
            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Check file size (e.g., max 5MB)
                long maxFileSize = 5 * 1024 * 1024; // 5MB in bytes
                if (imagePart.getSize() > maxFileSize) {
                    request.setAttribute("checkErrorAddAccessory", "Image file size cannot exceed 5MB.");
                    return "accessoryUpdate.jsp";
                }

                // Check file extension
                String fileName = imagePart.getSubmittedFileName().toLowerCase();
                if (!fileName.endsWith(".jpg") && !fileName.endsWith(".jpeg")
                        && !fileName.endsWith(".png") && !fileName.endsWith(".gif")
                        && !fileName.endsWith(".bmp") && !fileName.endsWith(".webp")) {
                    request.setAttribute("checkErrorAddAccessory", "Only image files (jpg, jpeg, png, gif, bmp, webp) are allowed.");
                    return "accessoryUpdate.jsp";
                }
            }

            String storedImageUrl = null;
            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Thư mục lưu ảnh
                String uploadDirPath = request.getServletContext().getRealPath("/assets/accessories/");

                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Lấy extension
                String originalFileName = imagePart.getSubmittedFileName();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0 && dot < originalFileName.length() - 1) {
                    fileExtension = originalFileName.substring(dot);
                }

                // Tạo tên file tạm
                String tempName = "tmp_" + System.currentTimeMillis() + fileExtension;
                File tempFile = new File(uploadDir, tempName);

                try {
                    imagePart.write(tempFile.getAbsolutePath());
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("checkErrorAddAccessory", "Failed to upload image. Please try again.");
                    return "accessoryUpdate.jsp";
                }

                // Set image_url tạm thời là null để insert trước
                newAccessory.setCoverImg(null);

                // ===== Insert để lấy generated ID =====
                boolean success = accessoriesDAO.create(newAccessory);

                if (success && newAccessory.getId() > 0) {
                    // ===== Tạo slug và update lại accessory =====
                    try {
                        String slug = SlugUtil.toSlug(newAccessory.getName(), newAccessory.getId());
                        newAccessory.setSlug(slug);
                        accessoriesDAO.updateSlug(newAccessory.getId(), slug);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        request.setAttribute("warningSlug", "Accessory created but failed to generate slug: " + ex.getMessage());
                    }

                    // Đổi tên file theo ID thực
                    String finalName = "acc_" + newAccessory.getId() + "_1" + fileExtension;
                    File finalFile = new File(uploadDir, finalName);

                    boolean renamed = tempFile.renameTo(finalFile);

                    if (!renamed) {
                        // Copy và xóa file tạm nếu rename thất bại
                        try ( java.io.InputStream in = new java.io.FileInputStream(tempFile);  java.io.OutputStream out = new java.io.FileOutputStream(finalFile)) {
                            byte[] buf = new byte[8192];
                            int len;
                            while ((len = in.read(buf)) > 0) {
                                out.write(buf, 0, len);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    storedImageUrl = "assets/accessories/" + finalName;
                    newAccessory.setCoverImg(storedImageUrl);

                    // Update image_url vào DB
                    accessoriesDAO.update(newAccessory);

                } else {
                    // Insert thất bại -> xóa file tạm
                    if (tempFile.exists()) {
                        tempFile.delete();
                    }
                    request.setAttribute("checkErrorAddAccessory", "Failed to add accessory.");
                    return "accessoryUpdate.jsp";
                }

            } else {
                // KHÔNG có ảnh -> insert luôn
                newAccessory.setCoverImg(null);
                boolean success = accessoriesDAO.create(newAccessory);

                if (!success) {
                    request.setAttribute("checkErrorAddAccessory", "Failed to add accessory.");
                    return "accessoryUpdate.jsp";
                }
            }

            // ===== Success =====
            HttpSession session = request.getSession();
            session.removeAttribute("cachedAccessoryList");

            request.setAttribute("messageAddAccessory", "New accessory added successfully.");
            request.setAttribute("accessory", newAccessory);
            return "accessoryUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorAddAccessory", "Error while adding accessory: " + e.getMessage());
            return "accessoryUpdate.jsp";
        }
    }

    /**
     * Hiển thị form edit accessory
     */
    private String handleShowEditAccessoryForm(HttpServletRequest request, HttpServletResponse response) {
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int accessoryId = Integer.parseInt(idStr);
                Accessories accessory = accessoriesDAO.getById(accessoryId);

                if (accessory != null) {
                    request.setAttribute("accessory", accessory);
                    return "accessoryUpdate.jsp";
                } else {
                    request.setAttribute("checkError", "Accessory not found with ID: " + accessoryId);
                }
            } else {
                request.setAttribute("checkError", "Invalid accessory ID.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("checkError", "Invalid accessory ID format.");
        } catch (Exception e) {
            request.setAttribute("checkError", "Error loading accessory: " + e.getMessage());
        }

        return "accessoryList.jsp";
    }

    /**
     * Xử lý cập nhật
     */
    private String handleAccessoryEditing(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy ID
            int accessoryId = Integer.parseInt(request.getParameter("id"));
            Accessories existingAccessory = accessoriesDAO.getById(accessoryId);

            if (existingAccessory == null) {
                request.setAttribute("checkErrorEditAccessory", "Accessory not found.");
                return "accessoryUpdate.jsp";
            }

            // ===== Lấy dữ liệu từ form =====
            String name = request.getParameter("name");
            String quantityStr = request.getParameter("quantity");
            String priceStr = request.getParameter("price");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String gift = request.getParameter("gift");

            // ===== VALIDATION =====
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("checkErrorEditAccessory", "Accessory name is required.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

            if (name.trim().length() > 255) {
                request.setAttribute("checkErrorEditAccessory", "Accessory name must be 255 characters or less.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

            int quantity;
            double price;
            try {
                quantity = Integer.parseInt(quantityStr);
                price = Double.parseDouble(priceStr);

                if (quantity < 0 || quantity > 999999) {
                    request.setAttribute("checkErrorEditAccessory", "Quantity must be between 0 and 999,999.");
                    request.setAttribute("accessory", existingAccessory);
                    return "accessoryUpdate.jsp";
                }

                if (price < 0 || price > 999999999.99) {
                    request.setAttribute("checkErrorEditAccessory", "Price must be between 0 and 999,999,999.99.");
                    request.setAttribute("accessory", existingAccessory);
                    return "accessoryUpdate.jsp";
                }

            } catch (NumberFormatException e) {
                request.setAttribute("checkErrorEditAccessory", "Invalid quantity or price format.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

            // Validate status
            if (status != null && !status.trim().isEmpty()) {
                String normalizedStatus = status.trim().toLowerCase();
                if (!normalizedStatus.equals("active") && !normalizedStatus.equals("inactive")) {
                    request.setAttribute("checkErrorEditAccessory", "Status must be either 'active' or 'inactive'.");
                    request.setAttribute("accessory", existingAccessory);
                    return "accessoryUpdate.jsp";
                }
            }

            // Validate gift
            if (gift != null && !gift.trim().isEmpty()) {
                String normalizedGift = gift.trim();
                if (!normalizedGift.equals("Phụ kiện tặng kèm") && !normalizedGift.equals("Phụ kiện bán")) {
                    request.setAttribute("checkErrorEditAccessory", "Gift option must be either 'Phụ kiện bán' or 'Phụ kiện tặng kèm'.");
                    request.setAttribute("accessory", existingAccessory);
                    return "accessoryUpdate.jsp";
                }
            }

            // Validate description
            if (description != null && description.trim().length() > 5000) {
                request.setAttribute("checkErrorEditAccessory", "Description must be 5000 characters or less.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

            // ===== Update basic info =====
            existingAccessory.setName(name.trim());
            existingAccessory.setQuantity(quantity);
            existingAccessory.setPrice(price);
            existingAccessory.setDescription(description != null ? description.trim() : "");
            existingAccessory.setStatus(status != null ? status.trim() : "active");
            existingAccessory.setGift(gift != null ? gift.trim() : "Phụ kiện tặng kèm");
            existingAccessory.setUpdated_at(new java.util.Date());

            // ===== Xử lý ảnh mới (nếu có) =====
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
            }

            String oldImageUrl = existingAccessory.getCoverImg();

            if (imagePart != null && imagePart.getSize() > 0
                    && imagePart.getSubmittedFileName() != null
                    && !imagePart.getSubmittedFileName().trim().isEmpty()) {

                // Upload ảnh mới
                String uploadDirPath = request.getServletContext().getRealPath("/assets/accessories/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFileName = imagePart.getSubmittedFileName();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0) {
                    fileExtension = originalFileName.substring(dot);
                }

                String newFileName = "acc_" + accessoryId + "_" + System.currentTimeMillis() + fileExtension;
                File newFile = new File(uploadDir, newFileName);
                imagePart.write(newFile.getAbsolutePath());

                existingAccessory.setCoverImg("assets/accessories/" + newFileName);
            }

            // ===== Tạo slug tự động =====
            try {
                String slug = SlugUtil.toSlug(existingAccessory.getName(), existingAccessory.getId());
                existingAccessory.setSlug(slug);
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("warningSlug", "Accessory updated but failed to generate slug: " + ex.getMessage());
            }

            // ===== Update database =====
            boolean success = accessoriesDAO.update(existingAccessory);

            if (success) {
                // Xóa ảnh cũ nếu có ảnh mới
                if (imagePart != null && imagePart.getSize() > 0
                        && oldImageUrl != null && !oldImageUrl.isEmpty()) {
                    File oldFile = new File(request.getServletContext().getRealPath("/" + oldImageUrl));
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                HttpSession session = request.getSession();
                session.removeAttribute("cachedAccessoryList");

                request.setAttribute("messageEditAccessory", "Accessory updated successfully.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            } else {
                request.setAttribute("checkErrorEditAccessory", "Failed to update accessory.");
                request.setAttribute("accessory", existingAccessory);
                return "accessoryUpdate.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorEditAccessory", "Error while updating accessory: " + e.getMessage());
            return "accessoryUpdate.jsp";
        }
    }

    /**
     * Xử lý xóa accessory - Soft delete bằng cách chuyển status thành
     * "inactive"
     */
    private String handleAccessoryDelete(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy ID từ parameter
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("checkError", "Accessory ID is required.");
                return "accessoryList.jsp";
            }

            int accessoryId;
            try {
                accessoryId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                request.setAttribute("checkError", "Invalid accessory ID format.");
                return "accessoryList.jsp";
            }

            // Kiểm tra accessory có tồn tại không
            Accessories existingAccessory = accessoriesDAO.getById(accessoryId);
            if (existingAccessory == null) {
                request.setAttribute("checkError", "Accessory not found.");
                return "accessoryList.jsp";
            }

            // Kiểm tra xem đã inactive chưa
            if ("inactive".equalsIgnoreCase(existingAccessory.getStatus())) {
                request.setAttribute("checkError", "Accessory is already inactive.");
                return "accessoryList.jsp";
            }

            // Soft delete: chuyển status thành "inactive"
            existingAccessory.setStatus("inactive");
            existingAccessory.setUpdated_at(new java.util.Date());

            // Cập nhật vào database
            boolean success = accessoriesDAO.update(existingAccessory);

            if (success) {
                // Xóa cache nếu có
                HttpSession session = request.getSession();
                session.removeAttribute("cachedAccessoryList");

                request.setAttribute("messageDeleteAccessory",
                        "Accessory '" + existingAccessory.getName() + "' has been deactivated successfully.");

                // Có thể redirect về danh sách hoặc return view
                return "accessoryUpdate.jsp";

            } else {
                request.setAttribute("checkError",
                        "Failed to deactivate accessory. Please try again.");
                return "accessoryList.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError",
                    "Error while deactivating accessory: " + e.getMessage());
            return "accessoryList.jsp";
        }
    }

    private String handleGetAccessory(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding(java.nio.charset.StandardCharsets.UTF_8.name());

            Accessories accessory = null;

            // ===== 0) Lấy slug trước =====
            String slug = (String) request.getAttribute("slugFromPath");
            if (slug == null || slug.trim().isEmpty()) {
                slug = request.getParameter("slugAccessory");
            }

            // ===== 1) Nếu slug tồn tại, lấy theo slug =====
            if (slug != null && !slug.trim().isEmpty()) {
                accessory = accessoriesDAO.findBySlug(slug.trim());
                if (accessory == null) {
                    request.setAttribute("checkError", "No accessory found with slug: " + slug);
                }
            } else {
                // ===== 2) Nếu không có slug, thử lấy theo id =====
                String idParam = request.getParameter("idAccessory");
                if (idParam == null || idParam.trim().isEmpty()) {
                    request.setAttribute("checkError", "Invalid accessory ID or slug");
                    return "accessoryDetail.jsp";
                }
                try {
                    int id = Integer.parseInt(idParam);
                    accessory = accessoriesDAO.getById(id);
                    if (accessory == null) {
                        request.setAttribute("checkError", "No accessory found with ID: " + id);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("checkError", "Invalid accessory ID format");
                }
            }

            // ===== 3) Nếu có dữ liệu, set attribute =====
            if (accessory != null) {
                request.setAttribute("accessory", accessory);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading accessory: " + e.getMessage());
        }

        return "accessoryDetail.jsp";
    }

}
