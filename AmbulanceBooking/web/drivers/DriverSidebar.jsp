
<%
    String sbActive = "flex items-center justify-center gap-3 rounded-xl bg-gradient-to-r from-red-700 via-red-600 to-red-500 px-3 py-2.5 text-sm font-semibold text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20 md:justify-start";
    String sbIdle   = "flex items-center justify-center gap-3 rounded-xl border border-transparent px-3 py-2.5 text-sm font-medium text-white/80 transition hover:border-white/25 hover:bg-white/10 hover:text-white md:justify-start";
%>
<aside class="fixed left-3 top-3 bottom-3 z-20 flex w-16 flex-col justify-between rounded-3xl border border-white/20 bg-white/10 p-3 shadow-2xl shadow-red-950/50 backdrop-blur-xl md:left-5 md:top-5 md:bottom-5 md:w-60 md:p-5">
    <div>
        <div class="mb-6 flex items-center justify-center gap-3 md:justify-start">
            <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-2xl bg-red-600/80 shadow-lg shadow-red-700/50 ring-1 ring-white/30">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="2"/>
                    <path d="M12 3v7M12 14v7M3.5 9.5l7 1.5M13.5 13l7 1.5"/>
                </svg>
            </div>
            <span class="hidden text-lg font-bold tracking-tight text-white md:block">Driver Panel</span>
        </div>

        <nav class="space-y-2">
            <a href="DriverDashboard.jsp" title="Home" class="<%= "home".equals(activePage) ? sbActive : sbIdle %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/><path d="M10 20v-6h4v6"/></svg>
                <span class="hidden md:inline">Home</span>
            </a>
            <a href="DriverRequests.jsp" title="All Requests" class="<%= "requests".equals(activePage) ? sbActive : sbIdle %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6h11M9 12h11M9 18h11"/><circle cx="4.5" cy="6" r="1"/><circle cx="4.5" cy="12" r="1"/><circle cx="4.5" cy="18" r="1"/></svg>
                <span class="hidden md:inline">All Requests</span>
            </a>
            <a href="DriverProfile.jsp" title="Profile" class="<%= "profile".equals(activePage) ? sbActive : sbIdle %>">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6 8-6s8 2 8 6"/></svg>
                <span class="hidden md:inline">Profile</span>
            </a>
        </nav>
    </div>

    <a href="DriverDashboard.jsp?action=logout" title="Log out"
       class="flex items-center justify-center gap-3 rounded-xl border border-red-400/40 bg-red-500/20 px-3 py-2.5 text-sm font-semibold text-red-100 backdrop-blur-md transition hover:bg-red-500/40 hover:text-white md:justify-start">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><path d="M16 17l5-5-5-5"/><path d="M21 12H9"/></svg>
        <span class="hidden md:inline">Log out</span>
    </a>
</aside>
