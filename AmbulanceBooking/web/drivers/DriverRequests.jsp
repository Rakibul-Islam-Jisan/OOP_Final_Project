<%-- 
    Document   : DriverRequests
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../Connection.jsp" %>

<%!
 
    private String routeUrl(String pickup, String destination) {
        try {
            return "https://www.google.com/maps/dir/?api=1"
                 + "&waypoints=" + java.net.URLEncoder.encode(pickup == null ? "" : pickup, "UTF-8")
                 + "&destination=" + java.net.URLEncoder.encode(destination == null ? "" : destination, "UTF-8")
                 + "&travelmode=driving";
        } catch (Exception e) {
            return "#";
        }
    }

    private String h(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }
%>

<%
 
    String driverEmail = (String) session.getAttribute("driverEmail");
    String driverName  = (String) session.getAttribute("driverName");
    if (driverEmail == null) {
        response.sendRedirect("DriverLogin.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String bookingId = request.getParameter("booking_id");
        String result = "fail";
        Connection c = null;
        PreparedStatement p = null;
        try {
            c = getConnection();

            String upd = "UPDATE PROJECT.AMBULANCE_BOOKINGS "
                       + "SET STATUS = 'ACCEPTED', DRIVER_NAME = ?, DRIVER_EMAIL = ? "
                       + "WHERE BOOKING_ID = ? AND STATUS = 'PENDING'";
            p = c.prepareStatement(upd);
            p.setString(1, driverName);
            p.setString(2, driverEmail);
            p.setString(3, bookingId);
            result = (p.executeUpdate() > 0) ? "ok" : "taken";
        } catch (Exception e) {
            result = "fail";
        } finally {
            try { if (p != null) p.close(); } catch (Exception ex) {}
            try { if (c != null) c.close(); } catch (Exception ex) {}
        }
        response.sendRedirect("DriverRequests.jsp?result=" + result);   
        return;
    }

    String result = request.getParameter("result");


    java.util.List<String[]> requests = new java.util.ArrayList<String[]>();
    String error = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = getConnection();
        String sql = "SELECT BOOKING_ID, PATIENT_NAME, PHONE, PICKUP_LOCATION, DESTINATION, AMBULANCE_TYPE, "
                   + "USER_EMAIL, STATUS, DRIVER_EMAIL, DRIVER_NAME "
                   + "FROM PROJECT.AMBULANCE_BOOKINGS ORDER BY BOOKING_ID DESC";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
            requests.add(new String[] {
                rs.getString("BOOKING_ID"),     
                rs.getString("PATIENT_NAME"),   
                rs.getString("PHONE"),          
                rs.getString("PICKUP_LOCATION"),
                rs.getString("DESTINATION"),    
                rs.getString("AMBULANCE_TYPE"), 
                rs.getString("USER_EMAIL"),     
                rs.getString("STATUS"),         
                rs.getString("DRIVER_EMAIL"),   
                rs.getString("DRIVER_NAME")     
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
    <title>All Requests</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="fixed inset-0 bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40"></div>

    <div class="relative min-h-screen">

        <% String activePage = "requests"; %>
        <%@ include file="DriverSidebar.jsp" %>

        <main class="flex min-h-screen items-start justify-center px-4 py-6 pl-24 md:pl-72 md:pr-8">
            <div class="w-full max-w-6xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-8 sm:py-7">

                <div class="mb-5 flex items-center justify-between gap-4">
                    <div>
                        <h2 class="text-2xl font-bold tracking-tight text-white">All Requests</h2>
                        <p class="text-sm text-white/70">Select the radio button to accept a request</p>
                    </div>
                    <span class="rounded-xl border border-white/25 bg-white/10 px-3 py-1.5 text-sm font-semibold text-white">
                        Total: <%= requests.size() %>
                    </span>
                </div>

                <% if ("ok".equals(result)) { %>
                    <div class="mb-4 rounded-xl border border-emerald-400/50 bg-emerald-500/20 px-4 py-2.5 text-center text-sm font-semibold text-emerald-100 backdrop-blur-md">
                        Request accepted. The user has been notified.
                    </div>
                <% } else if ("taken".equals(result)) { %>
                    <div class="mb-4 rounded-xl border border-amber-400/50 bg-amber-500/20 px-4 py-2.5 text-center text-sm font-semibold text-amber-100 backdrop-blur-md">
                        Another driver already accepted this request.
                    </div>
                <% } else if ("fail".equals(result)) { %>
                    <div class="mb-4 rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100 backdrop-blur-md">
                        Could not accept the request. Please try again.
                    </div>
                <% } %>

                <% if (!error.isEmpty()) { %>
                    <div class="mb-4 rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100 backdrop-blur-md">
                        <%= h(error) %>
                    </div>
                <% } %>

                <% if (requests.isEmpty() && error.isEmpty()) { %>
                    <div class="rounded-xl border border-white/20 bg-white/10 px-4 py-10 text-center text-white/80">
                        No ambulance requests yet.
                    </div>
                <% } else if (!requests.isEmpty()) { %>
                    <div class="overflow-x-auto rounded-2xl border border-white/20">
                        <table class="w-full min-w-[1050px] text-left text-sm text-white">
                            <thead class="bg-red-600/40 text-white">
                                <tr>
                                    <th class="px-4 py-3 font-semibold">ID</th>
                                    <th class="px-4 py-3 font-semibold">Patient</th>
                                    <th class="px-4 py-3 font-semibold">Phone</th>
                                    <th class="px-4 py-3 font-semibold">Pickup</th>
                                    <th class="px-4 py-3 font-semibold">Destination</th>
                                    <th class="px-4 py-3 font-semibold">Type</th>
                                    <th class="px-4 py-3 font-semibold">User Email</th>
                                    <th class="px-4 py-3 text-center font-semibold">Route</th>
                                    <th class="px-4 py-3 text-center font-semibold">Accept</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-white/10">
                                <% for (String[] r : requests) {
                                       boolean accepted = "ACCEPTED".equals(r[7]);
                                       boolean mine = accepted && driverEmail.equals(r[8]);
                                %>
                                    <tr class="bg-white/5 transition hover:bg-white/15">
                                        <td class="px-4 py-3 text-white/70">#<%= h(r[0]) %></td>
                                        <td class="px-4 py-3 font-medium"><%= h(r[1]) %></td>
                                        <td class="px-4 py-3"><%= h(r[2]) %></td>
                                        <td class="px-4 py-3"><%= h(r[3]) %></td>
                                        <td class="px-4 py-3"><%= h(r[4]) %></td>
                                        <td class="px-4 py-3">
                                            <span class="rounded-lg bg-red-500/30 px-2.5 py-1 text-xs font-semibold ring-1 ring-red-300/30"><%= h(r[5]) %></span>
                                        </td>
                                        <td class="px-4 py-3 text-white/80"><%= h(r[6]) %></td>
                                        <td class="px-4 py-3 text-center">
                                            <a href="<%= h(routeUrl(r[3], r[4])) %>" target="_blank" rel="noopener noreferrer"
                                               class="inline-flex items-center gap-1.5 whitespace-nowrap rounded-lg border border-white/25 bg-white/10 px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-white/20">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M12 21s-7-6.2-7-11a7 7 0 0 1 14 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/>
                                                </svg>
                                                View Route
                                            </a>
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <% if (!accepted) { %>
                                                <form action="DriverRequests.jsp" method="post" class="inline-flex items-center justify-center">
                                                    <input type="hidden" name="booking_id" value="<%= h(r[0]) %>">
                                                    <input type="radio" aria-label="Accept request <%= h(r[0]) %>"
                                                           class="h-5 w-5 cursor-pointer accent-red-500"
                                                           onchange="if (confirm('Accept this request?')) { this.form.submit(); } else { this.checked = false; }">
                                                </form>
                                            <% } else { %>
                                                <div class="inline-flex items-center gap-2">
                                                    <input type="radio" checked disabled class="h-5 w-5 accent-emerald-500">
                                                    <span class="text-xs font-semibold <%= mine ? "text-emerald-200" : "text-white/60" %>">
                                                        <%= mine ? "Accepted by you" : "Taken by " + h(r[9]) %>
                                                    </span>
                                                </div>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>

            </div>
        </main>
    </div>
</body>
</html>
