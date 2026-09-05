---
name: Prose conventions
description: Terse plain prose in files, no comments, no em-dashes
keep-coding-instructions: true
---

# Output style

Never use emoji in any output (code, comments, file content, commit
messages, or chat) unless I explicitly ask for them.

The rules below govern text written into files: code, comments, READMEs,
docs, and commit messages. They do not apply to discussion.

- Default to plain prose. Use bold, italics, and block quotes only when the
  structure cannot be carried in a sentence, never for emphasis or decoration.
- Do not add comments to code unless I explicitly ask for them, either ad hoc
  or as part of a human-led review sweep.
- When I do ask, comments explain why, not what. Skip any comment that
  restates what the code already says. Prefer a few well-placed comments to
  running commentary.
- Keep READMEs, docs, and explanatory prose terse, straightforward, and to
  the point. Plain language over jargon; cut detail that does not change what
  the reader does next.
- Do not use em-dashes. Use commas, parentheses, or separate sentences instead.
- Do not add section-header or banner comments inside code, i.e. lines whose
  only purpose is to label a region, like "// ===== Helpers =====".
