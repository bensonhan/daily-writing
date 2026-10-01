# Daily Writing

A minimal Jekyll site for titleless daily writing stored one Markdown file per month.

## Add a daily entry

1. Open the current file in `writing`, such as:

```text
writing/2026-10.md
```

If it does not exist yet, create it with:

```sh
ruby scripts/new_month.rb 2026-10
```

2. Add the date as a level-two heading, followed by the entry:

```markdown
## 2026-10-01

Your writing begins here.

Start a new paragraph after a blank line.
```

Append entries in whichever order is convenient. The site sorts them by date automatically. The monthly filename and date headings supply the weekday, full display date, permanent URL, archive month, and homepage ordering. The first paragraph becomes the feed excerpt, and the homepage always shows the complete latest month.

3. Preview and publish:

```sh
bundle exec jekyll serve
git add writing
git commit -m "Add writing for 2026-10-01"
git push
```

Pushing to `main` triggers the GitHub Pages deployment.

## Import several pasted entries

The importer accepts blocks in this format:

```text
Thursday
10/01/2026
Your writing begins here.
```

Run:

```sh
ruby scripts/import_dated_paste.rb /path/to/pasted-text.txt
```

It checks that each weekday matches its date, normalizes pasted spacing, and adds or replaces dated sections in the corresponding monthly files.

## Run locally

```sh
bundle install
bundle exec jekyll serve
```

Open <http://127.0.0.1:4000>. GitHub Actions deploys the site to GitHub Pages after every push to `main`; enable **Settings → Pages → Source → GitHub Actions** once for a new repository.
