<%-- 
    Document   : DriverRegistration
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@include file="../Connection.jsp" %>

<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod()))
    {
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String driverLicense = request.getParameter("driver_license");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = getConnection();
            String sql = "INSERT INTO PROJECT.DRIVERS (FULL_NAME, EMAIL, PASSWORD, PHONE, DRIVER_LICENSE) VALUES (?,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, driverLicense);

            int rows = ps.executeUpdate();

            if (rows > 0)
            {
                message = "Registration Successful";
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 1) {
                message = "Database Error: This email is already registered";
            } else {
                message = "Database Error: " + e.getMessage();
            }
        } catch (Exception e) {
            message = "Database Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Driver Registration</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
          style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

        <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40 flex items-center justify-center px-4 py-6">

            <div class="w-full max-w-3xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-7">

                <div class="mb-5 flex items-center gap-4">
                    <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-red-600/80 shadow-lg shadow-red-700/50 ring-1 ring-white/30">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="9"/>
                            <circle cx="12" cy="12" r="2"/>
                            <path d="M12 3v7M12 14v7M3.5 9.5l7 1.5M13.5 13l7 1.5"/>
                        </svg>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold tracking-tight text-white">Driver Registration</h2>
                        <p class="text-sm text-white/70">Create your driver account to get started</p>
                    </div>
                </div>

                <% if (!message.isEmpty()) { %>
                    <div class="mb-4 rounded-xl border px-4 py-2.5 text-center text-sm font-semibold backdrop-blur-md
                         <%= message.startsWith("Database") 
                                ? "border-red-400/50 bg-red-500/20 text-red-100" 
                                : "border-emerald-400/50 bg-emerald-500/20 text-emerald-100" %>">
                        <%= message %>
                    </div>
                <% } %>


                <form action="DriverRegistration.jsp" method="post" class="grid grid-cols-1 gap-x-5 gap-y-4 md:grid-cols-2">

                    <div>
                        <label class="mb-1 block text-sm font-medium text-white/90">Full Name</label>
                        <input type="text" name="full_name" required placeholder="Enter Your Name"
                               class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                    </div>

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

                    <div>
                        <label class="mb-1 block text-sm font-medium text-white/90">Phone</label>
                        <input type="text" name="phone" required placeholder="01XXXXXXXXX"
                               class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                    </div>

                    <div class="md:col-span-2">
                        <label class="mb-1 block text-sm font-medium text-white/90">Driver License No.</label>
                        <input type="text" name="driver_license" required maxlength="50" placeholder="License number"
                               class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                    </div>

                    <div class="mt-2 flex justify-center md:col-span-2">
                        <input type="submit" value="Register"
                               class="w-full cursor-pointer rounded-xl bg-gradient-to-r from-red-700 via-red-600 to-red-500 px-4 py-2.5 text-base font-semibold text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20 transition hover:scale-[1.02] hover:from-red-600 hover:to-red-400 hover:shadow-red-500/50 focus:outline-none focus:ring-2 focus:ring-red-300 active:scale-[0.98] md:w-64">
                    </div>
                </form>

                <p class="mt-5 text-center text-sm text-white/80">
                    Already have an account?
                    <a href="DriverLogin.jsp" class="font-semibold text-red-300 underline-offset-4 transition hover:text-red-200 hover:underline">Login</a>
                </p>

            </div>
        </div>
    </body>
</html>
