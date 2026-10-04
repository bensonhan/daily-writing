import unittest

from scripts.check_pr_description import missing_sections


class PullRequestDescriptionTest(unittest.TestCase):
    def test_completed_description_passes(self):
        body = "## Summary\n\n- Explain the change.\n\n## Checks\n\n- `git diff --check`\n"
        self.assertEqual([], missing_sections(body))

    def test_empty_template_fails(self):
        body = (
            "## Summary\n\n<!-- What changed, and why? -->\n\n"
            "## Checks\n\n<!-- List tests or manual checks. -->\n"
        )
        self.assertEqual(["Summary", "Checks"], missing_sections(body))

    def test_missing_checks_fails(self):
        self.assertEqual(["Checks"], missing_sections("## Summary\n\nUpdated the README.\n"))


if __name__ == "__main__":
    unittest.main()
