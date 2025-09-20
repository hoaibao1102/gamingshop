package filter;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthUtils;

@WebFilter(filterName = "AdminAuthorizationFilter", urlPatterns = {
    "/banners.jsp",
    "/bannersUpdate.jsp",
    "/postsUpdate.jsp",
    "/products.jsp",
    "/productsUpdate.jsp",
    "/accessoryList.jsp",
    "/accessoryUpdate.jsp",
    "/modelList.jsp",
    "/modelUpdate.jsp",
    "/serviceList.jsp",
    "/serviceUpdate.jsp",
    "/MainController",
    "/UploadImageController",
    "/UploadVideoController",
    "/ProductController",
    "/BannerController"
})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
//        System.out.println("AdminAuthorizationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String action = httpRequest.getParameter("action");
        String uri = httpRequest.getRequestURI();

        if (!AuthUtils.isLoggedIn(httpRequest)) {
            if (uri.endsWith("banners.jsp")
                    || uri.endsWith("bannersUpdate.jsp")
                    || uri.endsWith("postsUpdate.jsp")
                    || uri.endsWith("products.jsp")
                    || uri.endsWith("productsUpdate.jsp")
                    || uri.endsWith("accessoryList.jsp")
                    || uri.endsWith("accessoryUpdate.jsp")
                    || uri.endsWith("modelList.jsp")
                    || uri.endsWith("modelUpdate.jsp")
                    || uri.endsWith("serviceList.jsp")
                    || uri.endsWith("serviceUpdate.jsp")
                    || "deleteService".equals(action)
                    || "editService".equals(action)
                    || "showEditService".equals(action)
                    || "showAddService".equals(action)
                    || "addService".equals(action)
                    || "viewServiceList".equals(action)
                    || "deleteModel".equals(action)
                    || "editModel".equals(action)
                    || "showEditModel".equals(action)
                    || "showAddModel".equals(action)
                    || "addModel".equals(action)
                    || "viewModelList".equals(action)
                    || "viewAllAccessories".equals(action)
                    || "searchAccessory".equals(action)
                    || "showAddAccessoryForm".equals(action)
                    || "addAccessory".equals(action)
                    || "editAccessory".equals(action)
                    || "showEditAccessoryForm".equals(action)
                    || "deleteAccessory".equals(action)
                    || "showAddProductForm".equals(action)
                    || "addProduct".equals(action)
                    || "editMainProduct".equals(action)
                    || "editImageProduct".equals(action)
                    || "deleteProduct".equals(action)
                    || "deleteImageProduct".equals(action)
                    || "addPosts".equals(action)
                    || "showAddPosts".equals(action)
                    || "deletePosts".equals(action)
                    || "deleteImagePost".equals(action)
                    || "goToUpdatePosts".equals(action)
                    || "updatePosts".equals(action)
                    || "getAllBanner".equals(action)
                    || "addBanner".equals(action)
                    || "showAddBannerForm".equals(action)
                    || "updateBanner".equals(action)
                    || "searchBanner".equals(action)
                    || "deleteBanner".equals(action)
                    || "editBanners".equals(action)) {
                httpRequest.setAttribute("checkError", "You do not have permission to access this page.");
                httpRequest.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("AdminAuthorizationFilter destroyed");
    }
}
