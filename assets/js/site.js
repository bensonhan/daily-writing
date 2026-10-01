const shell = document.querySelector(".site-shell");
const archiveToggle = document.querySelector("[data-archive-toggle]");
const archive = document.querySelector("#desktop-archive");

if (shell && archiveToggle) {
  const storageKey = "archive-sidebar-collapsed";

  const setCollapsed = (collapsed) => {
    shell.classList.toggle("archive-collapsed", collapsed);
    archiveToggle.setAttribute("aria-expanded", String(!collapsed));
    archiveToggle.setAttribute(
      "aria-label",
      collapsed ? "Expand archive sidebar" : "Collapse archive sidebar"
    );

    if (archive) archive.setAttribute("aria-hidden", String(collapsed));
  };

  try {
    setCollapsed(localStorage.getItem(storageKey) === "true");
  } catch {
    setCollapsed(false);
  }

  archiveToggle.addEventListener("click", () => {
    const collapsed = !shell.classList.contains("archive-collapsed");
    setCollapsed(collapsed);

    try {
      localStorage.setItem(storageKey, String(collapsed));
    } catch {
      // The control still works if storage is unavailable.
    }
  });
}
