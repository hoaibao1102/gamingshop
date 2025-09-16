package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MainController", urlPatterns = {"/MainController", "/mc", ""})
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
            if (action == null || !isUserAction(action) || !isProductAction(action)) {
                url = "ProductController?action=prepareHome";
            }
            if (isUserAction(action)) {
                url = "/UserController";
            } else if (isProductAction(action)) {
                url = "/ProductController";
            } else if (isBannersAction(action)) {
                url = "/BannerController";
            }

        } catch (Exception e) {
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
        //
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

    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action);
    }

    private boolean isProductAction(String action) {
        return "searchProduct".equals(action)
                || "filterProducts".equals(action)
                || "showAddProductForm".equals(action)
                || "addProduct".equals(action)
                || "editMainProduct".equals(action)
                || "editImageProduct".equals(action)
                || "deleteProduct".equals(action)
                || "viewAllAccessories".equals(action)
                || "searchAccessory".equals(action)
                || "showAddAccessoryForm".equals(action)
                || "addAccessory".equals(action)
                || "editAccessory".equals(action)
                || "deleteAccessory".equals(action)
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
                || "viewAllProducts".equals(action);
    }

    private boolean isBannersAction(String action) {
        return "getAllBannerActive".equals(action)
                || "addBanner".equals(action)
                || "showAddBannerForm".equals(action)
                || "deleteBanner".equals(action)
                || "updateBanner".equals(action)
                || "searchBanner".equals(action)
                || "editBanners".equals(action);
    }

}
