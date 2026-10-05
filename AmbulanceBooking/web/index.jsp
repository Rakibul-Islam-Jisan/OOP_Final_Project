<%-- 
    Document   : index
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
   
    final String USER_LOGIN = "users/UserLogin.jsp";
    final String USER_HOME = "users/UserAmbulanceBook.jsp";
    final String DRIVER_LOGIN = "drivers/DriverLogin.jsp";
    final String DRIVER_HOME = "drivers/DriverDashboard.jsp";

    boolean userLoggedIn = session.getAttribute("userEmail") != null;
    boolean driverLoggedIn = session.getAttribute("driverEmail") != null;

    String userLink = userLoggedIn ? USER_HOME   : USER_LOGIN;
    String driverLink = driverLoggedIn ? DRIVER_HOME : DRIVER_LOGIN;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AmbulanceExpress</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="min-h-screen bg-gradient-to-br from-black/60 via-red-950/40 to-red-900/50">
        <div class="mx-auto flex min-h-screen max-w-7xl flex-col items-center justify-center gap-10 px-6 py-10 lg:flex-row lg:justify-between lg:gap-16 lg:px-12">

            <!-- Left: brand -->
            <section class="w-full text-center lg:w-3/5 lg:text-left">
                <div class="mb-6 inline-flex h-16 w-16 items-center justify-center rounded-3xl bg-red-600/80 shadow-lg shadow-red-700/50 ring-1 ring-white/30">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-9 w-9 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 5v14M5 12h14"/>
                    </svg>
                </div>

                <h1 class="text-5xl font-extrabold leading-[1.05] tracking-tight text-white drop-shadow-lg sm:text-7xl xl:text-8xl">
                    Ambulance<br>Express
                </h1>

                <p class="mx-auto mt-6 max-w-md text-lg text-white/80 lg:mx-0">
                    Book an ambulance in seconds. Drivers get your request instantly and head your way.
                </p>
            </section>

            <!-- Right: role select -->
            <section class="w-full max-w-md lg:w-2/5">
                <div class="rounded-3xl border border-white/20 bg-white/10 p-6 shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-10 sm:py-10">

                    <h2 class="text-2xl font-bold tracking-tight text-white">Continue as</h2>
                    <p class="mt-1 text-sm text-white/70">Choose your role to get started</p>

                    <div class="mt-6 space-y-4">

                        <!-- User -->
                        <a href="<%= userLink %>"
                           class="group flex items-center gap-4 rounded-2xl bg-gradient-to-r from-red-700 via-red-600 to-red-500 px-5 py-4 text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20 transition hover:scale-[1.02] hover:from-red-600 hover:to-red-400 hover:shadow-red-500/50 focus:outline-none focus:ring-2 focus:ring-red-300 active:scale-[0.98]">
                            <span class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-white/20 ring-1 ring-white/30">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/>
                                </svg>
                            </span>
                            <span>
                                <span class="block text-lg font-semibold">User</span>
                                <span class="block text-xs text-white/80"><%= userLoggedIn ? "Go to your dashboard" : "Login to book an ambulance" %></span>
                            </span>
                        </a>

                        <!-- Driver -->
                        <a href="<%= driverLink %>"
                           class="group flex items-center gap-4 rounded-2xl border border-white/25 bg-white/10 px-5 py-4 text-white backdrop-blur-md transition hover:scale-[1.02] hover:bg-white/20 focus:outline-none focus:ring-2 focus:ring-red-300 active:scale-[0.98]">
                            <span class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-red-600/60 ring-1 ring-white/30">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="2"/>
                                    <path d="M12 3v7M12 14v7M3.5 9.5l7 1.5M13.5 13l7 1.5"/>
                                </svg>
                            </span>
                            <span>
                                <span class="block text-lg font-semibold">Driver</span>
                                <span class="block text-xs text-white/70"><%= driverLoggedIn ? "Go to your dashboard" : "Login to see ambulance requests" %></span>
                            </span>
                        </a>

                    </div>
                </div>
            </section>

        </div>
    </div>
</body>
</html>
