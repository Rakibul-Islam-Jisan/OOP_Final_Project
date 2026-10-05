<%-- 
    Document   : UserEditBooking
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../Connection.jsp" %>

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

 
    int bookingId = -1;
    try {
        bookingId = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("UserDashboard.jsp");
        return;
    }

    String message = "";
    String patientName = "", phone = "", pickupLocation = "", destination = "", ambulanceType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        patientName    = request.getParameter("patient_name");
        phone          = request.getParameter("phone");
        pickupLocation = request.getParameter("pickup_location");
        destination    = request.getParameter("destination");
        ambulanceType  = request.getParameter("ambulance_type");

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = getConnection();
            ps = con.prepareStatement(
                "UPDATE PROJECT.AMBULANCE_BOOKINGS "
              + "SET PATIENT_NAME = ?, PHONE = ?, PICKUP_LOCATION = ?, DESTINATION = ?, AMBULANCE_TYPE = ? "
              + "WHERE BOOKING_ID = ? AND USER_EMAIL = ?");
            ps.setString(1, patientName);
            ps.setString(2, phone);
            ps.setString(3, pickupLocation);
            ps.setString(4, destination);
            ps.setString(5, ambulanceType);
            ps.setInt(6, bookingId);
            ps.setString(7, ownerEmail);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("UserDashboard.jsp?msg=updated");
                return;
            } else {
                message = "Booking not found.";
            }
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    } else {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = getConnection();
            ps = con.prepareStatement(
                "SELECT PATIENT_NAME, PHONE, PICKUP_LOCATION, DESTINATION, AMBULANCE_TYPE "
              + "FROM PROJECT.AMBULANCE_BOOKINGS WHERE BOOKING_ID = ? AND USER_EMAIL = ?");
            ps.setInt(1, bookingId);
            ps.setString(2, ownerEmail);
            rs = ps.executeQuery();
            if (rs.next()) {
                patientName    = rs.getString("PATIENT_NAME");
                phone          = rs.getString("PHONE");
                pickupLocation = rs.getString("PICKUP_LOCATION");
                destination    = rs.getString("DESTINATION");
                ambulanceType  = rs.getString("AMBULANCE_TYPE");
            } else {
       
                response.sendRedirect("UserDashboard.jsp");
                return;
            }
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ex) {}
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }

    String[] types = {"Basic", "ICU", "AC", "Non-AC", "Freezer"};
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Update Booking</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40 flex items-center justify-center py-6 pl-24 pr-4 md:pl-72 md:pr-8">

        <% String activePage = "home"; %>
        <%@ include file="Sidebar.jsp" %>

        <div class="w-full max-w-3xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-7">

            <div class="mb-5 flex items-center gap-4">
                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-sky-600/80 shadow-lg shadow-sky-700/50 ring-1 ring-white/30">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/>
                    </svg>
                </div>
                <div>
                    <h2 class="text-2xl font-bold tracking-tight text-white">Update Booking</h2>
                    <p class="text-sm text-white/70">Edit the details and save your changes</p>
                </div>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="mb-4 rounded-xl border border-red-400/50 bg-red-500/20 px-4 py-2.5 text-center text-sm font-semibold text-red-100 backdrop-blur-md">
                    <%= esc(message) %>
                </div>
            <% } %>

            <form action="UserEditBooking.jsp?id=<%= bookingId %>" method="post" class="grid grid-cols-1 gap-x-5 gap-y-4 md:grid-cols-2">

                <div>
                    <label class="mb-1 block text-sm font-medium text-white/90">Patient Name</label>
                    <input type="text" name="patient_name" required value="<%= esc(patientName) %>"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-white/90">Phone</label>
                    <input type="text" name="phone" required value="<%= esc(phone) %>"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-white/90">Pickup Location</label>
                    <input type="text" name="pickup_location" required value="<%= esc(pickupLocation) %>"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-white/90">Destination</label>
                    <input type="text" name="destination" required value="<%= esc(destination) %>"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                </div>

                <div class="md:col-span-2">
                    <label class="mb-1 block text-sm font-medium text-white/90">Ambulance Type</label>
                    <select name="ambulance_type" required
                            class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">
                        <% for (String t : types) { %>
                            <option class="text-gray-900" <%= t.equals(ambulanceType) ? "selected" : "" %>><%= t %></option>
                        <% } %>
                    </select>
                </div>

                <div class="mt-2 flex flex-col items-center justify-center gap-3 md:col-span-2 md:flex-row">
                    <input type="submit" value="Save Changes"
                           class="w-full cursor-pointer rounded-xl bg-gradient-to-r from-red-700 via-red-600 to-red-500 px-4 py-2.5 text-base font-semibold text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20 transition hover:scale-[1.02] hover:from-red-600 hover:to-red-400 focus:outline-none focus:ring-2 focus:ring-red-300 active:scale-[0.98] md:w-64">
                    <a href="UserDashboard.jsp"
                       class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-center text-base font-semibold text-white transition hover:bg-white/20 md:w-40">
                        Cancel
                    </a>
                </div>
            </form>

        </div>
    </div>
</body>
</html>
