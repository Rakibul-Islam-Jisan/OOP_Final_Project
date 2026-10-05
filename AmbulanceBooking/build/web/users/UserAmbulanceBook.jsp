<%-- 
    Document   : UserAmbulanceBook
    Created on : 30 Sept 2026, 15:12:31
    Author     : Rakibul Islam Jisan
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../Connection.jsp" %>

<%
  
    if (session.getAttribute("userEmail") == null) {
        response.sendRedirect("UserLogin.jsp");
        return;
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String patientName    = request.getParameter("patient_name");
        String phone          = request.getParameter("phone");
        String pickupLocation = request.getParameter("pickup_location");
        String destination    = request.getParameter("destination");
        String ambulanceType  = request.getParameter("ambulance_type");

        Connection con = null;
        PreparedStatement ps = null;

        try {

            con = getConnection();

            String sql = "INSERT INTO PROJECT.AMBULANCE_BOOKINGS "
                       + "(BOOKING_ID, PATIENT_NAME, PHONE, PICKUP_LOCATION, DESTINATION, AMBULANCE_TYPE, USER_EMAIL) "
                       + "VALUES (PROJECT.BOOKING_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);

            ps.setString(1, patientName);
            ps.setString(2, phone);
            ps.setString(3, pickupLocation);
            ps.setString(4, destination);
            ps.setString(5, ambulanceType);
            ps.setString(6, (String) session.getAttribute("userEmail"));

            int rows = ps.executeUpdate();

            if (rows > 0) {
                message = "Ambulance booking successful!";
            }

        } catch (Exception e) {

            message = "Database error: " + e.getMessage();

        } finally {

            try {
                if (ps != null) ps.close();
            } catch (Exception ex) {}

            try {
                if (con != null) con.close();
            } catch (Exception ex) {}
        }
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Ambulance Booking</title>

    <script src="https://cdn.tailwindcss.com"></script>

</head>


<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">


    <div class="min-h-screen bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40 flex items-center justify-center py-6 pl-24 pr-4 md:pl-72 md:pr-8">


        <% String activePage = "book"; %>
        <%@ include file="Sidebar.jsp" %>

        <div class="w-full max-w-3xl rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-7">

            <div class="mb-5 flex items-center gap-4">

                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-red-600/80 shadow-lg shadow-red-700/50 ring-1 ring-white/30">

                    <svg xmlns="http://www.w3.org/2000/svg"
                         class="h-6 w-6 text-white"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         stroke-linecap="round"
                         stroke-linejoin="round">

                        <path d="M12 5v14"/>
                        <path d="M5 12h14"/>

                    </svg>

                </div>

                <div>

                    <h2 class="text-2xl font-bold tracking-tight text-white">
                        Ambulance Booking
                    </h2>

                    <p class="text-sm text-white/70">
                        Fill in the details to book an ambulance
                    </p>

                </div>

            </div>

            <div class="mb-5 flex items-center justify-between rounded-xl border border-white/20 bg-white/10 px-4 py-2.5 text-sm backdrop-blur-md">


                <span class="text-white/80">

                    Welcome,

                    <span class="font-semibold text-white">
                        <%= session.getAttribute("userName") %>
                    </span>

                </span>


                <a href="logout.jsp"
                   class="rounded-lg bg-red-600/80 px-3 py-1 font-semibold text-white ring-1 ring-white/20 transition hover:bg-red-500">

                    Logout

                </a>


            </div>

            <% if (!message.isEmpty()) { %>

                <div class="mb-4 rounded-xl border px-4 py-2.5 text-center text-sm font-semibold backdrop-blur-md
                     <%= message.startsWith("Ambulance") 
                            ? "border-emerald-400/50 bg-emerald-500/20 text-emerald-100" 
                            : "border-red-400/50 bg-red-500/20 text-red-100" %>">

                    <%= message %>

                </div>

            <% } %>



            <div class="mb-5 rounded-xl border border-white/20 bg-white/10 px-4 py-3 backdrop-blur-md">


                <!-- Fare Header -->
                <div class="mb-2 flex items-center gap-2">

                    <div class="flex h-7 w-7 items-center justify-center rounded-lg bg-red-600/70 ring-1 ring-white/20">

                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="h-4 w-4 text-white"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="2"
                             stroke-linecap="round"
                             stroke-linejoin="round">

                            <circle cx="12" cy="12" r="9"/>

                            <path d="M12 7v10"/>

                            <path d="M9.5 9.5c0-1 1-1.5 2.5-1.5s2.5.5 2.5 1.5-1 1.5-2.5 2-2.5 1-2.5 2 1 1.5 2.5 1.5 2.5-.5 2.5-1.5"/>

                        </svg>

                    </div>

                    <div>

                        <p class="text-sm font-semibold text-white">
                            Ambulance Fare
                        </p>

                        <p class="text-xs text-white/60">
                            Fare according to ambulance type
                        </p>

                    </div>


                </div>


                <div class="grid grid-cols-2 gap-2 sm:grid-cols-5">

                    <div class="rounded-lg border border-white/10 bg-black/10 px-2 py-2 text-center">

                        <p class="text-xs text-white/60">
                            Basic
                        </p>

                        <p class="text-sm font-bold text-white">
                            TK 4,000
                        </p>

                        <p class="text-[10px] text-white/50">
                            per hour
                        </p>

                    </div>

                    <div class="rounded-lg border border-white/10 bg-black/10 px-2 py-2 text-center">

                        <p class="text-xs text-white/60">
                            ICU
                        </p>

                        <p class="text-sm font-bold text-white">
                            TK 6,500
                        </p>

                        <p class="text-[10px] text-white/50">
                            per hour
                        </p>

                    </div>

                    <div class="rounded-lg border border-white/10 bg-black/10 px-2 py-2 text-center">

                        <p class="text-xs text-white/60">
                            AC
                        </p>

                        <p class="text-sm font-bold text-white">
                            TK 4,900
                        </p>

                        <p class="text-[10px] text-white/50">
                            per hour
                        </p>

                    </div>



                    <!-- Non-AC -->
                    <div class="rounded-lg border border-white/10 bg-black/10 px-2 py-2 text-center">

                        <p class="text-xs text-white/60">
                            Non-AC
                        </p>

                        <p class="text-sm font-bold text-white">
                            TK 2,000
                        </p>

                        <p class="text-[10px] text-white/50">
                            per hour
                        </p>

                    </div>

                    <div class="rounded-lg border border-white/10 bg-black/10 px-2 py-2 text-center">

                        <p class="text-xs text-white/60">Freezer</p>

                        <p class="text-sm font-bold text-white">TK 10,000</p>

                        <p class="text-[10px] text-white/50">per hour</p>

                    </div>


                </div>

            </div>

            <form action="UserAmbulanceBook.jsp"
                  method="post"
                  class="grid grid-cols-1 gap-x-5 gap-y-4 md:grid-cols-2">



                <!-- Patient Name -->
                <div>

                    <label class="mb-1 block text-sm font-medium text-white/90">
                        Patient Name
                    </label>

                    <input type="text"
                           name="patient_name"
                           required
                           placeholder="Patient full name"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">

                </div>

                <div>

                    <label class="mb-1 block text-sm font-medium text-white/90">
                        Phone
                    </label>

                    <input type="text"
                           name="phone"
                           required
                           placeholder="01XXXXXXXXX"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">

                </div>

                <div>

                    <label class="mb-1 block text-sm font-medium text-white/90">
                        Pickup Location
                    </label>

                    <input type="text"
                           name="pickup_location"
                           required
                           placeholder="Where to pick up"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">

                </div>

                <div>

                    <label class="mb-1 block text-sm font-medium text-white/90">
                        Destination
                    </label>

                    <input type="text"
                           name="destination"
                           required
                           placeholder="Hospital / destination"
                           class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white placeholder-white/50 outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">

                </div>

                <div class="md:col-span-2">

                    <label class="mb-1 block text-sm font-medium text-white/90">
                        Ambulance Type
                    </label>


                    <select name="ambulance_type"
                            required
                            class="w-full rounded-xl border border-white/25 bg-white/10 px-4 py-2.5 text-white outline-none transition focus:border-red-400 focus:bg-white/15 focus:ring-2 focus:ring-red-500/60">


                        <option value=""
                                class="text-gray-900">
                        </option>
                        <option value="Basic"
                                class="text-gray-900">

                            Basic - TK 4,000 per hour

                        </option>
                        <option value="ICU"
                                class="text-gray-900">

                            ICU - TK 6,500 per hour
                        </option>
                        <option value="AC"
                                class="text-gray-900">

                            AC - TK 4,900 per hour
                        </option>
                        <option value="Non-AC"
                                class="text-gray-900">

                            Non-AC - TK 2,000 per hour
                        </option>
                        <option value="Freezer"
                                class="text-gray-900">

                            Freezer - TK 10,000 per hour
                        </option>
                    </select>

                </div>


                <div class="mt-2 flex justify-center md:col-span-2">

                    <input type="submit"
                           value="Book Ambulance"
                           class="w-full cursor-pointer rounded-xl bg-gradient-to-r from-red-700 via-red-600 to-red-500 px-4 py-2.5 text-base font-semibold text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20 transition hover:scale-[1.02] hover:from-red-600 hover:to-red-400 hover:shadow-red-500/50 focus:outline-none focus:ring-2 focus:ring-red-300 active:scale-[0.98] md:w-64">

                </div>


            </form>


        </div>

    </div>

</body>

</html>
