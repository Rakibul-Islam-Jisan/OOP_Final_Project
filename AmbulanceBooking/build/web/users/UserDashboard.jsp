<%-- 
    Document   : UserDashboard
    Created on : 30 Sept 2026, 15:06:36
    Author     : Rakibul Islam Jisan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*"%>
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
    String ownerEmail  = (String) session.getAttribute("userEmail");
    String message     = "";
    String messageType = "ok";

    String flash = request.getParameter("msg");
    if ("deleted".equals(flash)) {
        message = "Booking deleted successfully.";
    } else if ("updated".equals(flash)) {
        message = "Booking updated successfully.";
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && "delete".equals(request.getParameter("action"))) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            con = getConnection();
            ps = con.prepareStatement("DELETE FROM PROJECT.AMBULANCE_BOOKINGS WHERE BOOKING_ID = ? AND USER_EMAIL = ?");
            ps.setInt(1, id);
            ps.setString(2, ownerEmail);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("UserDashboard.jsp?msg=deleted");
                return;
            } else {
                message = "Booking not found.";
                messageType = "err";
            }
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
            messageType = "err";
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }

    
    List<String[]> bookings = new ArrayList<String[]>();
    {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = getConnection();
            ps = con.prepareStatement(
                "SELECT BOOKING_ID, AMBULANCE_TYPE, PHONE, PICKUP_LOCATION, DESTINATION "
              + "FROM PROJECT.AMBULANCE_BOOKINGS WHERE USER_EMAIL = ? ORDER BY BOOKING_ID DESC");
            ps.setString(1, ownerEmail);
            rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(new String[] {
                    rs.getString("BOOKING_ID"),
                    rs.getString("AMBULANCE_TYPE"),
                    rs.getString("PHONE"),
                    rs.getString("PICKUP_LOCATION"),
                    rs.getString("DESTINATION")
                });
            }
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
            messageType = "err";
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Dashboard</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
          style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

        <!-- Dark red tint over the background -->
        <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40">

            <% String activePage = "home"; %>
            <%@ include file="Sidebar.jsp" %>

            <main class="min-h-screen py-6 pl-24 pr-4 md:pl-72 md:pr-8">
                <div class="mx-auto w-full max-w-5xl space-y-6">

                    <!-- TOP: Welcome -->
                    <div class="rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:p-8">
                        <h1 class="text-3xl font-bold tracking-tight text-white">
                            Welcome, <%= esc((String) session.getAttribute("userName")) %>
                        </h1>
                        <p class="mt-2 text-white/70">Use the menu on the left to book an ambulance or view your profile.</p>
                    </div>

                    <% if (!message.isEmpty()) { %>
                        <div class="rounded-xl border px-4 py-2.5 text-center text-sm font-semibold backdrop-blur-md
                             <%= "ok".equals(messageType)
                                    ? "border-emerald-400/50 bg-emerald-500/20 text-emerald-100"
                                    : "border-red-400/50 bg-red-500/20 text-red-100" %>">
                            <%= esc(message) %>
                        </div>
                    <% } %>

                    <div class="rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:p-8">

                        <div class="mb-4 flex items-center justify-between">
                            <h2 class="text-xl font-bold text-white">My Ambulance Requests</h2>
                            <a href="UserAmbulanceBook.jsp"
                               class="rounded-lg bg-red-600/80 px-3 py-1.5 text-sm font-semibold text-white ring-1 ring-white/20 transition hover:bg-red-500">
                                + New Booking
                            </a>
                        </div>

                        <% if (bookings.isEmpty()) { %>
                            <p class="rounded-xl border border-white/15 bg-white/5 px-4 py-6 text-center text-sm text-white/70">
                                You have no ambulance requests yet.
                            </p>
                        <% } else { %>
                            <div class="overflow-x-auto">
                                <table class="w-full min-w-[700px] text-left text-sm text-white">
                                    <thead>
                                        <tr class="border-b border-white/20 text-white/70">
                                            <th class="px-3 py-2 font-semibold">No</th>
                                            <th class="px-3 py-2 font-semibold">Ambulance Type</th>
                                            <th class="px-3 py-2 font-semibold">Phone</th>
                                            <th class="px-3 py-2 font-semibold">Pickup Location</th>
                                            <th class="px-3 py-2 font-semibold">Destination</th>
                                            <th class="px-3 py-2 text-center font-semibold">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-white/10">
                                        <% for (int i = 0; i < bookings.size(); i++) {
                                               String[] b = bookings.get(i); %>
                                            <tr class="transition hover:bg-white/5">
                                                <td class="px-3 py-3"><%= i + 1 %></td>
                                                <td class="px-3 py-3"><%= esc(b[1]) %></td>
                                                <td class="px-3 py-3"><%= esc(b[2]) %></td>
                                                <td class="px-3 py-3"><%= esc(b[3]) %></td>
                                                <td class="px-3 py-3"><%= esc(b[4]) %></td>
                                                <td class="px-3 py-3">
                                                    <div class="flex items-center justify-center gap-2">
                                                        <a href="UserEditBooking.jsp?id=<%= esc(b[0]) %>"
                                                           class="rounded-lg bg-sky-600/80 px-3 py-1 text-xs font-semibold text-white ring-1 ring-white/20 transition hover:bg-sky-500">
                                                            Update
                                                        </a>
                                                        <form action="UserDashboard.jsp" method="post"
                                                              onsubmit="return confirm('Are you sure you want to delete this booking?');">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="<%= esc(b[0]) %>">
                                                            <button type="submit"
                                                                    class="rounded-lg bg-red-600/80 px-3 py-1 text-xs font-semibold text-white ring-1 ring-white/20 transition hover:bg-red-500">
                                                                Delete
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>

                    </div>
                </div>
            </main>

        </div>
    </body>
</html>
