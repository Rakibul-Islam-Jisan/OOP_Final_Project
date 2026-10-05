<%-- 
    Document   : DriverDashboard
    Created on : 5 Oct 2026
    Author     : Rakibul Islam Jisan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
    if ("logout".equals(request.getParameter("action"))) {
        session.removeAttribute("driverName");
        session.removeAttribute("driverEmail");
        response.sendRedirect("DriverLogin.jsp");
        return;
    }

    String driverName  = (String) session.getAttribute("driverName");
    String driverEmail = (String) session.getAttribute("driverEmail");
    if (driverName == null || driverEmail == null) {
        response.sendRedirect("DriverLogin.jsp");
        return;
    }

    String safeName = driverName.replace("&", "&amp;").replace("<", "&lt;")
                                .replace(">", "&gt;").replace("\"", "&quot;");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Driver Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-cover bg-center bg-fixed bg-no-repeat font-sans antialiased"
      style="background-image: url('<%= request.getContextPath() %>/images/bg.jpg');">

    <div class="fixed inset-0 bg-gradient-to-br from-black/50 via-red-950/30 to-red-900/40"></div>

    <div class="relative min-h-screen">

        <% String activePage = "home"; %>
        <%@ include file="DriverSidebar.jsp" %>

        <main class="flex min-h-screen items-center justify-center px-4 py-6 pl-24 md:pl-72 md:pr-8">
            <div class="w-full max-w-2xl rounded-3xl border border-white/20 bg-white/10 px-6 py-12 text-center shadow-2xl shadow-red-950/50 backdrop-blur-xl sm:px-12 sm:py-16">
                <p class="text-lg font-medium text-white/70 sm:text-xl">Welcome</p>
                <h1 class="mt-3 break-words text-4xl font-bold tracking-tight text-white sm:text-6xl">
                    <%= safeName %>
                </h1>
                <p class="mt-4 text-sm text-white/60"><%= driverEmail %></p>
            </div>
        </main>

    </div>
</body>
</html>
