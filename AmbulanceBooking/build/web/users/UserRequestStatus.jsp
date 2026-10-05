<%-- 
    Document   : UserRequestStatus
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
%>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("UserLogin.jsp");
        return;
    }

    java.util.List<String[]> list = new java.util.ArrayList<String[]>();
    String error = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = getConnection();
        String sql = "SELECT BOOKING_ID, PATIENT_NAME, PICKUP_LOCATION, DESTINATION, AMBULANCE_TYPE, "
                   + "STATUS, DRIVER_NAME, DRIVER_EMAIL "
                   + "FROM PROJECT.AMBULANCE_BOOKINGS WHERE USER_EMAIL = ? ORDER BY BOOKING_ID DESC";
        ps = con.prepareStatement(sql);
        ps.setString(1, userEmail);
        rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new String[] {
                rs.getString("BOOKING_ID"),      
                rs.getString("PATIENT_NAME"),    
                rs.getString("PICKUP_LOCATION"), 
                rs.getString("DESTINATION"),     
                rs.getString("AMBULANCE_TYPE"),  
                rs.getString("STATUS"),          
                rs.getString("DRIVER_NAME"),     
                rs.getString("DRIVER_EMAIL")     
            });
        }
    } catch (Exception e) {
        error = "Database error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ex) {}
        try { if (ps != null) ps.close(); } catch (Exception ex) {}
        try { if (con != null) con.close(); } catch (Exception ex) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Requests</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40 flex items-start justify-center py-6 pl-24 pr-4 md:pl-72 md:pr-8">

        <% String activePage = "status"; %>
        <%@ include file="Sidebar.jsp" %>

        <div class="w-full max-w-3xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-7">

            <div class="mb-5">
                <h2 class="text-2xl font-bold tracking-tight text-white">My Requests</h2>
                <p class="text-sm text-white/70">Track your ambulance requests</p>
            </div>

            <% if (!error.isEmpty()) { %>
                <div class="mb-4 rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100">
                    <%= h(error) %>
                </div>
            <% } %>

            <% if (list.isEmpty() && error.isEmpty()) { %>
                <div class="rounded-xl border border-white/20 bg-white/10 px-4 py-10 text-center text-white/80">
                    You have not made any request yet.
                </div>
            <% } %>

            <div class="space-y-4">
                <% for (String[] r : list) {
                       boolean accepted = "ACCEPTED".equals(r[5]);
                %>
                    <div class="rounded-2xl border border-white/20 bg-white/10 p-4 backdrop-blur-md">
                        <div class="flex flex-wrap items-center justify-between gap-2">
                            <p class="font-semibold text-white">#<%= h(r[0]) %> &middot; <%= h(r[1]) %></p>
                            <span class="rounded-lg px-2.5 py-1 text-xs font-semibold ring-1
                                  <%= accepted ? "bg-emerald-500/30 text-emerald-100 ring-emerald-300/30"
                                               : "bg-amber-500/30 text-amber-100 ring-amber-300/30" %>">
                                <%= accepted ? "Accepted" : "Pending" %>
                            </span>
                        </div>

                        <p class="mt-2 text-sm text-white/80">
                            <%= h(r[2]) %> to <%= h(r[3]) %> (<%= h(r[4]) %> ambulance)
                        </p>

                        <% if (accepted) { %>
                            <div class="mt-3 rounded-xl border border-emerald-400/50 bg-emerald-500/20 px-4 py-2.5 text-sm font-semibold text-emerald-100">
                                Your request has been accepted by driver <%= h(r[6]) %> (<%= h(r[7]) %>). The ambulance is on its way.
                            </div>
                        <% } else { %>
                            <div class="mt-3 rounded-xl border border-white/20 bg-white/10 px-4 py-2.5 text-sm text-white/70">
                                Waiting for a driver to accept your request.
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</body>
</html>
