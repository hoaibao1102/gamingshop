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
    "/MainController",
    "/UploadImageController",
    "/UploadVideoController",
    "/ProductController",
    "/BannerController"
})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AdminAuthorizationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String action = httpRequest.getParameter("action");
        String uri = httpRequest.getRequestURI();

//        if ("login".equals(action) || "logout".equals(action) || "viewAllProjects".equals(action)) {
//            chain.doFilter(request, response);
//            return;
//        }
        if (!AuthUtils.isLoggedIn(httpRequest)) {
            if (uri.endsWith("banners.jsp") 
                    || uri.endsWith("bannersUpdate.jsp") 
                    || uri.endsWith("postsUpdate.jsp")
                    || uri.endsWith("products.jsp")
                    || uri.endsWith("productsUpdate.jsp")
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
