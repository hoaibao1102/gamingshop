package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(
        name = "MainController",
        urlPatterns = {"/product/*", "/accessory/*", "/service/*", "/post/*", "/MainController", "/mc", ""}
)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class MainController extends HttpServlet {

    private static final String WELCOME = "index.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = WELCOME;

        try {
            String action = request.getParameter("action");
            String servletPath = request.getServletPath(); // "/product" hoặc "/accessory"
            String pathInfo = request.getPathInfo();       // "/slug-abc-123"

            if (pathInfo != null && pathInfo.length() > 1) {
                String slug = pathInfo.substring(1); // bỏ dấu /
                request.setAttribute("slugFromPath", slug);
                if (servletPath.equals("/product")) {
                    url = "/ProductController?action=getProduct";
                } else if (servletPath.equals("/accessory")) {
                    url = "/AccessoryController?action=getAccessory";
                } else if (servletPath.equals("/service")) {
                    url = "/ProductController?action=getService";
                } else if (servletPath.equals("/post")) {
                    url = "/ProductController?action=viewPost";
                }
            } else if (action == null || action.trim().isEmpty()) {
                url = "ProductController?action=prepareHome";
            } else if (isUserAction(action)) {
                url = "/UserController?action=" + action;
            } else if (isBannersAction(action)) {
                url = "/BannerController?action=" + action;
            } else if (isAccessoryAction(action)) {
                url = "/AccessoryController?action=" + action;
            } else if (isProductAction(action)) {
                url = "/ProductController?action=" + action;
            } else {
                // fallback an toàn
                url = "ProductController?action=prepareHome";
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Main routing controller";
    }

    // ===== Helper Methods =====
    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action)
                || "goLoginForm".equals(action);
    }

    private boolean isProductAction(String action) {
        return "searchProduct".equals(action)
                || "filterProducts".equals(action)
                || "showAddProductForm".equals(action)
                || "addProduct".equals(action)
                || "editMainProduct".equals(action)
                || "editImageProduct".equals(action)
                || "deleteProduct".equals(action)
                || "searchPosts".equals(action)
                || "viewAllPost".equals(action)
                || "addPosts".equals(action)
                || "deletePosts".equals(action)
                || "updatePosts".equals(action)
                || "goToUpdatePosts".equals(action)
                || "getProduct".equals(action)
                || "deleteImageProduct".equals(action)
                || "getProminentList".equals(action)
                || "viewModelList".equals(action)
                || "addModel".equals(action)
                || "showAddModel".equals(action)
                || "showEditModel".equals(action)
                || "editModel".equals(action)
                || "deleteModel".equals(action)
                || "viewServiceList".equals(action)
                || "addService".equals(action)
                || "showAddService".equals(action)
                || "showEditService".equals(action)
                || "editService".equals(action)
                || "deleteService".equals(action)
                || "listMayChoiGame".equals(action)
                || "listTheGame".equals(action)
                || "viewAllProducts".equals(action)
                || "showAddPosts".equals(action)
                || "viewPost".equals(action)
                || "getService".equals(action)
                || "listDichVu".equals(action)
                || "listSanPhamCongNghe".equals(action)
                || "getAccessoryBySlug".equals(action)
                || "getProductsBySlug".equals(action);
    }

    private boolean isBannersAction(String action) {
        return "getAllBannerActive".equals(action)
                || "addBanner".equals(action)
                || "showAddBannerForm".equals(action)
                || "deleteBanner".equals(action)
                || "updateBanner".equals(action)
                || "searchBanner".equals(action)
                || "goBannerTextForm".equals(action)
                || "editBanners".equals(action)
                || "updateBannerText".equals(action)
                || "getAllBanner".equals(action);
    }

    private boolean isAccessoryAction(String action) {
        return "listPhuKien".equals(action)
                || "viewAllAccessories".equals(action)
                || "searchAccessory".equals(action)
                || "showAddAccessoryForm".equals(action)
                || "addAccessory".equals(action)
                || "editAccessory".equals(action)
                || "showEditAccessoryForm".equals(action)
                || "deleteAccessory".equals(action)
                || "getAccessory".equals(action);
    }
}
