# Daily Writing

A minimal Jekyll site for titleless daily writing stored one Markdown file per month.

## Add a daily entry

1. Open the current file in `writing`, such as:

```text
writing/2026-10.md
```

If it does not exist yet, create it with:

```markdown
# October 2026
```

The filename must use `YYYY-MM.md`, and its heading should name the month and year.

2. Add the newest date directly below the month heading, followed by the entry:

```markdown
## 2026-10-01

Your writing begins here.

Start a new paragraph after a blank line.
```

Keep entries newest first so the place where you write is always at the top of the file. The site also sorts them by date automatically, so a misplaced entry will not affect the website. The monthly filename and date headings supply the weekday, full display date, permanent URL, archive month, and homepage ordering. The first paragraph—up to 80 words—becomes the feed excerpt, and the homepage always shows the complete latest month.

3. Preview and publish:

```sh
bundle exec jekyll serve
git add writing
git commit -m "Add writing for 2026-10-01"
git push
```

Pushing to `main` triggers the GitHub Pages deployment.

## Run locally

```sh
bundle install
bundle exec jekyll serve
```

Open <http://127.0.0.1:4000>. GitHub Actions deploys the site to GitHub Pages after every push to `main`; enable **Settings → Pages → Source → GitHub Actions** once for a new repository.
