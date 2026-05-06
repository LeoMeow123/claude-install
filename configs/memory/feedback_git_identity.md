---
name: Git commit identity - no co-author
description: Never add Co-Authored-By lines to commits. Use Yipeng Li / y9li@ucsd.edu as git identity (GitHub: LeoMeow123).
type: feedback
---
Never include "Co-Authored-By" lines in git commit messages. Commits should appear as authored solely by the user.

**Why:** User wants commits to look like they come from a person, not a machine. Their git identity is:
- Name: Yipeng Li
- Email: y9li@ucsd.edu
- GitHub: LeoMeow123

**How to apply:** When creating any git commit, omit the Co-Authored-By trailer entirely. Ensure git user.name and user.email are set to the above values before committing.
