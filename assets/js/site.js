const shell = document.querySelector(".site-shell");
const archiveToggle = document.querySelector("[data-archive-toggle]");

if (shell && archiveToggle) {
  archiveToggle.addEventListener("click", () => {
    const collapsed = shell.classList.toggle("archive-collapsed");
    archiveToggle.setAttribute("aria-expanded", String(!collapsed));
    archiveToggle.setAttribute(
      "aria-label",
      collapsed ? "Expand archive sidebar" : "Minimize archive sidebar"
    );
  });
}
