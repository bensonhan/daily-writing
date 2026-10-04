# Daily Writing

A minimal Jekyll site for titleless daily writing. Write in Google Docs, then upload one export per month.

## Publish a month from Google Docs

1. Use one Google Doc per month. Start each entry with its date on a line by itself. These formats all work:

```text
October 3, 2026
Saturday, October 3, 2026
10/3/2026
2026-10-03
```

An optional `October 2026` title may appear before the first entry. Put each paragraph in its own Google Docs paragraph. The order of entries does not matter.

For the cleanest Markdown export, make the optional month title **Heading 1** and each date **Heading 2** in Google Docs. Plain date lines work too.

2. At the end of the month, choose **File → Download → Markdown (.md)**. Markdown is preferred because it preserves paragraphs and basic formatting without conversion ambiguity. Plain text (`.txt`), Word (`.docx`), and PDF are also accepted; PDF is the least reliable because it stores visual line wrapping instead of document structure.

3. Rename the export to `YYYY-MM.md` and put it in `uploads`, for example:

```text
uploads/2026-10.md
```

Upload only one file for each month. Text-only documents work best; embedded images and tables are not supported.

4. Upload it on GitHub: open the `uploads` folder, choose **Add file → Upload files**, drag in the export, and commit the change. Or use Git:

```sh
git add uploads/2026-10.md
git commit -m "Publish October writing"
git push
```

The GitHub Pages workflow normalizes the upload into the site's existing monthly Markdown format and then deploys it. The generated file is build-only; your uploaded export remains the source of truth.

## Preview an upload locally

Install the importer once, convert the uploads, and start Jekyll:

```sh
python3 -m pip install -r requirements-import.txt
python3 scripts/import_writing.py
bundle exec jekyll serve
```

Open <http://127.0.0.1:4000>. Generated files go in `.generated-writing/`, which Git ignores.

## Legacy Markdown format

Existing months can remain in `writing/YYYY-MM.md`. A month must come from either `writing` or `uploads`, not both. The Markdown format is:

```markdown
# October 2026

## 2026-10-01

Your writing begins here.
```

The site sorts entries by date automatically. The first paragraph—up to 80 words—becomes the feed excerpt, and the homepage shows the complete latest month.

## Run locally

```sh
bundle install
bundle exec jekyll serve
```

GitHub Actions deploys the site to GitHub Pages after every push to `main`; enable **Settings → Pages → Source → GitHub Actions** once for a new repository.
