<%-- 
    Document   : UserProfile
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../Connection.jsp" %>

<%!
    public String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>

<%

    if (session.getAttribute("userEmail") == null) {
        response.sendRedirect("UserLogin.jsp");
        return;
    }
    String ownerEmail = (String) session.getAttribute("userEmail");

    String message = "";
    String pFullName = "", pEmail = "", pPhone = "", pBloodGroup = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = getConnection();
        ps = con.prepareStatement(
            "SELECT FULL_NAME, EMAIL, PHONE, BLOOD_GROUP FROM PROJECT.USERS WHERE EMAIL = ?");
        ps.setString(1, ownerEmail);
        rs = ps.executeQuery();
        if (rs.next()) {
            pFullName   = rs.getString("FULL_NAME");
            pEmail      = rs.getString("EMAIL");
            pPhone      = rs.getString("PHONE");
            pBloodGroup = rs.getString("BLOOD_GROUP");
        } else {
            message = "Profile not found.";
        }
    } catch (Exception e) {
        message = "Database error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ex) {}
        try { if (ps != null) ps.close(); } catch (Exception ex) {}
        try { if (con != null) con.close(); } catch (Exception ex) {}
    }

    String initial = (pFullName != null && pFullName.trim().length() > 0)
            ? pFullName.trim().substring(0, 1).toUpperCase() : "?";
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>My Profile</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
          style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

        <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40">

            <% String activePage = "profile"; %>
            <%@ include file="Sidebar.jsp" %>

            <main class="flex min-h-screen items-center justify-center py-6 pl-24 pr-4 md:pl-72 md:pr-8">
                <div class="w-full max-w-2xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:p-8">

                    <div class="mb-6 flex items-center gap-4">
                        <div class="flex h-16 w-16 shrink-0 items-center justify-center rounded-full bg-red-600/80 text-2xl font-bold text-white shadow-lg shadow-red-700/50 ring-1 ring-white/30">
                            <%= esc(initial) %>
                        </div>
                        <div>
                            <h1 class="text-2xl font-bold tracking-tight text-white"><%= esc(pFullName) %></h1>
                            <p class="text-sm text-white/70">My Profile</p>
                        </div>
                    </div>

                    <% if (!message.isEmpty()) { %>
                        <div class="mb-4 rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100 backdrop-blur-md">
                            <%= esc(message) %>
                        </div>
                    <% } %>

                    <div class="grid grid-cols-1 gap-4 md:grid-cols-2">

                        <div class="rounded-xl border border-white/15 bg-white/5 px-4 py-3">
                            <p class="text-xs font-medium uppercase tracking-wide text-white/60">Full Name</p>
                            <p class="mt-1 text-base font-semibold text-white"><%= esc(pFullName) %></p>
                        </div>

                        <div class="rounded-xl border border-white/15 bg-white/5 px-4 py-3">
                            <p class="text-xs font-medium uppercase tracking-wide text-white/60">Email</p>
                            <p class="mt-1 break-all text-base font-semibold text-white"><%= esc(pEmail) %></p>
                        </div>

                        <div class="rounded-xl border border-white/15 bg-white/5 px-4 py-3">
                            <p class="text-xs font-medium uppercase tracking-wide text-white/60">Phone</p>
                            <p class="mt-1 text-base font-semibold text-white"><%= esc(pPhone) %></p>
                        </div>

                        <div class="rounded-xl border border-white/15 bg-white/5 px-4 py-3">
                            <p class="text-xs font-medium uppercase tracking-wide text-white/60">Blood Group</p>
                            <p class="mt-1 text-base font-semibold text-white"><%= esc(pBloodGroup) %></p>
                        </div>

                    </div>

                    <div class="mt-6 flex flex-wrap items-center justify-end gap-3">
                        <a href="UserDashboard.jsp"
                           class="rounded-xl border border-white/25 bg-white/10 px-4 py-2 text-sm font-semibold text-white transition hover:bg-white/20">
                            Back to Dashboard
                        </a>
                        <a href="logout.jsp"
                           class="rounded-xl bg-red-600/80 px-4 py-2 text-sm font-semibold text-white ring-1 ring-white/20 transition hover:bg-red-500">
                            Logout
                        </a>
                    </div>

                </div>
            </main>

        </div>
    </body>
</html>
