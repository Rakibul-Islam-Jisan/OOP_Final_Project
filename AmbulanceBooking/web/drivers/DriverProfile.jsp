<%-- 
    Document   : DriverProfile
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../Connection.jsp" %>

<%!
    private String h(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }

  
    private String pretty(String col) {
        String[] parts = col.toLowerCase().split("_");
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p.isEmpty()) continue;
            if (sb.length() > 0) sb.append(' ');
            sb.append(Character.toUpperCase(p.charAt(0))).append(p.substring(1));
        }
        return sb.toString();
    }
%>

<%
    
    String driverEmail = (String) session.getAttribute("driverEmail");
    if (driverEmail == null) {
        response.sendRedirect("DriverLogin.jsp");
        return;
    }

  
    java.util.List<String[]> fields = new java.util.ArrayList<String[]>();
    String fullName = (String) session.getAttribute("driverName");
    String error = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = getConnection();
        ps = con.prepareStatement("SELECT * FROM PROJECT.DRIVERS WHERE EMAIL = ?");
        ps.setString(1, driverEmail);
        rs = ps.executeQuery();

        if (rs.next()) {
            ResultSetMetaData md = rs.getMetaData();
            for (int i = 1; i <= md.getColumnCount(); i++) {
                String col = md.getColumnName(i);
                if (col.equalsIgnoreCase("PASSWORD")) continue;   
                String val = rs.getString(i);
                if (col.equalsIgnoreCase("FULL_NAME") && val != null) fullName = val;
                fields.add(new String[] { pretty(col), (val == null || val.trim().isEmpty()) ? "-" : val });
            }
        } else {
            error = "Driver profile not found.";
        }
    } catch (Exception e) {
        error = "Database error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ex) {}
        try { if (ps != null) ps.close(); } catch (Exception ex) {}
        try { if (con != null) con.close(); } catch (Exception ex) {}
    }

    String initial = (fullName != null && !fullName.trim().isEmpty())
            ? fullName.trim().substring(0, 1).toUpperCase() : "D";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Driver Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="fixed inset-0 bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40"></div>

    <div class="relative min-h-screen">

        <% String activePage = "profile"; %>
        <%@ include file="DriverSidebar.jsp" %>

        <main class="flex min-h-screen items-center justify-center px-4 py-6 pl-24 md:pl-72 md:pr-8">
            <div class="w-full max-w-2xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-8">

                <div class="mb-6 flex flex-col items-center text-center">
                    <div class="flex h-20 w-20 items-center justify-center rounded-full bg-red-600/80 text-3xl font-bold text-white shadow-lg shadow-red-700/50 ring-2 ring-white/30">
                        <%= h(initial) %>
                    </div>
                    <h2 class="mt-3 break-words text-2xl font-bold tracking-tight text-white sm:text-3xl"><%= h(fullName) %></h2>
                    <p class="text-sm text-white/70"><%= h(driverEmail) %></p>
                </div>

                <% if (!error.isEmpty()) { %>
                    <div class="rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100 backdrop-blur-md">
                        <%= h(error) %>
                    </div>
                <% } else { %>

                    <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
                        <% for (String[] f : fields) { %>
                            <div class="rounded-xl border border-white/20 bg-white/10 px-4 py-3 backdrop-blur-md">
                                <p class="text-xs font-medium text-white/60"><%= h(f[0]) %></p>
                                <p class="mt-0.5 break-words text-sm font-semibold text-white"><%= h(f[1]) %></p>
                            </div>
                        <% } %>
                    </div>
                <% } %>

            </div>
        </main>
    </div>
</body>
</html>
