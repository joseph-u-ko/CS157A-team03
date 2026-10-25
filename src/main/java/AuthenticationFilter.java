import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// List the exact relative URLs of the specific JSPs you want to protect
@WebFilter(urlPatterns = {
    "/home.jsp",
    "/pack-open-dropdowns.jsp" 
}) 
public class AuthenticationFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        String loginPage = "login-and-signup.jsp";

        // Check if the required session attribute is missing
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(loginPage);
            return; // Block access to the JSP
        }

        chain.doFilter(request, response); // Allow access to the JSP
    }

    @Override public void init(FilterConfig filterConfig) throws ServletException {}
    @Override public void destroy() {}
}
