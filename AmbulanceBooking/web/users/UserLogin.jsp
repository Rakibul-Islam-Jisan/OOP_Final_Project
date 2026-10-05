<%-- 
    Document   : UserLogin
    Created on : 30 Sept 2026, 13:28:53
    Author     : Rakibul Islam Jisan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@include file="../Connection.jsp" %>

<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = getConnection();
            String sql = "SELECT FULL_NAME, EMAIL FROM PROJECT.USERS WHERE EMAIL = ? AND PASSWORD = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("userName", rs.getString("FULL_NAME"));
                session.setAttribute("userEmail", rs.getString("EMAIL"));
                response.sendRedirect("UserDashboard.jsp");
                return;
            } else {
                message = "Invalid email or password!";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ex) {}
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40 flex items-center justify-center px-4 py-6">

        <div class="w-full max-w-md rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-8">

            <!-- Header -->
            <div class="mb-6 flex items-center gap-4">
                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-red-600/80 shadow-lg shadow-red-700/50 ring-1 ring-white/30">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 2.5s6 6.2 6 11a6 6 0 0 1-12 0c0-4.8 6-11 6-11z"/>
                    </svg>
                </div>
                <div>
                    <h2 class="text-2xl font-bold tracking-tight text-white">Login</h2>
                    <p class="text-sm text-white/70">Welcome back, sign in to continue</p>
                </div>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="mb-4 rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100 backdrop-blur-md">
                    <%= message %>
                </div>
            <% } %>

            <form action="UserLogin.jsp" method="post" class="space-y-4">

                <div>
                    <label class="mb-1 block text-sm font-medium text-white/90">Email</label>
                    <input type="email" name="email" required placeholder="you@example.com"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-white/90">Password</label>
                    <input type="password" name="password" required placeholder="••••••••"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                </div>

                <div class="pt-2">
                    <input type="submit" value="Login"
                           class="w-full cursor-pointer rounded-xl bg-gradient-to-r from-red-700 via-red-600 to-red-500 px-4 py-2.5 text-base font-semibold text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20 transition hover:scale-[1.02] hover:from-red-600 hover:to-red-400 hover:shadow-red-500/50 focus:outline-none focus:ring-2 focus:ring-red-300 active:scale-[0.98]">
                </div>
            </form>

            <p class="mt-5 text-center text-sm text-white/80">
                Don't have an account?
                <a href="UserRegistration.jsp" class="font-semibold text-red-300 underline-offset-4 transition hover:text-red-200 hover:underline">Register</a>
            </p>

        </div>
    </div>
</body>
</html>
