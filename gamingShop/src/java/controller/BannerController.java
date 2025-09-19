/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BannersDAO;
import dto.Banners;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "BannerController", urlPatterns = {"/BannerController"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class BannerController extends HttpServlet {

    String INDEX_PAGE = "index.jsp";
    private final BannersDAO bannersDAO = new BannersDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String url = INDEX_PAGE;
        try {
            String action = request.getParameter("action");

            if (action.equals("getAllBannerActive")) {
                url = handleGetAllBannerActive(request, response);
            } else if (action.equals("getAllBanner")) {
                url = handleGetAllBanner(request, response);
            } else if (action.equals("addBanner")) {
                url = handleAddBanner(request, response);
            } else if (action.equals("showAddBannerForm")) {
                url = handleShowAddBannerForm(request, response);
            } else if (action.equals("updateBanner")) {
                url = handleUpdateBanner(request, response);
            } else if (action.equals("searchBanner")) {
                url = handleSearchBanner(request, response);
            } else if (action.equals("deleteBanner")) {
                url = handleDeleteBanner(request, response);
            } else if (action.equals("editBanners")) {
                url = handleEditBanner(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error: " + e.getMessage());
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

    private String handleGetAllBannerActive(HttpServletRequest request, HttpServletResponse response) {
        List<Banners> topBanners = bannersDAO.getTop5Active();
        request.setAttribute("topBanners", topBanners);
        return "";
    }
    
    private String handleGetAllBanner(HttpServletRequest request, HttpServletResponse response) {
        List<Banners> list = bannersDAO.getAll();
        request.setAttribute("list", list);
        return "banners.jsp";
    }

    private String handleAddBanner(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            // ===== Lấy dữ liệu từ form =====
            String title = request.getParameter("title");
            String statusRaw = request.getParameter("status");
            String status = (statusRaw != null && statusRaw.equalsIgnoreCase("active")) ? "active" : "inactive";

            // ===== Chuẩn bị DTO =====
            Banners newBanner = new Banners();
            newBanner.setTitle(title);
            newBanner.setStatus(status);

            // ===== Upload 1 ảnh (nếu có) và set vào image_url =====
            // Tên field trong form: "imageFile"
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
            }

            String storedRelativeUrl = null; // ví dụ: "assets/img/banners/1694512345678_abcdef.jpg"
            if (imagePart != null && imagePart.getSize() > 0) {
                // Chỉ cho phép ảnh (đơn giản): content-type phải bắt đầu bằng "image/"
                String contentType = imagePart.getContentType();
                if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    request.setAttribute("checkErrorAddBanner", "File tải lên không phải là ảnh hợp lệ.");
                    return "bannersUpdate.jsp";
                }

                // Thư mục lưu ảnh trên server
                String uploadDirPath = request.getServletContext().getRealPath("/assets/img/banners/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Lấy extension an toàn
                String originalFileName = java.nio.file.Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0 && dot < originalFileName.length() - 1) {
                    fileExtension = originalFileName.substring(dot); // gồm cả dấu chấm
                }

                // Đặt tên file không phụ thuộc ID (vì DAO.create chỉ trả boolean)
                String safeName = System.currentTimeMillis() + "_" + java.util.UUID.randomUUID().toString().replace("-", "");
                String finalName = safeName + fileExtension;
                File finalFile = new File(uploadDir, finalName);

                imagePart.write(finalFile.getAbsolutePath());

                storedRelativeUrl = "assets/img/banners/" + finalName;
                newBanner.setImage_url(storedRelativeUrl);
            } else {
                // Không upload ảnh
                newBanner.setImage_url(null);
            }

            // ===== Insert DB =====
            boolean ok = bannersDAO.create(newBanner);
            if (!ok) {
                // Nếu insert fail và đã có file ảnh → nên xoá để tránh rác
                if (storedRelativeUrl != null) {
                    try {
                        String abs = request.getServletContext().getRealPath("/" + storedRelativeUrl);
                        new File(abs).delete();
                    } catch (Exception ignore) {
                    }
                }
                request.setAttribute("checkErrorAddBanner", "Failed to add banner.");
                return "bannersUpdate.jsp";
            }

            // ===== Success =====
            HttpSession session = request.getSession();
            // Xoá cache liên quan banners nếu có
            session.removeAttribute("cachedBannersListEdit");

            request.setAttribute("messageAddBanner", "New banner added successfully.");
//            request.setAttribute("banners", newBanner);
            request.setAttribute("editBanner", newBanner);
            // Lấy lại danh sách banners từ DB
            List<Banners> bannersList = bannersDAO.getAll();
            request.setAttribute("banners", bannersList);// để JSP show chi tiết (title, status, image_url...)
            return "bannersUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding banner: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleUpdateBanner(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");

            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String statusRaw = request.getParameter("status");
            String status = (statusRaw != null && statusRaw.equalsIgnoreCase("active")) ? "active" : "inactive";

            // Lấy banner cũ để kiểm tra ảnh cũ
            Banners oldBanner = bannersDAO.getById(id);
            if (oldBanner == null) {
                request.setAttribute("checkErrorUpdateBanner", "Banner not found.");
                return "bannersUpdate.jsp";
            }

            // Banner mới để update
            Banners updatedBanner = new Banners();
            updatedBanner.setId(id);
            updatedBanner.setTitle(title);
            updatedBanner.setStatus(status);
            updatedBanner.setImage_url(oldBanner.getImage_url()); // mặc định giữ ảnh cũ

            // Xử lý upload ảnh mới (nếu có)
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (Exception ignore) {
            }

            if (imagePart != null && imagePart.getSize() > 0) {
                String contentType = imagePart.getContentType();
                if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    request.setAttribute("checkErrorUpdateBanner", "File tải lên không phải là ảnh hợp lệ.");
                    return "bannersUpdate.jsp";
                }

                String uploadDirPath = request.getServletContext().getRealPath("/assets/img/banners/");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String originalFileName = java.nio.file.Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = "";
                int dot = originalFileName.lastIndexOf('.');
                if (dot >= 0 && dot < originalFileName.length() - 1) {
                    fileExtension = originalFileName.substring(dot);
                }

                String safeName = System.currentTimeMillis() + "_" + java.util.UUID.randomUUID().toString().replace("-", "");
                String finalName = safeName + fileExtension;
                File finalFile = new File(uploadDir, finalName);

                imagePart.write(finalFile.getAbsolutePath());

                String storedRelativeUrl = "assets/img/banners/" + finalName;
                updatedBanner.setImage_url(storedRelativeUrl);

                // Xóa ảnh cũ nếu có
                if (oldBanner.getImage_url() != null) {
                    try {
                        String absOld = request.getServletContext().getRealPath("/" + oldBanner.getImage_url());
                        new File(absOld).delete();
                    } catch (Exception ignore) {
                    }
                }
            }

            boolean ok = bannersDAO.update(updatedBanner);
            if (!ok) {
                request.setAttribute("checkErrorUpdateBanner", "Failed to update banner.");
                return "bannersUpdate.jsp";
            }

            request.setAttribute("messageUpdateBanner", "Banner updated successfully.");
            List<Banners> bannersList = bannersDAO.getAll();
            request.setAttribute("editBanner", updatedBanner);

            return "bannersUpdate.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorUpdateBanner", "Unexpected error: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleShowAddBannerForm(HttpServletRequest request, HttpServletResponse response) {
        request.setAttribute("banners", null);
        return "bannersUpdate.jsp";
    }

    private String handleSearchBanner(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            String keyword = request.getParameter("keyword");

            List<Banners> list;
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = bannersDAO.getByName(keyword.trim());
            } else {
                list = bannersDAO.getAll();
            }

            if (list == null || list.isEmpty()) {
                request.setAttribute("checkErrorSearchBanner", "No banners found.");
            } else {
                request.setAttribute("list", list);
            }

            return "banners.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorSearchBanner", "Unexpected error: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleDeleteBanner(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("id"));

            if (id < 1) {
                request.setAttribute("checkErrorDeleteBanners", "Missing banner_id.");
                return "bannersUpdate.jsp";
            }

            boolean success = bannersDAO.deleteBannerById(id);

            if (success) {
                // Nếu có cache list sản phẩm để edit trong session thì xoá để lần sau nạp mới
                request.getSession().removeAttribute("cachedBannerListEdit");
                request.setAttribute("messageDeleteBanners", "Banner deleted successfully.");
            } else {
                request.setAttribute("checkErrorDeletePosts", "Failed to delete banner.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkErrorDeletePosts", "Unexpected error: " + e.getMessage());
            return "bannersUpdate.jsp";
        }
        return "MainController?action=getAllBanner";
    }

    private String handleEditBanner(HttpServletRequest request, HttpServletResponse response) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Banners banner = bannersDAO.getById(id);
            if (banner != null) {
                request.setAttribute("editBanner", banner); // ✅ đặt đúng tên
                return "bannersUpdate.jsp"; // trang form edit
            } else {
                request.setAttribute("errorMessage", "Banner not found!");
                return "error.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error while loading banner for edit: " + e.getMessage());
            return "error.jsp";
        }
    }

}
