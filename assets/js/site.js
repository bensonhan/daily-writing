const shell = document.querySelector(".site-shell");
const archiveToggle = document.querySelector("[data-archive-toggle]");
const archive = document.querySelector("#desktop-archive");

// Keep the source links usable even without JavaScript or embedded playback.
document.querySelectorAll(".entry-excerpt, .entry-body").forEach((body) => {
  const embedded = new Set();
  const lastEmbedByParagraph = new Map();

  body.querySelectorAll("a[href]").forEach((link) => {
    let url;
    try {
      url = new URL(link.href);
    } catch {
      return;
    }
    if (url.protocol !== "https:" && url.protocol !== "http:") return;

    const host = url.hostname.toLowerCase();
    let videoId;
    if (host === "youtu.be") {
      videoId = url.pathname.slice(1);
    } else if (["youtube.com", "www.youtube.com", "m.youtube.com"].includes(host)) {
      if (url.pathname === "/watch") {
        videoId = url.searchParams.get("v");
      } else {
        videoId = url.pathname.match(/^\/(?:shorts|embed)\/([^/]+)\/?$/)?.[1];
      }
    }
    if (!/^[A-Za-z0-9_-]{11}$/.test(videoId || "") || embedded.has(videoId)) return;

    const paragraph = link.closest("p");
    if (!paragraph) return;
    embedded.add(videoId);

    const wrapper = document.createElement("div");
    wrapper.className = "youtube-embed";
    const player = document.createElement("iframe");
    player.src = `https://www.youtube-nocookie.com/embed/${videoId}`;
    player.title = `YouTube video: ${link.textContent.trim() || videoId}`;
    player.loading = "lazy";
    player.referrerPolicy = "strict-origin-when-cross-origin";
    player.allow = "encrypted-media; picture-in-picture; fullscreen";
    player.allowFullscreen = true;
    wrapper.append(player);
    (lastEmbedByParagraph.get(paragraph) || paragraph).after(wrapper);
    lastEmbedByParagraph.set(paragraph, wrapper);
  });
});

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
