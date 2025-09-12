/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BannersDAO;
import dto.Banners;
import dto.Posts;
import dto.Products;
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
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
            } else if (action.equals("addBanner")) {
                url = handleAddBanner(request, response);
            } else if (action.equals("showAddBannerForm")) {
                url = handleShowAddBannerForm(request, response);
            } else if (action.equals("updateBanner")) {
                url = handleUpdateBanner(request, response);
            } else if (action.equals("searchBanner")) {
                url = handleSearchBanner(request, response);
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
        List<Banners> list = bannersDAO.getAll();
        request.setAttribute("list", list);
        return "testBanner.jsp";
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
            BannersDAO bannersDAO = new BannersDAO();
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
            request.setAttribute("banner", newBanner); // để JSP show chi tiết (title, status, image_url...)
            return "bannersUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding banner: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleUpdateBanner(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private String handleShowAddBannerForm(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private String handleSearchBanner(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
