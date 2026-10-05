
<%
    String navActiveCls = "bg-gradient-to-r from-red-700 via-red-600 to-red-500 font-semibold text-white shadow-lg shadow-red-700/40 ring-1 ring-white/20";
    String navIdleCls   = "font-medium text-white/80 transition hover:bg-white/15 hover:text-white";
%>


<aside class="fixed left-4 top-4 bottom-4 z-50 flex w-16 flex-col rounded-3xl border border-white/20 bg-white/10 p-3 shadow-2xl shadow-red-950/50 backdrop-blur-xl md:w-60 md:p-4">


    <div class="mb-6 flex items-center justify-center gap-3 md:justify-start">
        <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-red-600/80 shadow-lg shadow-red-700/50 ring-1 ring-white/30">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 5v14M5 12h14"/>
            </svg>
        </div>
        <span class="hidden text-lg font-bold tracking-tight text-white md:block">Dashboard</span>
    </div>

    <nav class="flex flex-col gap-2">

        <a href="UserDashboard.jsp"
           class="flex items-center justify-center gap-3 rounded-xl px-3 py-2.5 md:justify-start <%= "home".equals(activePage) ? navActiveCls : navIdleCls %>">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 10.5 12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z"/>
            </svg>
            <span class="hidden md:block">Home</span>
        </a>

        <a href="UserAmbulanceBook.jsp"
           class="flex items-center justify-center gap-3 rounded-xl px-3 py-2.5 md:justify-start <%= "book".equals(activePage) ? navActiveCls : navIdleCls %>">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="16" rx="3"/>
                <path d="M12 8v8M8 12h8"/>
            </svg>
            <span class="hidden md:block">Book Ambulance</span>
        </a>

        <a href="UserProfile.jsp"
           class="flex items-center justify-center gap-3 rounded-xl px-3 py-2.5 md:justify-start <%= "profile".equals(activePage) ? navActiveCls : navIdleCls %>">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="8" r="4"/>
                <path d="M4 21c0-4 4-6 8-6s8 2 8 6"/>
            </svg>
            <span class="hidden md:block">Profile</span>
        </a>
    </nav>

    <a href="logout.jsp"
       class="mt-auto flex items-center justify-center gap-3 rounded-xl border border-red-400/40 bg-red-500/20 px-3 py-2.5 font-semibold text-red-100 transition hover:bg-red-500/40 hover:text-white md:justify-start">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <path d="M16 17l5-5-5-5M21 12H9"/>
        </svg>
        <span class="hidden md:block">Logout</span>
    </a>
</aside>
